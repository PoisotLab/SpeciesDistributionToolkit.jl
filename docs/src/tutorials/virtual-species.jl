# # Generating virtual species

# In this vignette, we provide a demonstration of how the different
# SpeciesDistributionToolkit functions can be chained together to rapidly create
# a virtual species, generate its range map, and sample points from it according
# to the predicted suitability.

using SpeciesDistributionToolkit
using CairoMakie
using Statistics
CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide

# We start by defining the extent in which we want to create the virtual
# species. For the purpose of this example, we will use the country of Paraguay,
# a polygon of which is available in the GADM database. Note that the
# boundingbox function returns the coordinates in WGS84.

place = SpeciesDistributionToolkit.gadm("PRY")
extent = SpeciesDistributionToolkit.boundingbox(place)

# We then download some environmental data. In this example, we use the BioClim
# variables as distributed by CHELSA. In order to simplify the code, we will
# only use BIO1 (mean annual temperature) and BIO12 (total annual
# precipitation). Note that we collect these layers in a vector typed as
# SDMLayer{Float32}, in order to ensure that future operations already recevie
# floating point values.

provider = RasterData(CHELSA2, BioClim)
L = SDMLayer{Float32}[SDMLayer(provider; layer=l, extent...) for l in ["BIO1", "BIO12"]]

# We now mask the layers using the polygons we downloaded initially. Here, this
# is done in two steps, first the masking of the first layer, and second the
# masking of all other layers. Currently unreleased versions of the package have
# a shortcut for this operation.

rescale!.(mask!(L, place))

# In the next steps, we will generate some virtual species. These are defined by
# an environmental response to each layer, linking the value of the layer at a
# point to the suitability score. For the sake of expediency, we only use
# logistic responses, and generate one function for each layer (drawing α from a
# normal distribution, and β uniformly).

logistic(x, α, β) = 1 / (1 + exp((x-β)/α))
logistic(α, β) = (x) -> logistic(x, α, β)

# We will next write a function that will sample a value in each layer to serve
# as the center of the logistic response, draw a shape parameter at random, and
# then return the suitability of the environment for a virtual species under the
# assumption of a set prevalence:

function virtualspecies(L::Vector{<:SDMLayer}; prevalence::Float64 = 0.25)
    prevalence = clamp(prevalence, eps(), 1.0)
    invalid = true
    while invalid
        centers = [rand(values(l)) for l in L]
        shapes = randn(length(L))
        predictors = [logistic(centers[i], shapes[i]) for i in eachindex(L)]        
        predictions = [predictors[i].(L[i]) for i in eachindex(L)]
        rescale!.(predictions)
        global prediction = prod(predictions)        
        rescale!(prediction)
        invalid = any(isnan, prediction)
    end
    cutoff = quantile(prediction, 1-prevalence)
    return prediction, cutoff, prediction .>= cutoff
end

# We can now apply this new function to create a simulated species distribution:

vsp, τ, vrng = virtualspecies(L; prevalence=0.33)

# We can plot the output of this function to inspect what the generated range looks like:

# fig-virtualspeciescomparison
f = Figure(size=(700, 700))
ax1 = Axis(f[1,1]; aspect=DataAspect(), title="Score")
ax2 = Axis(f[1,2]; aspect=DataAspect(), title="Range")
heatmap!(ax1, vsp, colormap=:navia)
heatmap!(ax2, vrng, colormap=:Greens)
for ax in [ax1, ax2]
    tightlimits!(ax)
    hidedecorations!(ax)
    hidespines!(ax)
    lines!(ax, place[1].geometry, color=:black)
end
current_figure() #hide

# Random observations for the virtual species are generated by setting the
# probability of inclusion to 0 for all values above the cutoff, and then
# sampling proportionally to the suitability for all remaining points. Note that
# the method is called backgroundpoints, as it is normally used for
# pseudo-absences. The second argument of this method is the number of points to
# generate.

presencelayer = backgroundpoints(mask(vsp, nodata(vrng, false)), 100)

# We can finally plot the result:


