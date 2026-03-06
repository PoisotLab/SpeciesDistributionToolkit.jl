module MakieExtension

@static if isdefined(Base, :get_extension)
    using Makie, SimpleSDMPolygons
else
    using ..Makie, ..SimpleSDMPolygons
end

const SSP_TYPES = Union{Polygon,MultiPolygon,Feature}

const GEOM_TYPES = Union{Polygon,MultiPolygon}

function Makie.convert_arguments(P::Makie.NoConversion, t::SSP_TYPES)
    return Makie.convert_arguments(P, t.geometry)
end

function Makie.convert_arguments(P::Makie.NoConversion, fc::FeatureCollection)
    return Makie.convert_arguments(P, fc.features)
end

function Makie.convert_arguments(P::Makie.PointBased, t::SSP_TYPES)
    return Makie.convert_arguments(P, t.geometry)
end

_nonempty_geometry(f::Feature) = _nonempty_geometry(f.geometry)
_nonempty_geometry(p::Polygon) = !SimpleSDMPolygons.AG.isempty(p.geometry)
_nonempty_geometry(mp::MultiPolygon) = !SimpleSDMPolygons.AG.isempty(mp.geometry)

for plot_type in (:lines, :poly)
    mutating_plot = Symbol(String(plot_type) * "!")
    eval(quote
        function Makie.$plot_type(fc::FeatureCollection; kw...)
            start_at = findfirst(_nonempty_geometry, fc.features)
            if !isnothing(start_at)
                fig = $plot_type(fc[start_at]; kw...)
                do_next = findnext(_nonempty_geometry, fc.features, start_at)
                while !isnothing(do_next)
                    $mutating_plot(fc[do_next]; kw...)
                    do_next = findnext(_nonempty_geometry, fc.features, do_next + 1)
                end
                return fig
            end
            return nothing
        end

        function Makie.$mutating_plot(ax, fc::FeatureCollection; kw...)
            for f in fc
                if _nonempty_geometry(f)
                    $mutating_plot(ax, f; kw...)
                end
            end
        end

        function Makie.$mutating_plot(fc::FeatureCollection; kw...)
            for f in fc
                if _nonempty_geometry(f)
                    $mutating_plot(f; kw...)
                end
            end
        end

        function Makie.$plot_type(g::GEOM_TYPES; kw...)
            if _nonempty_geometry(g)
                fig = $plot_type(g; kw...)
                return fig
            end
        end

        function Makie.$mutating_plot(ax, g::GEOM_TYPES; kw...)
            if _nonempty_geometry(g)
                $mutating_plot(ax, g; kw...)
            end
        end

        function Makie.$mutating_plot(g::GEOM_TYPES; kw...)
            if _nonempty_geometry(g)
                $mutating_plot(g; kw...)
            end
        end

    end
    )
end

end