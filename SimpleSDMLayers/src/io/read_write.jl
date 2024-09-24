function SimpleSDMLayers.SDMLayer(
    file::String,
    format = "tiff";
    bandnumber::Integer = 1,
    left = nothing,
    right = nothing,
    bottom = nothing,
    top = nothing,
)
    @assert isfile(file)
    if endswith(file, ".tif") | endswith(file, ".tiff") |
       (format in ["tiff", "tif"])
        return SimpleSDMLayers._read_geotiff(
            file; bandnumber = bandnumber, left = left,
            right = right, bottom = bottom, top = top,
        )
    end
    @error "Only tiff files are supported at the moment"
end

function save(file::String, layers::Vector{SDMLayer{T}}; kwargs...) where {T <: Number}
    if endswith(file, ".tif") | endswith(file, ".tiff")
        _write_geotiff(file, layers; kwargs...)
        return file
    end
    @error "Only tiff files are supported at the moment"
end

function save(file::String, layer::SDMLayer{T}; kwargs...) where {T <: Number}
    return save(file, [layer]; kwargs...)
end

@testitem "We can save a layer to a file and it does not fuck it up" begin
    t = SimpleSDMLayers.__demodata(; reduced=true)
    f = tempname()*".tiff"
    SimpleSDMLayers.save(f, t)
    k = SDMLayer(f)
    @test extrema(k) == extrema(t)
    @test t.crs == k.crs
    for ky in keys(k)[1:50]
        @test k[ky] == t[ky]
    end
end

@testitem "We can save a layer and read with the correct bbox" begin
    t = SimpleSDMLayers.__demodata(; reduced=true)
    f = tempname()*".tiff"
    SimpleSDMLayers.save(f, t)
    # WGS84 smaller bounding box
    bbox = (left=-79., right=-75., bottom=47., top=49.)
    k = SDMLayer(f; bandnumber=1, bbox...)
    @test all(size(k) .< size(t))
    @test k.crs == t.crs
    @test k.x[1] > t.x[1]
    @test k.x[2] < t.x[2]
    @test k.y[1] > t.y[1]
    @test k.y[2] < t.y[2]
    valpos = SimpleSDMLayers._centers(k)[:,1:10]
    for i in axes(valpos, 2)
        @test k[valpos[:,i]...] == t[valpos[:,i]...]
    end
    
end