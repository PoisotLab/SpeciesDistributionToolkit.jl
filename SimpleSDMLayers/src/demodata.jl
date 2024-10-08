function __demodata(; reduced::Bool = false)
    dpath = joinpath(@__DIR__, "..", "..", "data")
    grd = parse.(UInt16, hcat(split.(readlines(joinpath(dpath, "grid.dat")), '\t')...))
    crs = only(readlines(joinpath(dpath, "grid.crs")))
    metadata = readlines(joinpath(dpath, "grid.info"))
    x = tuple(parse.(Float64, metadata[1:2])...)
    y = tuple(parse.(Float64, metadata[3:4])...)
    nodata = convert(UInt16, parse(Float64, metadata[end]))
    if reduced
        xrange = 100:499
        yrange = 100:499
        eastings = LinRange(x..., size(grd, 2) + 1)
        northings = LinRange(y..., size(grd, 1) + 1)
        grd = grd[xrange, yrange]
        x = extrema(eastings[xrange])
        y = extrema(northings[yrange])
    end
    return SDMLayer(grd; crs=crs, x=x, y=y, nodata=nodata)
end

@testitem "We can load the demo layer" begin
    layer = SimpleSDMLayers.__demodata()
    @test layer.crs == "+proj=aea +lat_0=44 +lon_0=-68.5 +lat_1=60 +lat_2=46 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"
end

@testitem "We can load the reduced demo layer" begin
    layer = SimpleSDMLayers.__demodata(reduced=true)
    @test layer.crs == "+proj=aea +lat_0=44 +lon_0=-68.5 +lat_1=60 +lat_2=46 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"
    @test size(layer) == (400, 400)
end

@testitem "We read the correct WGS84 bounds for the demo layer" begin
    layer = SimpleSDMLayers.__demodata()
    prj = SimpleSDMLayers.Proj.Transformation(layer.crs, "+proj=longlat +datum=WGS84 +no_defs"; always_xy=true)
    
    ll_ll = prj(layer.x[1], layer.y[1])
    @test ll_ll[1] ≈ -80.00 atol = 0.01
    @test ll_ll[2] ≈ 44.99 atol = 0.01
    
    lr_ll = prj(layer.x[2], layer.y[1])
    @test lr_ll[1] ≈ -50.35 atol = 0.01
    @test lr_ll[2] ≈ 44.00 atol = 0.01
    
    ul_ll = prj(layer.x[1], layer.y[2])
    @test ul_ll[1] ≈ -87.47 atol = 0.01
    @test ul_ll[2] ≈ 64.94 atol = 0.01

    ur_ll = prj(layer.x[2], layer.y[2])
    @test ur_ll[1] ≈ -39.18 atol = 0.01
    @test ur_ll[2] ≈ 63.32 atol = 0.01
end