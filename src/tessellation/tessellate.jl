const TessellateTypes = Union{
    AbstractSDM,
    SimpleSDMPolygons.AbstractGeometry,
    SDMLayer,
    AbstractOccurrenceCollection,
}

"""
    tessellate(obj::T, d::Float64; tile::Symbol=:hexagons, keywords...)

This function will take an argument `obj` that is either an `AbstractSDM`, an
`AbstractGeometry`, an `SDMLayer`, or an `AbstractOccurrenceCollection`, and
return a tessellation at a distance `d` (in kilometers).

Because the shapes that can be used for the tiling differ (see below), the
distance `d` is assumed to be the _radius_ of a circle. This information is then
converted to identify the size of the tile that would have an _equal area_ to
that of this circle. This ensure that regardless of the shape of the tile that
is chosen, the _surface_ they cover is equivalent.

The tessellation is done by picking the upper left corner of the bounding box as
the reference point, and working from here, down/right-wards. The shape of the
tiles are controlled by the `tile` arguments, which can take three values:
`:hexagons`, `:square`, and `:triangles`. The default is flat side up hexagons.

The tiling is returned as a `FeatureCollection` containing features that are all
`Polygon`. The features all gain a `__centroid` property, giving the
latitude/longitude of the centroid of the tile, as well as `__tile` (always
`true`). Either of these can be used to check that the feature collection was
produced through the `tessellate` function.

After the tessellation is finished, all tiles are inspected to ensure that they
overlap with the geometry of interest, so that _only the relevant tiles_ are
returned. At this stage, in addition to `__centroid`, the features representing
each tile gain additional propeties.

If the object is an `SDMLayer`, the number of cells that are contained within
the tile is stored in `__cells`. If the object is an
`AbstractOccurrenceCollection` (note that this includes `AbstractSDM`), the
features gain `__presences` and `__absences`, which store the number of
presence/absences in each tile.

**Keyword arguments:**

  - `tile`: the shape of tiles (as explained above, defaults to `:hexagons`)
  - `padding`: a padding to be added to the boundingbox of the object to
    tessellate; this defaults to `0`
  - `pointy`: for `:hexagons` tiles, whether they are draw pointy side or flat
    side up
  - `densify`: defaults to `0`, the number of additional points to draw along
    each segment of the polygon; this may help to increase it when the polygons
    are large, and the projection distorts them
  - `proj`: defaults to `"EPSG:4326"`, the projection in which the tiles will be
    generated; note that the tiles are *always* returned as long./lat.
"""
function tessellate(
    obj::T,
    d::Float64;
    tile::Symbol = :hexagons,
    padding::Number = 0.0,
    proj = "EPSG:4326",
    densify::Integer = 0,
    kwargs...,
) where {T <: TessellateTypes}

    # Get the boundingbox
    bbox = boundingbox(obj; padding = padding)

    if proj isa String
        proj = SimpleSDMLayers._parse_projection_from_string(proj)
    end

    # Units of the CRS
    unit = SimpleSDMPolygons.AG.getattrvalue(proj, "UNIT", 0)

    if unit == "metre"
        # We get the distance in meters
        d = d * 1000.0
    elseif unit == "degree"
        # We get the distance in degrees at the median latitude
        middle_latitude = (bbox.top + bbox.bottom) / 2
        km_per_deg = cos(middle_latitude * π / 180) * 111325.0 / 1000.0
        d = d / km_per_deg
    elseif unit == "foot"
        d = d * 3280.84
    else
        @error "Unuspported units ($unit) found"
    end

    # We convert the distance so that the surface of each tile is equal to the
    # surface of a circle of radius d
    chara_distance = __equivalent_area(d, tile)

    # Get the upper left and lower right corners here, with the correct projection
    origin, destination = __corners_from_bbox(bbox, proj)

    # This picks the correct tiling function
    tiler = __tiling_function(tile)

    # This will create the tile based on the arguments checked before
    H = tiler(
        origin,
        destination,
        chara_distance;
        kwargs...,
    )

    # Now we bring this to lon/lat
    prj = SpeciesDistributionToolkit._projector(
        SimpleSDMLayers.AG.toPROJ4(proj),
        "EPSG:4326",
    )

    # Now we need to densify the projection a little, so that each polygon
    # receives intermediate points. This will make the projected data smoother
    # when at high latitudes.

    # We return everything now
    out = [
        Feature(
            Polygon(prj.(__densify(h.cycle, densify))),
            Dict{String, Any}("__centroid" => prj(h.centroid)),
        ) for h in H
    ]
    F = FeatureCollection(out)

    keeprelevant!(F, obj)

    return F
end

