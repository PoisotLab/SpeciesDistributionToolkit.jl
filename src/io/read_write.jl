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
        return SpeciesDistributionToolkit._read_geotiff(
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
    t = SDMLayer(RasterData(WorldClim2, WindSpeed); bottom=-10., top=25.0, left=-10.0, right=15.0)
    f = tempname()*".tiff"
    SpeciesDistributionToolkit.save(f, t)
    k = SDMLayer(f)
    @test SimpleSDMLayers._layers_are_compatible(t, k)
end