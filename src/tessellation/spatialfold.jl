"""
    assignfolds!(H::FeatureCollection; n::Integer=10, order::Symbol=:balanced, group::Bool=true, maxiter::Integer = 2000)

Assigns the features in a tiling (or any other `FeatureCollection`) to `n`
blocks for spatial cross-validation. Note that the features in `H` _must_ have a
`__centroid` property which indicates where the _center_ of each cell is.
    
The `order` keyword will determine how the tiles are assigned. When using
`:horizontal` or `:vertical`, the tiles will be assigned either horizontally, or
vertically. In this case, the keyword `group` will determine how the folds are
assigned. When `group` is `true` (the default), folds are _spatially
contiguous_. When `group` is `false`, folds are _spatially alternating_.

When `order` is `:balanced`, the tiles _must_ have both `__presences` and
`__absences` properties. The assignment of a tile to folds is done by using a
greedy algorithm (for up to `maxiter` rounds) which will swap tiles across folds
until all folds are as close as possible to reaching the class imbalance of the
entire dataset. This is the default ordering of tiles.

When `order` is `:random`, the tiles are assigned fully at random.

This method changes the feature collection by adding a `__fold` property to each
tiles, which can be used in conjunction with `spatialfold`.
"""
function assignfolds!(
    H::FeatureCollection;
    n::Integer = 10,
    order::Symbol = :random,
    balanced::Bool = false,
    group::Bool = true,
    maxiter::Integer = 2000,
)
    k = length(H.features)

    if k < n
        throw(
            ArgumentError(
                "There are more folds to be allocated ($n) than there are available features ($k)",
            ),
        )
    end

    fold = repeat(1:n; outer = ceil(Int, k / n))[1:k]

    if group
        sort!(fold)
    end
    
    # Get the centers
    centers = [f.properties["__centroid"] for f in H.features]
    x = first.(centers)
    y = last.(centers)

    x = (x .- minimum(x)) ./(maximum(x) - minimum(x))
    y = (y .- minimum(y)) ./(maximum(y) - minimum(y))

    # Sort the centers randomly by default
    feature_rank = sortperm(centers; by = (v) -> rand())

    # Change the sorting function depending on the type of layout
    if order == :vertical
        feature_rank = sortperm(x)
    end
    if order == :horizontal
        feature_rank = sortperm(y)
    end
    if order == :slice
        feature_rank = sortperm((x .- y)./(x .+ y))
    end
    
    # For balanced layout, we need to do something a little more consuming in resources
    if balanced
        @assert "__presences" in keys(uniqueproperties(H))
        @assert "__absences" in keys(uniqueproperties(H))
        pr = [f.properties["__presences"] for f in H.features]
        ab = [f.properties["__absences"] for f in H.features]
        ba = sum(pr) ./ sum(pr .+ ab)

        # We want to map the features to folds- and for this we need to figure
        # out a way to do this that maintains balance. We also would like the
        # folds to remain contiguous in space as much as possible.

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
            # Error on balance
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

"""
    spatialfold(model::SDM, blocks::FeatureCollection)

Returns a series of training, validation folds, as a vector of tuple of vectors.
This is the same output returned by all cross-validation functions such as
`kfold` and `leaveoneout`.

The folds are assigned by looking at the `"__fold"` property of the feature
collection. It will likely have been set by `assignfolds!`.
"""
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

"""
    spatialfold(blocks::FeatureCollection)

Creates a closure which, when applied to a model, will return the
training,validation folds.
"""
function spatialfold(blocks::FeatureCollection)
    return (model::SDM) -> spatialfold(model, blocks)
end

function __identify_neighbors(T::FeatureCollection)
    edges = Dict{Integer, Vector{Integer}}([i => Integer[] for i in eachindex(T.features)])
    for i in eachindex(edges)
        for j in eachindex(edges)
            if j >= i
                if SimpleSDMPolygons.AG.touches(
                    T.features[i].geometry.geometry,
                    T.features[j].geometry.geometry,
                )
                    push!(edges[i], j)
                    push!(edges[j], i)
                end
            end
        end
    end
    return edges
end
