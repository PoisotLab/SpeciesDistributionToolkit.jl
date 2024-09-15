function SimpleSDMLayers.mask!(
    layer::SDMLayer,
    polygon::Vector{Tuple{T, T}};
    strict::Bool = false,
) where {T <: AbstractFloat}
    included = (x) -> strict ? (x == 1) : (abs(x) == 1)
    prj = SimpleSDMLayers.Proj.Transformation(
        "+proj=longlat +datum=WGS84 +no_defs",
        layer.crs;
        always_xy = true,
    )
    E, N = eastings(layer), northings(layer)
    Threads.@threads for i in axes(layer, 2)
        for j in axes(layer, 1)
            if ~included(PolygonOps.inpolygon(prj(E[i], N[j]), polygon))
                layer.indices[j, i] = false
            end
        end
    end
    return layer
end

function SimpleSDMLayers.mask(
    records::GBIFRecords,
    polygon::Vector{Tuple{T, T}};
    strict::Bool = false,
) where {T <: AbstractFloat}
    included = (x) -> strict ? (x == 1) : (abs(x) == 1)
    return filter(
        r -> included(PolygonOps.inpolygon((longitudes(r), latitudes(r)), polygon)),
        records.occurrences[1:length(records)],
    )
end

function hide!(
    layer::SDMLayer,
    polygon::Vector{Tuple{T, T}};
    strict::Bool = false,
) where {T <: AbstractFloat}
    included = (x) -> strict ? (x == 1) : (abs(x) == 1)
    prj = SimpleSDMLayers.Proj.Transformation(
        "+proj=longlat +datum=WGS84 +no_defs",
        layer.crs;
        always_xy = true,
    )
    E, N = eastings(layer), northings(layer)
    Threads.@threads for i in axes(layer, 2)
        for j in axes(layer, 1)
            if included(PolygonOps.inpolygon(prj(E[i], N[j]), polygon))
                layer.indices[j, i] = false
            end
        end
    end
    return layer
end

function reveal!(
    layer::SDMLayer,
    polygon::Vector{Tuple{T, T}};
    strict::Bool = false,
) where {T <: AbstractFloat}
    included = (x) -> strict ? (x == 1) : (abs(x) == 1)
    prj = SimpleSDMLayers.Proj.Transformation(
        "+proj=longlat +datum=WGS84 +no_defs",
        layer.crs;
        always_xy = true,
    )
    E, N = eastings(layer), northings(layer)
    Threads.@threads for i in axes(layer, 2)
        for j in axes(layer, 1)
            if included(PolygonOps.inpolygon(prj(E[i], N[j]), polygon))
                layer.indices[j, i] = true
            end
        end
    end
    return layer
end

function Base.getindex(layer::SDMLayer, polygon::Vector{Tuple{T,T}}) where {T <: AbstractFloat}
    v = copy(layer)
    mask!(v, polygon)
    return values(v)
end
