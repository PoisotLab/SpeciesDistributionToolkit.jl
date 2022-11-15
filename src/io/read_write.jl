for layertype in (:SimpleSDMResponse, :SimpleSDMPredictor)
    eval(
        quote
            function SimpleSDMLayers.$layertype(
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
            end

            function save(
                file::String,
                layer::$layertype{T};
                kwargs...,
            ) where {T <: Number}
                return SpeciesDistributionToolkit.save(file, [layer]; kwargs...)
            end
        end,
    )
end
