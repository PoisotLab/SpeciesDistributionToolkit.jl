Base.size(layer::SDMLayer) = size(layer.grid)
Base.size(layer::SDMLayer, i) = size(layer.grid, i)
Base.eltype(::SDMLayer{T}) where {T} = T
Base.IndexStyle(::Type{SDMLayer}) = IndexCartesian()
Base.CartesianIndices(layer::SDMLayer) = findall(layer.indices)
Base.count(layer::SDMLayer) = count(layer.indices)
Base.length(layer::SDMLayer) = count(layer)
Base.IteratorSize(::SDMLayer) = Base.HasLength()
Base.IteratorEltype(::SDMLayer) = Base.HasEltype()
Base.keys(layer::SDMLayer) = CartesianIndices(layer)
Base.values(layer::SDMLayer) = layer.grid[layer.indices]

function Base.similar(layer::SDMLayer)
    grd = similar(layer.grid)
    idx = copy(layer.indices)
    return SDMLayer(grid=grd, indices=idx, x=layer.x, y=layer.y, crs=layer.crs)
end

function Base.fill!(layer::SDMLayer{T}, val::T) where {T}
    fill!(layer.grid, val)
    return layer
end

function Base.fill(layer::SDMLayer{T}, val::T) where {T}
    out = similar(layer, T)
    fill!(out, val)
    return out
end

function Base.zeros(layer::SDMLayer, ::Type{T}) where {T}
    out = similar(layer, T)
    fill!(out, zero(T))
    return out
end

function Base.ones(layer::SDMLayer, ::Type{T}) where {T}
    out = similar(layer, T)
    fill!(out, one(T))
    return out
end

Base.zeros(layer::SDMLayer) = ones(layer, eltype(layer))
Base.ones(layer::SDMLayer) = zeros(layer, eltype(layer))

@testitem "We can generate a similar layer" begin
    layer = SimpleSDMLayers.__demodata(reduced=true)
    sim = similar(layer)
    @test eltype(sim) == eltype(layer)
end

function Base.similar(layer::SDMLayer, ::Type{S}) where {S}
    grd = similar(layer.grid, S)
    idx = copy(layer.indices)
    return SDMLayer(grid=grd, indices=idx, x=layer.x, y=layer.y, crs=layer.crs)
end

@testitem "We can generate a similar layer of a different type" begin
    layer = SimpleSDMLayers.__demodata(reduced=true)
    sim = similar(layer, Int32)
    @test eltype(sim) == Int32
end

function Base.show(io::IO, ::MIME"text/plain", layer::SDMLayer)
    info_str = [
        "SDM Layer with $(count(layer)) $(eltype(layer)) cells",
        "\tCRS: $(layer.crs)",
        "\tGrid size: $(size(layer))",
    ]
    return print(io, join(info_str, "\n"))
end

function Base.copy(layer::SDMLayer)
    n = copy(layer.grid)
    i = copy(layer.indices)
    return SDMLayer(
        n;
        indices=i,
        crs=layer.crs,
        x=layer.x,
        y=layer.y
    )
end

@testitem "We can copy a layer" begin
    layer = SimpleSDMLayers.__demodata()
    copied = copy(layer)
    copied[1, 1] *= 2
    @test layer[1, 1] != copied[1, 1]
end

function Base.convert(::Type{SDMLayer{T}}, layer::SDMLayer{N}) where {T,N}
    grd = convert(Matrix{T}, layer.grid)
    return SDMLayer(grid=grd, indices=layer.indices, x=layer.x, y=layer.y, crs=layer.crs)
end

function Base.stride(layer::SDMLayer)
    Δx = (layer.x[2]-layer.x[1])/(2size(layer, 2))
    Δy = (layer.y[2]-layer.y[1])/(2size(layer, 1))
    return (Δy, Δx)
end

function Base.stride(layer::SDMLayer, i)
    return Base.stride(layer)[i]
end

function Base.:+(l1::SDMLayer, l2::SDMLayer)
    @assert SimpleSDMLayers._layers_are_compatible(l1, l2)
    r = copy(l1)
    r.grid = l1.grid .+ l2.grid
    r.indices = l1.indices .& l2.indices
    return r
end

function Base.:*(l1::SDMLayer, l2::SDMLayer)
    @assert SimpleSDMLayers._layers_are_compatible(l1, l2)
    r = copy(l1)
    r.grid = l1.grid .* l2.grid
    r.indices = l1.indices .& l2.indices
    return r
end

function Base.:/(l1::SDMLayer, l2::SDMLayer)
    @assert SimpleSDMLayers._layers_are_compatible(l1, l2)
    r = copy(l1)
    r.grid = l1.grid ./ l2.grid
    r.indices = l1.indices .& l2.indices
    return r
end

function Base.:-(l1::SDMLayer, l2::SDMLayer)
    @assert SimpleSDMLayers._layers_are_compatible(l1, l2)
    r = copy(l1)
    r.grid = l1.grid .- l2.grid
    r.indices = l1.indices .& l2.indices
    return r
end

@testitem "We can do + - / * on layers" begin
    l1 = SimpleSDMLayers.__demodata()
    l2 = SimpleSDMLayers.__demodata()
    plus = l1 + l2
    minus = l1 - l2
    multiply = l1 * l2
    divide = l1 / l2
    for i in eachindex(plus)
        @test plus[i] == l1[i] + l2[i]
        @test minus[i] == l1[i] - l2[i]
        @test multiply[i] == l1[i] * l2[i]
        @test divide[i] == l1[i] / l2[i]
    end
end

Base.:*(l::SDMLayer, x) = x .* l
Base.:*(x, l::SDMLayer) = l * x
Base.:+(l::SDMLayer, x) = x .+ l
Base.:+(x, l::SDMLayer) = l + x
Base.:-(l::SDMLayer, x) = x .- l
Base.:-(x, l::SDMLayer) = l - x
Base.:/(l::SDMLayer, x) = x ./ l
Base.:/(x, l::SDMLayer) = l / x
Base.:%(l::SDMLayer, x) = x .% l
Base.:%(x, l::SDMLayer) = l % x

@testitem "We can do + - / * on layers and numbers" begin
    l1 = SimpleSDMLayers.__demodata()
    twice = 2l1
    for i in eachindex(twice)
        @test twice[i] == 2l1[i]
    end
end

Base.:&(l1::SDMLayer{Bool}, l2::SDMLayer{Bool}) = l1 .& l2
Base.:|(l1::SDMLayer{Bool}, l2::SDMLayer{Bool}) = l1 .| l2
Base.:!(l1::SDMLayer{Bool}) = .! l1