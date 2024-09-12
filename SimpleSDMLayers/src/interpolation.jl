function interpolate(layer::SDMLayer; dest="+proj=natearth2", newsize=nothing, interpolator=SimpleSDMLayers.polynomialinterpolation)
    # We'll use this later
    EL = eastings(layer)
    NL = northings(layer)

    # Functions for projection
    prj = SimpleSDMLayers.Proj.Transformation(layer.crs, dest; always_xy = true)
    revprj = SimpleSDMLayers.Proj.Transformation(dest, layer.crs; always_xy = true)

    # New coordinates for the layer
    ll = prj(layer.x[1], layer.y[1])
    lr = prj(layer.x[2], layer.y[1])
    ul = prj(layer.x[1], layer.y[2])
    ur = prj(layer.x[2], layer.y[2])
    nx = extrema(first.([ll, lr, ul, ur]))
    ny = extrema(last.([ll, lr, ul, ur]))

    # Prepare a new layer
    newsize = isnothing(newsize) ? size(layer) : newsize
    @info newsize
    newlayer = SDMLayer(zeros(Float32, newsize); crs = dest, x = nx, y = ny)
    nodata!(newlayer, zero(eltype(newlayer)))
    EI = eastings(newlayer)
    NI = northings(newlayer)

    Threads.@threads for i in axes(newlayer, 2)
        dx = EI[i]
        for j in axes(newlayer, 1)
            dy = NI[j]
            x, y = revprj(dx, dy)
            i1 = findlast(EL .< x)
            i2 = findfirst(EL .> x)
            j1 = findlast(NL .< y)
            j2 = findfirst(NL .> y)
            if !any(isnothing, [i1, i2, j1, j2])
                x1 = EL[i1]
                x2 = EL[i2]
                y1 = NL[j1]
                y2 = NL[j2]
                Q11 = layer[j1, i1]
                Q12 = layer[j1, i2]
                Q21 = layer[j2, i1]
                Q22 = layer[j2, i2]
                if !any(isnothing, [Q11, Q12, Q21, Q22])
                    newlayer[j,i] = interpolator(x1, x, x2, y1, y, y2, Q11, Q12, Q21, Q22)
                    SimpleSDMLayers.reveal!(newlayer, i, j)
                end
            end
        end
    end
    return newlayer
end

function polynomialinterpolation(x1, x, x2, y1, y, y2, Q11, Q12, Q21, Q22)
    Q = [Q11; Q12; Q21; Q22]
    corr = (1.0/((x2-x1)*(y2 - y1)))
    X = [x2*y2 -x2*y1 -x1*y2 x1*y1; -y2 y1 y2 -y1; -x2 x2 x1 -x1; 1 -1 -1 1]
    coeff = corr * X * Q
    return coeff[1] + coeff[2]*x + coeff[3]*y + coeff[4]*x*y
end