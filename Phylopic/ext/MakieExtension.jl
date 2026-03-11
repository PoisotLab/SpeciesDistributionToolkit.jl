module MakieExtension

using Makie, Phylopic
import Phylopic: silhouetteplot, silhouetteplot!

@recipe SilhouettePlot (x, y, silhouette,) begin
    markersize = 100
    color = nothing
    colormap = @inherit colormap
    colorrange = (0., 1.)
end

function _recolor(img, color, colormap, colorrange)
    col = Makie.Colors.RGB(0.0, 0.0, 0.0)
    new_img = convert.(Makie.Colors.RGBA, img)
    if !isnothing(color)
        if string(color) in keys(Makie.Colors.color_names)
            col = Makie.Colors.RGB((Makie.Colors.color_names[String(color)] ./ 255)...)
        elseif color isa Makie.ColorTypes.RGB
            col = color
        else
            nv = clamp((color - colorrange[1]) / (colorrange[2] - colorrange[1]), 0, 1)
            col = Makie.ColorSchemes.get(Makie.ColorSchemes.colorschemes[colormap], nv)
        end
        clrd = findall(!isequal(Makie.Colors.RGBA(0.0, 0.0, 0.0, 0.0)), img)
        for i in clrd
            new_img[i] = Makie.Colors.RGBA(col.r, col.g, col.b, new_img[i].alpha)
        end
    end
    return new_img
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{Real,Real,String}})
    img = Phylopic._download_silhouette(PhylopicSilhouette(sp.silhouette[]))
    img = _recolor(img, sp.color[], sp.colormap[], sp.colorrange[])
    scatter!(sp, [sp.x[]], [sp.y[]], marker=img, markersize=sp.markersize[])
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{Real,Real,PhylopicSilhouette}})
    img = Phylopic._download_silhouette(sp.silhouette[])
    img = _recolor(img, sp.color[], sp.colormap[], sp.colorrange[])
    scatter!(sp, [sp.x[]], [sp.y[]], marker=img, markersize=sp.markersize[])
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{AbstractVector{<:Real},AbstractVector{<:Real},AbstractVector{<:PhylopicSilhouette}}})
    img = Phylopic._download_silhouette.(sp.silhouette[])
    for i in eachindex(img)
        c = sp.color[] isa Vector ? sp.color[][i] : sp.color[]
        nimg = _recolor(img[i], c, sp.colormap[], sp.colorrange[])
        scatter!(sp, [sp.x[][i]], [sp.y[][i]], marker=nimg, markersize=sp.markersize[])
    end
end


function Makie.plot!(sp::SilhouettePlot{<:Tuple{AbstractVector{<:Real},AbstractVector{<:Real},AbstractVector{<:PhylopicSilhouette}}})
    img = Phylopic._download_silhouette.(sp.silhouette[])
    for i in eachindex(img)
        c = sp.color[] isa Vector ? sp.color[][i] : sp.color[]
        nimg = _recolor(img[i], c, sp.colormap[], sp.colorrange[])
        scatter!(sp, [sp.x[][i]], [sp.y[][i]], marker=nimg, markersize=sp.markersize[])
    end
end

end