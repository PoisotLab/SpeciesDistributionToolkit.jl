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
"""
function tessellate(
    obj::T,
    d::Float64;
    tile::Symbol = :hexagons,
    padding::Number = 0.0,
    kwargs...,
) where {T <: TessellateTypes}
    tilers = Dict(:hexagons => hexagons, :squares => squares, :triangles => triangles)
    if !(tile in keys(tilers))
        throw(
            ArgumentError(
                "The tile $(tile) is invalid -- correct options are hexagons, squares, and triangles",
            ),
        )
    end
    _tfunc = tilers[tile]
    H = _tfunc(boundingbox(obj; padding = padding), d; kwargs...)
    keeprelevant!(H, obj)
    return H
end

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

function keeprelevant!(H::FeatureCollection, G::SimpleSDMPolygons.AbstractGeometry)
    idx_to_delete = Integer[]
    for (i, f) in enumerate(H.features)
        try
            cut = intersect(G, f).features[1].geometry.geometry
            if SimpleSDMPolygons.AG.isempty(cut)
                push!(idx_to_delete, i)
            end
        catch err
            continue
        end
    end
    deleteat!(H.features, idx_to_delete)
    return H
end

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

function keeprelevant(H::FeatureCollection, obj::T) where {T <: TessellateTypes}
    J = deepcopy(H)
    keeprelevant!(J, obj)
    return J
end
