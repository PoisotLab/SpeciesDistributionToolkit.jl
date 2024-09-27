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
    to_the_left = [X[dn.parent.variable, i] < dn.parent.value for i in axes(X, 2)]
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

function train!(dn::DecisionNode, X, y)
    v = collect(axes(X, 1))
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
        for i in eachindex(v)
            x = unique(X[v[i], :])
            for j in eachindex(x)
                left, right = findall(X[v[i], :] .< x[j]), findall(X[v[i], :] .>= x[j])
                left_p = length(left) / length(y)
                right_p = 1.0 - left_p
                left_e = SDeMo._entropy(y[left])
                right_e = SDeMo._entropy(y[right])
                IG = current_entropy - left_p * left_e - right_p * right_e
                if (IG > best_gain) & (IG > 0)
                    best_gain = IG
                    best_split = (v[i], x[j])
                    pl, pr = left_p, right_p
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

"""
    DecisionTree

TODO
"""
Base.@kwdef mutable struct DecisionTree <: Classifier
    root::DecisionNode = DecisionNode()
    maxnodes::Integer = 12
end

tips(::Nothing) = nothing
tips(dt::DecisionTree) = tips(dt.root)
function tips(dn::SDeMo.DecisionNode)
    if iszero(dn.variable)
        return dn
    else
        return vcat(tips(dn.left), tips(dn.right))
    end
end

depth(dt::DecisionTree) = maximum(depth.(tips(dt)))
depth(dn::DecisionNode) = 1 + depth(dn.parent)
depth(::Nothing) = 0

function merge!(dn::DecisionNode)
    dn.variable = 0
    dn.value = 0
    dn.left = nothing
    dn.right = nothing
    return dn
end

function _entropy(x::Vector{Bool})
    pᵢ = [sum(x), length(x) - sum(x)] ./ length(x)
    return -sum(pᵢ .* log2.(pᵢ))
end

function twigs(dt::DecisionTree)
    leaves = SDeMo.tips(dt)
    leaf_parents = unique([leaf.parent for leaf in leaves])
    twig_nodes =
        filter(p -> iszero(p.left.variable) & iszero(p.right.variable), leaf_parents)
    return twig_nodes
end

function _information_gain(dn::SDeMo.DecisionNode, X, y)
    pl = SDeMo._pool(dn.left, X)
    pr = SDeMo._pool(dn.right, X)
    p = pl .| pr
    yl = y[findall(pl)]
    yr = y[findall(pr)]
    yt = y[findall(p)]
    e = SDeMo._entropy(yt)
    el = SDeMo._entropy(yl)
    er = SDeMo._entropy(yr)
    return e - mean(yl) * el - mean(yr) * er
end

function prune!(tree, X, y)
    tw = twigs(tree)
    wrst = Inf
    widx = 0
    for i in eachindex(tw)
        ef = _information_gain(tw[i], X, y)
        if ef < wrst
            wrst = ef
            widx = i
        end
    end
    SDeMo.merge!(tw[widx])
    return tree
end

Base.zero(::Type{DecisionTree}) = 0.5

function train!(
    dt::DecisionTree,
    y::Vector{Bool},
    X::Matrix{T},
) where {T <: Number}
    root = SDeMo.DecisionNode()
    root.prediction = mean(y)
    dt.root = root
    train!(dt.root, X, y)
    for _ in 1:6
        for tip in SDeMo.tips(dt)
            p = SDeMo._pool(tip, X)
            train!(tip, X[:, findall(p)], y[findall(p)])
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