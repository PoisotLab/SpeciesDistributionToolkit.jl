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
            file, $layertype; bandnumber = bandnumber, left = left,
            right = right, bottom = bottom, top = top,
        )
    end
    @error "Only tiff files are supported at the moment"
end

function save(
    file::String,
    layers::Vector{$layertype{T}};
    kwargs...,
) where {T <: Number}
    if endswith(file, ".tif") | endswith(file, ".tiff")
        _write_geotiff(file, layers; kwargs...)
        return file
    end
    @error "Only tiff files are supported at the moment"
end

function save(
    file::String,
    layer::$layertype{T};
    kwargs...,
) where {T <: Number}
    return SpeciesDistributionToolkit.save(file, [layer]; kwargs...)
end
