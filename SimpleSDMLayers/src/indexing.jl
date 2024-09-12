function Base.getindex(layer::SDMLayer, i...)
    return layer.indices[i...] ? Base.getindex(layer.grid, i...) : nothing
end

function Base.getindex(layer::SDMLayer, i::Vector{CartesianIndex{2}})
    i = filter(ci -> layer.indices[ci], i)
    return layer.grid[i]
end

function Base.setindex!(layer::SDMLayer, i...)
    return Base.setindex!(layer.grid, i...)
end

@testitem "We can index a layer by position" begin
    layer = SDMLayer(rand(UInt8, (10, 20)); nodata=0x06)
    @test layer[1, 1] == layer.grid[1, 1]
end

@testitem "We can edit a layer by position" begin
    layer = SDMLayer(rand(UInt8, (10, 20)); nodata=0x06)
    @test (layer[1, 1] = 0x02) == 0x02
end

@testitem "We get nothing when accessing at a nodata position" begin
    layer = SDMLayer(rand(UInt8, (10, 20)); nodata=0x06)
    for i in eachindex(layer.grid)
        if !layer.indices[i]
            @test isnothing(layer[i])
        end
    end
end

function __get_grid_coordinate_by_latlon(layer::SDMLayer, longitude::AbstractFloat, latitude::AbstractFloat)
    if isequal("EPSG:4326")(layer.crs)
        return __get_grid_coordinate_by_crs(layer, longitude, latitude)
    else
        prj = Proj.Transformation("EPSG:4326", layer.crs; always_xy=true)
        return __get_grid_coordinate_by_crs(layer, prj(longitude, latitude)...)
    end
end

function __get_grid_coordinate_by_crs(layer::SDMLayer, easting, northing)
    eastings = LinRange(layer.x..., size(layer.grid, 2) + 1)
    northings = LinRange(layer.y..., size(layer.grid, 1) + 1)

    # Check for out of bounds
    (easting < minimum(eastings)) && return nothing
    (easting > maximum(eastings)) && return nothing
    (northing < minimum(northings)) && return nothing
    (northing > maximum(northings)) && return nothing

    # Return the coordinate
    ei = findfirst(easting .<= eastings)-1
    ni = findfirst(northing .<= northings)-1
    return (ni, ei)
end

function Base.getindex(layer::SDMLayer, longitude::AbstractFloat, latitude::AbstractFloat)
    grid_pos = SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, longitude, latitude)
    if ~isnothing(grid_pos)
        return layer[grid_pos...]
    end
    return nothing
end

@testitem "We can get a grid value when indexing using lat/lon" begin
    layer = SimpleSDMLayers.__demodata()
    @test ~isnothing(layer[-70.0, 50.0])
end

@testitem "We get nothing when indexing out of bounds" begin
    layer = SimpleSDMLayers.__demodata()
    @test isnothing(layer[20.0, 50.0])
end

@testitem "We get the correct cell when indexing the ends of the bounding box" begin
    layer = SimpleSDMLayers.__demodata()
    prj = SimpleSDMLayers.Proj.Transformation(layer.crs, "EPSG:4326"; always_xy=true)
    
    ll_ll = prj(layer.x[1], layer.y[1]) .+ (0.001, 0.001)
    lr_ll = prj(layer.x[2], layer.y[1]) .+ (-0.001, 0.001)
    ul_ll = prj(layer.x[1], layer.y[2]) .+ (0.001, -0.001)
    ur_ll = prj(layer.x[2], layer.y[2]) .+ (-0.001, -0.001)

    @test SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, ll_ll...) == (1, 1)
    @test SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, lr_ll...) == (1, size(layer.grid, 2))
    @test SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, ul_ll...) == (size(layer.grid, 1), 1)
    @test SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, ur_ll...) == size(layer.grid)
end

function Base.setindex!(layer::SDMLayer, X, longitude::AbstractFloat, latitude::AbstractFloat)
    grid_pos = SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, longitude, latitude)
    if ~isnothing(grid_pos)
        return Base.setindex!(layer, X, grid_pos...)
    end
    return nothing
end

@testitem "We can set an index based on longitude and latitude" begin
    layer = SimpleSDMLayers.__demodata()
    @test ~isnothing(layer[-70.0, 50.0])
    layer[-70.0, 50.0] = 0x002a
    @test layer[-70.0, 50.0] == 0x002a
end

function reveal!(layer::SDMLayer, longitude::AbstractFloat, latitude::AbstractFloat)
    grid_pos = SimpleSDMLayers.__get_grid_coordinate_by_latlon(layer, longitude, latitude)
    layer.indices[grid_pos...] = true
    return layer
end


function reveal!(layer::SDMLayer, est::Integer, nrt::Integer)
    layer.indices[nrt, est] = true
    return layer
end