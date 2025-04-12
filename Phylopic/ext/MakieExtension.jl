module MakieExtension

using Makie, Phylopic
import Phylopic: silhouetteplot, silhouetteplot!

@recipe(SilhouettePlot) do scene
    Attributes(
        markersize = 100,
        color = :black,
        colormap = :viridis,
        colorrange = (0., 1.),
    )
end

function _recolor(img, color, colormap, colorrange)
    col = Makie.Colors.RGB(0.0, 0.0, 0.0)
    if string(color) in keys(Makie.Colors.color_names)
        col = Makie.Colors.RGB((Makie.Colors.color_names[String(color)]./255)...)
    else
        nv = clamp((color - colorrange[1])/(colorrange[2]-colorrange[1]), 0, 1)
        col = Makie.ColorSchemes.get(Makie.ColorSchemes.colorschemes[colormap], nv)
    end
    new_img = convert.(Makie.Colors.RGBA, img)
    clrd = findall(!isequal(Makie.Colors.RGBA(0.0, 0.0, 0.0, 0.0)), img)
    for i in clrd
        new_img[i] = Makie.Colors.RGBA(col.r, col.g, col.b, new_img[i].alpha)
    end
    return new_img
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{Real, Real, PhylopicSilhouette}})
    img = Phylopic._download_silhouette(sp[3].val)
    img = _recolor(img, sp.color.val, sp.colormap.val, sp.colorrange.val)
    scatter!(sp, [sp[1].val], [sp[2].val], marker=img, markersize = sp.markersize.val)
end

end