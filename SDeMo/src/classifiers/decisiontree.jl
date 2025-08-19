Base.@kwdef mutable struct DecisionNode
    parent::Union{DecisionNode, Nothing} = nothing
    left::Union{DecisionNode, Nothing} = nothing
    right::Union{DecisionNode, Nothing} = nothing
    variable::Integer = 0
    value::Float64 = 0.0
    prediction::Float64 = 0.5
    visited::Bool = false
end

function _is_in_node_parent(::Nothing, X)
    return [true for _ in axes(X, 2)]
end

function _is_in_node_parent(dn::DecisionNode, X)
    if isnothing(dn.parent)
        return [true for _ in axes(X, 2)]
    end
    to_the_left = X[dn.parent.variable, :] .< dn.parent.value
    if dn == dn.parent.left
        return to_the_left
    else
        return map(!, to_the_left)
    end
end

_pool(::Nothing, X) = _is_in_node_parent(nothing, X)

function _pool(dn::DecisionNode, X)
    return _is_in_node_parent(dn, X) .& _pool(dn.parent, X)
end

function train!(dn::DecisionNode, X, y; kwargs...)
    if dn.visited
        return dn
    end
    dn.visited = true
    current_entropy = SDeMo._entropy(y)
    dn.prediction = mean(y)
    if current_entropy > 0.0
        best_gain = -Inf
        best_split = (0, 0.0)
        found = false
        pl, pr = (0.0, 0.0)
        for vᵢ in axes(X, 1)
            x = unique(X[vᵢ, :])
            for xᵢ in x
                n_left = 0
                s_left = 0
                for k in axes(X, 2)
                    if X[vᵢ, k] < xᵢ
                        n_left += 1
                        s_left += y[k]
                    end
                end
                n_right = length(y) - n_left
                p_left = n_left / length(y)
                p_right = 1.0 - p_left
                s_right = sum(y) - s_left
                e_left = SDeMo._entropy(s_left / n_left)
                e_right = SDeMo._entropy(s_right / n_right)
                IG = current_entropy - p_left * e_left - p_right * e_right
                if (IG > best_gain) & (IG > 0.0)
                    best_gain = IG
                    best_split = (vᵢ, xᵢ)
                    pl, pr = p_left, p_right
                    found = true
                end
            end
        end
        if found
            dn.variable, dn.value = best_split
            # New node
            vl = isone(pl) .| iszero(pl)
            vr = isone(pr) .| iszero(pr)
            dn.left = SDeMo.DecisionNode(; parent = dn, prediction = pl, visited = vl)
            dn.right = SDeMo.DecisionNode(; parent = dn, prediction = pr, visited = vr)
        end
    end
    return dn
end

@testitem "We can train a decision stub" begin
    X, y = SDeMo.__demodata()
    stub = DecisionTree()
    # Turn the tree into a stub - a single depth and two nodes
    hyperparameters!(stub, :maxdepth, 1)
    hyperparameters!(stub, :maxnodes, 2)
    # Train the stub
    train!(stub, y, X)
    @test SDeMo.depth(stub) == 1
    # Make a prediction
    ŷ = predict(stub, X)
    @test length(unique(ŷ)) == 2
end

"""
    DecisionTree

The depth and number of nodes can be adjusted with `maxnodes!` and `maxdepth!`.
"""
Base.@kwdef mutable struct DecisionTree <: Classifier
    root::DecisionNode = DecisionNode()
    maxnodes::Integer = 12
    maxdepth::Integer = 7
end

hyperparameters(::Type{DecisionTree}) = (:maxnodes, :maxdepth)

@testitem "A DecisionTree has hyper-parameters" begin
    @test :maxnodes in hyperparameters(DecisionTree)
    @test :maxdepth in hyperparameters(DecisionTree)
end

@testitem "We can operate on the hyper-parameters of a DecisionTree" begin
    D = DecisionTree()
    hyperparameters!(D, :maxnodes, 8)
    @test hyperparameters(D, :maxnodes) == 8
end

function maxnodes!(dt::DecisionTree, n::Integer)
    @warn "DEPRECATED - use hyperparameters!(tree, :maxnodes, $(n))"
    dt.maxnodes = n
    return dt
end
function maxdepth!(dt::DecisionTree, n::Integer)
    @warn "DEPRECATED - use hyperparameters!(tree, :maxdepth, $(n))"
    dt.maxdepth = n
    return dt
end

function maxnodes!(sdm::SDM, n)
    @warn "DEPRECATED - use hyperparameters!(classifier(sdm), :maxnodes, $(n))"
    if sdm.classifier isa DecisionTree
        maxnodes!(sdm.classifier, n)
        return sdm
    end
    return sdm
