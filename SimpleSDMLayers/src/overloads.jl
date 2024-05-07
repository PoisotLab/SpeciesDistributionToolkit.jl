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
        "SDM Layer with $(length(layer)) $(eltype(layer)) cells",
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