function lonlat(L::SDMLayer)
    E, N, K = eastings(L), northings(L), keys(L)
    xy = [(E[k[2]], N[k[1]]) for k in K]
    return xy
end


roll(angle) = (xy) -> _spherical_rotation(xy, angle, 1)
pitch(angle) = (xy) -> _spherical_rotation(xy, angle, 2)
yaw(angle) = (xy) -> _spherical_rotation(xy, angle, 3)

shiftlongitudes(angle) = (xy) -> _spherical_rotation(xy, angle, 3)
shiftlatitudes(angle) = (xy) -> _rotate_latitudes(xy, -angle)

localrotation(angle) = (xy) -> _centroid_rotation(xy, angle)

shiftandrotate(longitude, latitude, rotation) = (xy) -> xy |> shiftlongitudes(longitude) |> shiftlatitudes(latitude) |> localrotation(rotation)


function find_rotations(L, P; longitudes=(-10., 10.), latitudes=(-10., 10.), rotation=(-10., 10.), maxiter=10_000, steps=150)
    iter = 1
    rangelon = LinRange(extrema(longitudes)..., steps)
    rangelat = LinRange(extrema(latitudes)..., steps)
    rangerot = LinRange(extrema(rotation)..., steps)
    r = (rand(rangelon), rand(rangelat), rand(rangerot))
    while iter < maxiter
        iter += 1
        r = (rand(rangelon), rand(rangelat), rand(rangerot))
        trf = shiftandrotate(r...)
        u = [P[c...] for c in trf(lonlat(L))]
        if !any(isnothing, u)
            return r
        end
    end
    return nothing
end

#=
cntrs = getpolygon(PolygonData(NaturalEarth, Countries))
pol = cntrs["Czech Republic"]
P = SDMLayer(RasterData(WorldClim2, BioClim); resolution=2.5)
L = SDMLayer(RasterData(WorldClim2, BioClim); resolution=2.5, SDT.boundingbox(pol)...)
mask!(L, pol)

# Check the data
heatmap(L)


r = find_rotations(L, P; latitudes=(-10., 10.), longitudes=(-20., 20.), rotation=(-1., 1.))
@info r

trf = shiftandrotate(r...)

f = Figure(; size=(1000, 1000))
ax = Axis(f[1, 1]; aspect=DataAspect())

heatmap!(ax, P, colormap=:greys)
scatter!(ax, lonlat(L), markersize=1, color=:black)
scatter!(ax, trf(lonlat(L)), markersize=1, color=:red)
xlims!(ax, extrema(first.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))
ylims!(ax, extrema(last.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))

Y = deepcopy(L)
SimpleSDMLayers.burnin!(Y, [P[c...] for c in trf(lonlat(L))])
ax2 = Axis(f[1, 2]; aspect=DataAspect())
heatmap!(ax2, Y)

current_figure()
=#