# fig-virtualspeciessample
f = Figure(size=(700, 700))
ax = Axis(f[1,1], aspect=DataAspect())
heatmap!(ax, vrng, colormap=:Greens)
lines!(ax, place[1].geometry, color=:black)
scatter!(ax, presencelayer, color=:white, strokecolor=:black, strokewidth=2, markersize=10, label="Virtual presences")
tightlimits!(ax)
hidespines!(ax)
hidedecorations!(ax)
axislegend(ax, position=:lb, framevisible=false)
current_figure() #hide

# These data could, for example, be used to benchmark species distribution
# models. For the analysis presented in the manuscript, we are interested in
# applying the simulation of virtual species to a large number, in order to say
# something about potential patterns of biodiversity. For this reason, we will
# now simulate 100 species, with prevalences drawn uniformly in the unit
# interval.

ranges = [virtualspecies(L; prevalence=rand())[3] for _ in 1:100]

# We can sum these layers to obtain a measurement of the simulated species
# richness:

# fig-virtualspeciesrichness
f = Figure()
richness = mosaic(sum, ranges)
ax = Axis(f[1,1]; aspect=DataAspect())
hm = heatmap!(ax, richness, colorrange=(0, length(ranges)), colormap=:navia)
Colorbar(f[1,1], hm, label="Species richness", alignmode=Inside(), width=Relative(0.4), valign=:bottom, halign=:left, tellheight=false, tellwidth=false, vertical=false)
hidedecorations!(ax)
lines!(ax, place[1].geometry, color=:black)
hidespines!(ax)
current_figure() #hide

# We can now transform these data into a partition of the contribution of each
# species and location to the total beta-diversity:

function LCBD(ranges::Vector{SDMLayer{Bool}}; transformation::Function=identity)
    Y = transformation(hcat(values.(ranges)...))
    S = (Y .- mean(Y; dims=1)).^2.0
    SStotal = sum(S)
    BDtotal = SStotal / (size(Y,1)-1)
    SSj = sum(S; dims=1)
    SCBDj = SSj ./ SStotal
    SSi = sum(S; dims=2)
    LCBDi = SSi ./ SStotal
    betadiv = similar(first(ranges), Float32)
    betadiv.grid[findall(betadiv.indices)] .= vec(LCBDi)
    return betadiv, vec(SCBDj), BDtotal
end

# For good measure, we will also add a function to perform the Hellinger
# transformation:

function hellinger(Y::AbstractMatrix{T}) where {T <: Number}
    yi = sum(Y; dims=2) .+ 1
    return sqrt.(Y ./ yi)
end

# We can now apply this function to our simulated ranges. The first output is a
# layer with the local contributions to beta diversity (LCBD), the second is a
# vector with the contribution of species, and the last element is the total
# beta diversity.

βl, βs, βt = LCBD(ranges; transformation=hellinger)

# We can now plot the various elements (most of the code below is actually
# laying out the sub-panels for the plot):

# fig-betadivmap
f = Figure(size=(700, 700))
ax = Axis(f[1,1], aspect=DataAspect())
hm = heatmap!(ax, (βl - mean(βl))/std(βl), colormap=Reverse(:RdYlBu), colorrange=(-2, 2))
lines!(ax, place[1].geometry, color=:black)
Colorbar(f[1,1], hm, label="Normalized LCBD", alignmode=Inside(), width=Relative(0.4), valign=:bottom, halign=:left, tellheight=false, tellwidth=false, vertical=false)
tightlimits!(ax)
hidespines!(ax)
hidedecorations!(ax)
ax_inset = Axis(f[1, 1],
    width=Relative(0.36),
    height=Relative(0.1),
    halign=1.0,
    valign=0.9,
    xlabel="Rel. SCBD")
hist!(ax_inset, βs./maximum(βs), color=:lightgrey, bins=40)
xlims!(ax_inset, 0, 1)
hidespines!(ax_inset, :t, :r, :l)
hideydecorations!(ax_inset)
hidexdecorations!(ax_inset, ticks=false, ticklabels=false, label=false)
tightlimits!(ax_inset)
current_figure() #hide