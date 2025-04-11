module SDMPolygonsMakieExt

@static if isdefined(Base, :get_extension)
    using Makie, SimpleSDMPolygons
else
    using ..Makie, ..SimpleSDMPolygons
end

Makie.poly(feat::Feature) = poly(feat.geometry)
Makie.poly(polygon::Polygon) = poly(polygon.geometry)
Makie.poly(mp::MultiPolygon) = poly(mp.geometry)
Makie.poly(fc::FeatureCollection; kw...) = begin
    f = Figure(kw...)
    ax = Axis(f[1, 1])
    for feat in fc
        poly!(ax, feat)
    end
    f
end

Makie.poly!(ax, feat::Feature; kw...) = poly!(ax, feat.geometry; kw...)
Makie.poly!(ax, polygon::Polygon; kw...) = poly!(ax, polygon.geometry; kw...)
Makie.poly!(ax, mp::MultiPolygon; kw...) = poly!(ax, mp.geometry; kw...)
Makie.poly!(ax, fc::FeatureCollection; kw...) = begin
    for feat in fc
        poly!(ax, feat; kw...)
    end
end

end