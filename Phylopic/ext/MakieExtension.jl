module MakieExtension

using Makie, Phylopic

@recipe(SilhouettePlot) do scene
    Attributes(
        markersize = 100,
    )
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{Real, Real, PhylopicSilhouette}})
    img = Phylopic._get_silhimg(sp[3].val)
    scatter!(sp, [sp[1].val], [sp[2].val], marker=img, markersize = sp.markersize.val)
end

function Makie.plot!(sp::SilhouettePlot{<:Tuple{AbstractVector{<:Real}, AbstractVector{<:Real}, AbstractVector{<:PhylopicSilhouette}}})
    imgs = Phylopic._get_silhimg.(sp[3].val)
    scatter!(sp, sp[1].val, sp[2].val, marker=imgs, markersize = sp.markersize.val)
end

end