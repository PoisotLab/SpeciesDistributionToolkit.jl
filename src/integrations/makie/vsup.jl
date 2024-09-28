function _vsup_grid(vbins, ubins, vpal, upal=colorant"#e3e3e3", shrinkage=0.5, exponent=1.0)
    pal = fill(upal, (vbins, ubins))
    for i in 1:ubins
        shrkfac = ((i - 1) / (ubins - 1))^exponent
        subst = 0.5 - shrkfac * shrinkage / 2
        pal[:, i] .= ColorSchemes.cgrad(vpal)[LinRange(0.5 - subst, 0.5 + subst, vbins)]
        # Apply the mix to the uncertain color
        for j in 1:vbins
            pal[j, i] = weighted_color_mean(1 - shrkfac, pal[j, i], upal)
        end
    end
end

MakieCore.@recipe(VSUP) do scene
end