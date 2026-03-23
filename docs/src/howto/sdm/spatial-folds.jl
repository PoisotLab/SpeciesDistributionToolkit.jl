# # Tessellation

# It is possible to generate tessellations (homogenous tilings of a surface)
# from several type of objects.

using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# We will start by getting the different type of data that can be used to
# generate a tessellation, starting with polygons:

pol = getpolygon(PolygonData(OpenStreetMap, Places); place = "California")
bb = SDT.boundingbox(pol)

# Get an orthoprojection

proj = "+proj=ortho +lon_0=$((bb.right + bb.left)/2) +lat_0=$((bb.top + bb.bottom)/2)"

# We will also grab some occurrences:

records = Occurrences(mask(OccurrencesInterface.__demodata(), pol))

# And we will also get a layer:

L = [SDMLayer(RasterData(CHELSA2, BioClim); bb..., layer=i) for i in [1,12]]
mask!(L, pol)

# ## Creating the tiles

# get tiles

T = tessellate(pol, 30.0; tile=:hexagons, pointy=true, proj=proj, densify=5)

#figure tile1
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
lines!(ax, pol)
lines!(ax, T, color=:orange)
current_figure() #hide

# ## assign by latitude

n = 4

# this is the code

SDT.assignfolds!(T; n=n, group=true, order=:horizontal)

#figure tile1
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
for i in 1:n
    poly!(ax, T["__fold" => i], alpha=0.2, color=i, colorrange=(1, n), colormap=cgrad(:twelvebitrainbow, n, categorical=true))
    lines!(ax, T["__fold" => i], color=i, colorrange=(1, n), colormap=cgrad(:twelvebitrainbow, n, categorical=true))
end
#lines!(ax, T, color=:black)
current_figure() #hide


# this is the code

SDT.assignfolds!(T; n=n, group=true, order=:vertical)

#figure tile1
f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())
for i in 1:n
    poly!(ax, T["__fold" => i], alpha=0.2, color=i, colorrange=(1, n), colormap=cgrad(:twelvebitrainbow, n, categorical=true))
    lines!(ax, T["__fold" => i], color=i, colorrange=(1, n), colormap=cgrad(:twelvebitrainbow, n, categorical=true))
end
#lines!(ax, T, color=:black)
current_figure() #hide