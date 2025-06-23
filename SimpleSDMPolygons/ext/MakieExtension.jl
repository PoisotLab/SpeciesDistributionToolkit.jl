module MakieExtension

@static if isdefined(Base, :get_extension)
    using Makie, SimpleSDMPolygons
else
    using ..Makie, ..SimpleSDMPolygons
end

const SSP_TYPES = Union{Polygon,MultiPolygon,Feature}

function Makie.convert_arguments(P::Makie.NoConversion, t::SSP_TYPES)
    return Makie.convert_arguments(P, t.geometry)
end

function Makie.convert_arguments(P::Makie.NoConversion, fc::FeatureCollection)
    return Makie.convert_arguments(P, fc.features)
end

function Makie.convert_arguments(P::Makie.PointBased, t::SSP_TYPES)
    return Makie.convert_arguments(P, t.geometry)
end

function Makie.lines(fc::FeatureCollection; kw...)
    fig = lines(fc[begin]; kw...)
    for f in fc[2:end]
        lines!(f; kw...)
    end
    fig
end

function Makie.poly(fc::FeatureCollection; kw...)
    fig = poly(fc[begin]; kw...)
    for f in fc[2:end]
        poly!(f; kw...)
    end
    fig
end

function Makie.lines!(ax, fc::FeatureCollection; kw...)
    for f in fc
        lines!(ax, f; kw...)
    end
end
function Makie.lines!(fc::FeatureCollection; kw...)
    for f in fc
        lines!(f; kw...)
    end
end

function Makie.poly!(fc::FeatureCollection; kw...)
    for f in fc
        poly!(f; kw...)
    end
end
function Makie.poly!(ax, fc::FeatureCollection; kw...)
    for f in fc
        poly!(ax, f; kw...)
    end
end

end