module SDMPolygonsMakieExt

@static if isdefined(Base, :get_extension)
    using MakieCore, SimpleSDMPolygons
else
    using ..MakieCore, ..SimpleSDMPolygons
end

const SSP_TYPES = Union{Polygon,MultiPolygon,Feature}

function MakieCore.convert_arguments(P::MakieCore.NoConversion, t::SSP_TYPES)
    return MakieCore.convert_arguments(P, t.geometry)
end

function MakieCore.convert_arguments(P::MakieCore.NoConversion, fc::FeatureCollection)
    return MakieCore.convert_arguments(P, fc.features)
end

function MakieCore.convert_arguments(P::MakieCore.PointBased, t::SSP_TYPES)
    return MakieCore.convert_arguments(P, t.geometry)
end


function MakieCore.lines(fc::FeatureCollection; kw...)
    fig = lines(fc[begin])
    for f in fc[2:end]
        lines!(f; kw...)
    end
    fig
end

function MakieCore.poly(fc::FeatureCollection; kw...)
    fig = poly(fc[begin])
    for f in fc[2:end]
        poly!(f; kw...)
    end
    fig
end

function MakieCore.lines!(ax, fc::FeatureCollection; kw...)
    for f in fc
        lines!(ax, f; kw...)
    end
end
function MakieCore.lines!(fc::FeatureCollection; kw...)
    for f in fc
        lines!(f; kw...)
    end
end

function MakieCore.poly!(fc::FeatureCollection; kw...)
    for f in fc
        poly!(f; kw...)
    end
end
function MakieCore.poly!(ax, fc::FeatureCollection; kw...)
    for f in fc
        poly!(ax, f; kw...)
    end
end

end