end
function maxdepth!(sdm::SDM, n)
    @warn "DEPRECATED - use hyperparameters!(classifier(tree), :maxdepth, $(n))"
    if sdm.classifier isa DecisionTree
        maxdepth!(sdm.classifier, n)
        return sdm
    end
    return sdm
end

tips(::Nothing) = nothing
tips(dt::DecisionTree) = tips(dt.root)
function tips(dn::SDeMo.DecisionNode)
    if iszero(dn.variable)
        return [dn]
    else
        return vcat(tips(dn.left), tips(dn.right))
    end
end

depth(dt::DecisionTree) = maximum(depth.(tips(dt))) - 1
depth(dn::DecisionNode) = 1 + depth(dn.parent)
depth(::Nothing) = 0

function merge!(dn::DecisionNode)
    dn.variable = 0
    dn.value = 0
    dn.left = nothing
    dn.right = nothing
    return dn
end

_entropy(x::T) where {T <: AbstractFloat} = -(x * log2(x) + (1.0 - x) * log2(1.0 - x))
_entropy(x::Vector{Bool}) = _entropy(mean(x))

function twigs(dt::DecisionTree)
    leaves = SDeMo.tips(dt)
    leaf_parents = unique([leaf.parent for leaf in leaves])
    twig_nodes =
        filter(p -> iszero(p.left.variable) & iszero(p.right.variable), leaf_parents)
    return twig_nodes
end

function _information_gain(dn::SDeMo.DecisionNode, X, y)
    p = findall(SDeMo._pool(dn, X))
    pl = [i for i in p if X[dn.variable, i] < dn.value]
    pr = setdiff(p, pl)
    yl = y[pl]
    yr = y[pr]
    yt = y[p]
    e = SDeMo._entropy(yt)
    el = SDeMo._entropy(yl)
    er = SDeMo._entropy(yr)
    return e - mean(yl) * el - mean(yr) * er
end

"""
    prune!(tree, X, y)

This function will take each twig in a tree, and merge the one with the worst
contribution to information gain.
"""
function prune!(tree, X, y)
    all_tree_twigs = twigs(tree)
    worst_info, worst_index = Inf, 0
    for i in eachindex(all_tree_twigs)
        ef = _information_gain(all_tree_twigs[i], X, y)
        if ef < worst_info
            worst_info = ef
            worst_index = i
        end
    end
    SDeMo.merge!(all_tree_twigs[worst_index])
    return tree
end

Base.zero(::Type{DecisionTree}) = 0.5

function train!(
    dt::DecisionTree,
    y::Vector{Bool},
    X::Matrix{T};
    kwargs...,
) where {T <: Number}
    root = SDeMo.DecisionNode()
    root.prediction = mean(y)
    dt.root = root
    train!(dt.root, X, y)
    for _ in 1:(dt.maxdepth - 2)
        for tip in SDeMo.tips(dt)
            p = SDeMo._pool(tip, X)
            if !(tip.visited)
                inpool = findall(p)
                train!(tip, X[:, inpool], y[inpool])
            end
        end
    end

    while length(SDeMo.tips(dt)) > dt.maxnodes
        prune!(dt, X, y)
    end

    return dt
end

function StatsAPI.predict(dt::DecisionTree, x::Vector{T}) where {T <: Number}
    return predict(dt.root, x)
end

function StatsAPI.predict(dn::DecisionNode, x::Vector{T}) where {T <: Number}
    if iszero(dn.variable)
        return dn.prediction
    else
        if x[dn.variable] < dn.value
            return predict(dn.left, x)
        else
            return predict(dn.right, x)
        end
    end
end

function StatsAPI.predict(dt::DecisionTree, X::Matrix{T}) where {T <: Number}
    return vec(mapslices(x -> predict(dt, x), X; dims = 1))
end

@testitem "We can train a decison tree" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, DecisionTree, X, y)
    hyperparameters!(classifier(model), :maxdepth, 3)
    train!(model)
    @test model.classifier.maxdepth == 3
    @test SDeMo.depth(model.classifier) <= 3
    @test length(SDeMo.tips(model.classifier)) <= model.classifier.maxnodes
end

@testitem "We can train a decison tree and make a prediction with it" begin
    X, y = SDeMo.__demodata()
    model = SDM(MultivariateTransform{PCA}, DecisionTree, X, y)
    hyperparameters!(classifier(model), :maxdepth, 5)
    train!(model)
    @test model.classifier.maxdepth == 5
    pr = predict(model, X)
    @test eltype(pr) == Bool
    @test length(pr) == length(y)
end