function __densify(cycle::Vector{Tuple{Float64, Float64}}, n = 0)
    progress = LinRange(0.0, 1.0, n + 2)
    newcycle = Tuple{Float64, Float64}[]
    for i in eachindex(cycle)
        if i > 1
            p2, p1 = cycle[i], cycle[i - 1]
            Δx = p1[1] .+ (p2[1] .- p2[1]) .* progress
            Δy = p1[2] .+ (p2[2] .- p2[2]) .* progress
            append!(newcycle, [(Δx[j], Δy[j]) for j in eachindex(progress)])
        end
    end
    return newcycle
end

"""
    keeprelevant!(H::FeatureCollection, L::SDMLayer)

Removes the tiles from a feature collection that do not have at least one cell
of the layer given as second argument.
"""
function keeprelevant!(H::FeatureCollection, L::SDMLayer)
    idx_to_delete = Integer[]
    for (i, f) in enumerate(H.features)
        n = length(mask(L, f))
        if n > 0
            f.properties["__cells"] = n
        else
            push!(idx_to_delete, i)
        end
    end
    deleteat!(H.features, idx_to_delete)
    return H
end

"""
    keeprelevant!(H::FeatureCollection, G::SimpleSDMPolygons.AbstractGeometry)

Removes the tiles from a feature collection that do not have a non-empty
intersect with the geometry given as second argument.
"""
function keeprelevant!(H::FeatureCollection, G::SimpleSDMPolygons.AbstractGeometry)
    idx_to_delete = Integer[]
    for (i, f) in enumerate(H.features)
        try
            cut = intersect(f, G)
            if _mt_pol(cut)
                push!(idx_to_delete, i)
            end
        catch err
        end
    end
    deleteat!(H.features, idx_to_delete)
    return H
end

_mt_pol(f::FeatureCollection) = any(_mt_pol.(f.features))
_mt_pol(f::Feature) = _mt_pol(f.geometry)
_mt_pol(f::SimpleSDMPolygons.AbstractGeometry) = SimpleSDMPolygons.AG.isempty(f.geometry)

"""
    keeprelevant!(H::FeatureCollection, occ::AbstractOccurrenceCollection)

Removes the tiles from a feature collection that do not contain at least one
occurrence (presence or absence) from the collection given as second argument.
"""
function keeprelevant!(H::FeatureCollection, occ::AbstractOccurrenceCollection)
    idx_to_delete = Integer[]
    for (i, f) in enumerate(H.features)
        incl = mask(occ, f)
        if isempty(incl)
            push!(idx_to_delete, i)
        else
            f.properties["__presences"] = length(presences(Occurrences(incl)))
            f.properties["__absences"] = length(absences(Occurrences(incl)))
        end
    end
    deleteat!(H.features, idx_to_delete)
    return H
end

"""
    keeprelevant(H::FeatureCollection, obj::T) where {T <: TessellateTypes}

Apply `keeprelevant!` on a copy of the feature collection.
"""
function keeprelevant(H::FeatureCollection, obj::T) where {T <: TessellateTypes}
    J = deepcopy(H)
    keeprelevant!(J, obj)
    return J
end

function __tiling_function(tile::Symbol)
    tilers = Dict(:hexagons => hexagons, :squares => squares, :triangles => triangles)
    if !(tile in keys(tilers))
        throw(
            ArgumentError(
                "The tile $(tile) is invalid -- correct options are hexagons, squares, and triangles",
            ),
        )
    end
    return tilers[tile]
end

function __equivalent_area(d::Float64, shape::Symbol)
    𝑨 = π * d * d
    if shape == :squares
        return sqrt(𝑨)
    end
    if shape == :triangles
        bl = sqrt(4𝑨 / sqrt(3))
        alt = (sqrt(3) / 2) * bl
        return alt
    end
    if shape == :hexagons
        return sqrt(2𝑨 / (3 * sqrt(3)))
    end
    return nothing
end

function __corners_from_bbox(bbox::NamedTuple, proj)
    # Step 1 - make the bbox denser
    L, B, R, T = bbox[:left], bbox[:bottom], bbox[:right], bbox[:top]
    side1 = [(L, i) for i in LinRange(B, T, 70)]
    side2 = [(i, T) for i in LinRange(L, R, 70)]
    side3 = [(R, i) for i in LinRange(T, B, 70)]
    side4 = [(i, B) for i in LinRange(R, L, 70)]
    cycle = vcat(side1, side2, side3, side4)

    # Step 2 - convert all points
    prj = SpeciesDistributionToolkit._projector(
        "EPSG:4326",
        SimpleSDMLayers.AG.toPROJ4(proj),
    )
    projected_cycle = prj.(cycle)

    # Step 3 - get the two corners we care about
    origin = (minimum(first.(projected_cycle)), maximum(last.(projected_cycle)))
    destination = (maximum(first.(projected_cycle)), minimum(last.(projected_cycle)))

    return origin, destination
end