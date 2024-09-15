function interpolate!(destination::SDMLayer, source::SDMLayer)
    EL = eastings(source)
    NL = northings(source)
    EI = eastings(destination)
    NI = northings(destination)

    # Functions for projection
    revprj = SimpleSDMLayers.Proj.Transformation(destination.crs, layer.crs; always_xy = true)

    Threads.@threads for i in axes(destination, 2)
        dx = EI[i]
        for j in axes(destination, 1)
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
                    destination[j, i] = SimpleSDMLayers.polynomialinterpolation(
                        x1,
                        x,
                        x2,
                        y1,
                        y,
                        y2,
                        Q11,
                        Q12,
                        Q21,
                        Q22,
                    )
                    SimpleSDMLayers.reveal!(destination, i, j)
                else
                    SimpleSDMLayers.hide!(destination, i, j)
                end
            end
        end
    end
    return newlayer
end

function _create_destination_layer(source::SDMLayer, dest, newsize)
    EL = eastings(source)
    NL = northings(source)
    prj = SimpleSDMLayers.Proj.Transformation(source.crs, dest; always_xy = true)
    
    b1 = [prj(EL[1], n) for n in NL]
    b2 = [prj(EL[end], n) for n in NL]
    b3 = [prj(e, NL[1]) for e in EL]
    b4 = [prj(e, NL[end]) for e in EL]
    bands = vcat(b1, b2, b3, b4)
    
    nx = extrema(first.(bands))
    ny = extrema(last.(bands))

    destination = SDMLayer(zeros(Float32, newsize); crs = dest, x = nx, y = ny)
    nodata!(destination, zero(eltype(destination)))
    return destination
end

"""
    interpolate(layer::SDMLayer; dest="+proj=natearth2", newsize=nothing)

Returns an interpolated version of the later under the new destination CRS
(natearth2 by default), and with optionally a new size of `newsize`.
"""
function interpolate(layer::SDMLayer; dest = "+proj=natearth2", newsize = nothing)
    destination = _create_destination_layer(layer, dest, isnothing(newsize) ? size(layer) : newsize)
    interpolate!(destination, source)
    return destination
end

function polynomialinterpolation(x1, x, x2, y1, y, y2, Q11, Q12, Q21, Q22)
    Q = [Q11; Q12; Q21; Q22]
    corr = (1.0 / ((x2 - x1) * (y2 - y1)))
    X = [x2*y2 -x2*y1 -x1*y2 x1*y1; -y2 y1 y2 -y1; -x2 x2 x1 -x1; 1 -1 -1 1]
    coeff = corr * X * Q
    return coeff[1] + coeff[2] * x + coeff[3] * y + coeff[4] * x * y
end