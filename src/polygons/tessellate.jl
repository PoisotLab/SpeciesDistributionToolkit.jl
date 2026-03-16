function _square(p, s = 1.0)
    pts = [
        (p[1] - s / 2, p[2] + s / 2),
        (p[1] + s / 2, p[2] + s / 2),
        (p[1] + s / 2, p[2] - s / 2),
        (p[1] - s / 2, p[2] - s / 2),
    ]
    push!(pts, first(pts))
    return pts
end

function _hexagon(p, s = 1.0; pointy::Bool = false)
    offset = pointy ? 0 : π / 6
    pts = [
        (p[1] + s * sin(k * π / 3 + offset), p[2] + s * cos(k * π / 3 + offset)) for
        k in 1:6
    ]
    push!(pts, first(pts))
    return pts
end

function hexagons(bbox::NamedTuple, d::Float64; offset = (0.0, 0.0), pointy::Bool = false)
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(
        ArgumentError(
            "Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right",
        ),
    )

    # This is the first center
    origin = (bbox.left - offset[1], bbox.top + offset[2])

    # We estimate the span at the middle of the latitude
    middle_latitude = (bbox.top + bbox.bottom) / 2
    middle_longitude = (bbox.left + bbox.right) / 2

    # We start by estimating the size of the circumradius at the middle latitude
    # of the boundingbox
    km_per_deg = cos(middle_latitude * π / 180) * 111325.0 / 1000.0

    # We want to get the circumradius in units of degrees
    R = (d/2) / km_per_deg

    # Then we get the inradius from this value
    r = (sqrt(3.0) / 2) * R

    # Now we measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(bbox.right - origin[1])
    H = abs(bbox.bottom - origin[2])

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need

    w = ceil(Int, W / (3R))
    h = ceil(Int, H / (2r))

    # If this is a pointy side up tiling, we need to accurately reflect this
    if pointy
        w = ceil(Int, W / (2r))
        h = ceil(Int, H / (3R))
    end

    # Now we generate the grid of hexagons
    grid = Tuple{Float64, Float64}[]

    # We always do one more bin than required just in case I guess? Anyway it
    # will be intersected after this is done, so it doesn't matter.
    for row in 0:(h + 1)
        for col in 0:(w + 1)
            # Note that here col is the column number, but we need to generate
            # two cells: the one at the coordinates, and the one horizontally on
            # the inter-column

            if pointy
                # This is a pointy side up tiling, where the rows are continuous
                # along the width
                px = origin[1] + 2r * (col - 1)
                py = origin[2] - 3R * (row - 1)

                # Now we create the shifted polygon
                p2x = px - r
                p2y = py - (3 / 2)R

            else
                # This is the flat side up tiling, where the columns are
                # continuous along the height

                # The position for the cell on the column is easy to get
                px = origin[1] + 3 * R * (col - 1)
                py = origin[2] - 2 * r * (row - 1)

                # The position for the other cell is not terribly difficult either
                p2x = px + (3 / 2) * R
                p2y = py - r
            end

            append!(grid, [(px, py), (p2x, p2y)])
        end
    end

    # Now we can return the polygons
    polys = [
        Feature(
            Polygon(_hexagon(g, R; pointy = pointy)),
            Dict{String, Any}("__centroid" => g),
        ) for g in grid
    ]

    return FeatureCollection(polys)
end

function squares(bbox::NamedTuple, d::Float64; offset = (0.0, 0.0))
    all(haskey(bbox, k) for k in [:left, :bottom, :right, :top]) || throw(
        ArgumentError(
            "Bounding box tuple doesn't have correct keys. It must contain :top, :bottom, :left, and :right",
        ),
    )

    # This is the first center
    origin = (bbox.left - offset[1], bbox.top + offset[2])

    # We estimate the span at the middle of the latitude
    middle_latitude = (bbox.top + bbox.bottom) / 2

    # We start by estimating the size of the circumradius at the middle latitude
    # of the boundingbox
    km_per_deg = cos(middle_latitude * π / 180) * 111325.0 / 1000.0

    # We want to get the size of the square in units of degrees
    s = d / km_per_deg

    # Now we measure the distance from the origin to the right / bottom of the
    # bounding box - these distances are measured in degree
    W = abs(bbox.right - origin[1])
    H = abs(bbox.bottom - origin[2])

    # Now we want to know how many hexagons we must add. The first one starts at
    # the origin point, so to cover the full width, we need

    w = ceil(Int, W / s)
    h = ceil(Int, H / s)

    # Now we generate the grid of squares
    grid = Tuple{Float64, Float64}[]

    # We always do one more bin than required just in case I guess? Anyway it
    # will be intersected after this is done, so it doesn't matter.
    for row in 0:(h + 1)
        for col in 0:(w + 1)
            px = origin[1] + s * (col - 1)
            py = origin[2] - s * (row - 1)

            push!(grid, (px, py))
        end
    end

    # Now we can return the polygons
    polys = [
        Feature(
            Polygon(_square(g, s)),
            Dict{String, Any}("__centroid" => g),
        ) for g in grid
    ]
    
    return FeatureCollection(polys)
