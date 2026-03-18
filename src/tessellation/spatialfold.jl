"""
    cvlabel!(H::FeatureCollection; n::Integer=10, order::Symbol=:balanced, maxiter::Integer = 2000)

Assigns the features in a tiling (or any other `FeatureCollection`) to `n`
blocks for spatial cross-validation.
    
The `order` keyword will determine how the tiles are assigned. When using `:N`,
`:E`, `:EN`, or `:NE`, the tile will be first sorted by (resp.) northing,
easting, easting then northing, and northing then easting, then assigned to the
folds. Note that the features in `H` _must_ have a `__centroid` property.

When `order` is `:balanced`, the tiles _must_ have both `__presences` and
`__absences` properties. The assignment of a tile to folds is done by using a
greedy algorithm (for up to `maxiter` rounds) which will swap tiles across folds
until all folds are as close as possible to reaching the class imbalance of the
entire dataset. This is the default ordering of tiles.

When `order` is `:random`, the tiles are assigned fully at random.

This method changes the feature collection by adding a `__fold` property to each
tiles, which can be used in conjunction with `spatialfold`.
"""
function cvlabel!(
    H::FeatureCollection;
    n::Integer = 10,
    order::Symbol = :random,
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