end

const TessellateTypes = Union{
    AbstractSDM,
    SimpleSDMPolygons.AbstractGeometry,
    SDMLayer,
    AbstractOccurrenceCollection,
}

function tessellate(
    obj::T,
    d::Float64;
    tile::Symbol = :hexagons,
    padding::Number = 0.0,
    kwargs...,
) where {T <: TessellateTypes}
    _tfunc = Dict(:hexagons => hexagons, :squares => squares)[tile]
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

function cvlabel!(
    H::FeatureCollection;
    n::Integer = 10,
    order::Symbol = :random,
    maxiter::Integer = 1000,
)
    k = length(H.features)
    fold = repeat(1:n; outer = ceil(Int, k / n))[1:k]

    # Get the centers
    centers = [f.properties["__centroid"] for f in H.features]

    # Sort the centers randomly by default
    sortfunc = (x) -> rand()

    # Change the sorting function depending on the type of layout
    if order == :VH
        sortfunc = (x) -> (x[1], x[2])
    end
    if order == :HV
        sortfunc = (x) -> (x[2], x[1])
    end
    if order == :H
        sortfunc = (x) -> x[1]
    end
    if order == :V
        sortfunc = (x) -> x[2]
    end

    feature_rank = sortperm(centers; by = sortfunc)

    # For balanced layout, we need to do something a little more consuming in resources
    if order == :balanced
        @assert "__presences" in keys(uniqueproperties(H))
        @assert "__absences" in keys(uniqueproperties(H))
        pr = [f.properties["__presences"] for f in H.features]
        ab = [f.properties["__absences"] for f in H.features]
        ba = sum(pr) ./ sum(pr .+ ab)

        # We want to map the features to folds- and for this we need to figure
        # out a way to do this that maintains balance. The challenge is that we
        # also want to ensure that the folds have approximately the same membership.

        # We start from the initial situation, and we generate a vector of idx
        # for each fold
        feature_rank = collect(1:k)

        # The score of this assignment is given by:

        PRs = [sum(pr[findall(==(f), fold[feature_rank])]) for f in 1:n]
        ABs = [sum(ab[findall(==(f), fold[feature_rank])]) for f in 1:n]
        BA = PRs ./ (PRs .+ ABs)

        # Current error
        ε₀ = sqrt(sum((BA .- ba) .^ 2.0))

        # Iterate
        for _ in Base.OneTo(maxiter)
            i, j = rand(eachindex(feature_rank), 2)
            candidate = copy(feature_rank)
            candidate[i], candidate[j] = candidate[j], candidate[i]
            cPRs = [sum(pr[findall(==(f), fold[candidate])]) for f in 1:n]
            cABs = [sum(ab[findall(==(f), fold[candidate])]) for f in 1:n]
            cBA = cPRs ./ (cPRs .+ cABs)
            εₜ = sqrt(sum((cBA .- ba) .^ 2.0))
            if εₜ < ε₀
                feature_rank[:] .= candidate[:]
                ε₀ = εₜ
            end
        end
    end

    # Finally we add the outputs to the polygon features
    for (i, r) in enumerate(feature_rank)
        H.features[r].properties["__fold"] = fold[i]
        H.features[r].properties["__order"] = i
    end

    return H
end

function spatialfold(model::SDM, blocks::FeatureCollection)
    @assert "__fold" in keys(uniqueproperties(blocks))
    folds = Tuple{Vector{Int64}, Vector{Int64}}[]

    for fold in Base.OneTo(maximum(uniqueproperties(blocks)["__fold"]))
        occ = mask(model, blocks["__fold" => fold])
        test = sort(indexin(place(occ), place(model)))
        train = setdiff(eachindex(labels(model)), test)
        push!(folds, (train, test))
    end
    return folds
end

function spatialfold(blocks::FeatureCollection)
    return (model::SDM) -> spatialfold(model, blocks)
end