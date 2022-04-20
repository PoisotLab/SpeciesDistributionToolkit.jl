# Fauxcurrences.jl

This package is a *clean-room*, *feature-equivalent* re-write in Julia of most
of the functionalities of the [`fauxcurrence` package for R][paper]. The
original code is licensed under the GPL, and this package is licensed under the
MIT. For this reason, the original code, and any document distributed with it,
has not been consulted during the implementation; the work is entirely based on
the published article. As detailed in the following sections, the two packages
do not have *feature parity*, but there is an overlap in the most significant
functions.

[paper]: https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.05880

![demo.png](demo.png)

## Why?

Interoperability: this package uses `SimpleSDMLayers`, `Distances`, and `GBIF`
as backends, making it fit very snuggly with the rest of the (Eco)Julia
ecosystem, and working towards integration of tools to build SDMs at scale.

Expandability: the package is built on modular functions, to ensure that custom
workflows can be built, while maintaining a general interface.

Performance: by relying on pre-allocated matrices, the operations are fairly
fast. Whenever a point changes, only the matrices that are impacted are updated,
which results in notable improvements for more taxa.

Licensing: the package uses the more permissive MIT license, imposing fewer
constraints on contributors.

## Overview of methods

Note that *none* of the methods are exported, so they need to be called with
`Fauxcurrences.method_name`. These methods are the ones that users will need to
call to set-up a whole run of the pipeline.

| method                             | description                                                  |
| ---------------------------------- | ------------------------------------------------------------ |
| `get_valid_coordinates`            | transforms GBIF observations to a matrix of coordinates      |
| `preallocate_distance_matrices`    | prepares the matrices for the intra/inter-specific distances |
| `measure_intraspecific_distances!` | updates the intra-specific distances                         |
| `measure_interspecific_distances!` | updates the inter-specific distances                         |
| `preallocate_simulated_points`     | prepare the matrix for the coordinates of simulated points   |
| `bootstrap!`                       | generates the initial proposition for the null               |
| `score_distributions`              | measures the distribution distance                           |

## Anatomy of a `Fauxcurrences`  run

**Step 0**. Prepare the run - the minimal ingredients are a set of coordinates
(for example using the `GBIF.jl` package), and a layer (one of the
`SimpleSDMLayer` types, predictor or response does not matter).

**Step 1**. Get the observation data in the correct format, which is an array of
matrices with two rows (longitude, latitude) and one column for observed
occurrence. Given an array of `GBIFRecords`, this can be done with

~~~julia
# Generate the observation distances
obs = [Fauxcurrences.get_valid_coordinates(obs, layer) for obs in observations]
~~~

**Step 2**. Decide on the number of points to generate, and the weight matrix.
The number of points to generate is, by default, the number of observations in
the original dataset, but this can be changed to generate balanced samples:

~~~julia
# How many points per taxa do we want to simulate?
points_to_generate = fill(35, length(obs))
~~~

The weight matrix is used to determine whether intra or inter-specific distances
are more important in the distribution score. For example, this will set up a
scoring scheme where intra-specific distances count for 75% of the total. The
only constraint is that the matrix `W` *must* sum to 1.

~~~julia
# Weight matrix
W = Fauxcurrences.weighted_components(length(obs), 0.75)
~~~

**Step 3**. Pre-allocate the objects. This is an important part of the run, as
`Fauxcurrences` is built to *not* allocate more memory than needed. As such,
these objects are going to be re-written many, many times. The upside is that,
if this steps fits in your memory, the entire workflow will also fit in your
memory.

~~~julia
# Pre-allocate the matrices
obs_intra, obs_inter, sim_intra, sim_inter = Fauxcurrences.preallocate_distance_matrices(obs; samples=points_to_generate)
~~~

**Step 4**. Measure the intra and inter-specific distances for the observations.
This is an important step as *all generated points* will maintain the upper
bounds of these distances matrices, *even if the inter-specific distance are
weightless*.

~~~julia
# Fill the observed distance matrices
Fauxcurrences.measure_intraspecific_distances!(obs_intra, obs)
Fauxcurrences.measure_interspecific_distances!(obs_inter, obs)
~~~

**Step 5**. Bootstrap the initial set of points. This is a two-step process,
involving first the pre-allocation of coordinate matrices, and second the
population of these matrices using random points.

~~~julia
# Bootstrap!
sim = Fauxcurrences.preallocate_simulated_points(obs; samples=points_to_generate)
Fauxcurrences.bootstrap!(sim, layer, obs, obs_intra, obs_inter, sim_intra, sim_inter)
~~~

**Step 6**. Bin the distance matrices, to prepare the scoring of the initial solution.

~~~julia
# Get the bins for the observed distance matrices
bin_intra = [Fauxcurrences._bin_distribution(obs_intra[i], maximum(obs_intra[i])) for i in 1:length(obs_intra)]
bin_inter = [Fauxcurrences._bin_distribution(obs_inter[i], maximum(obs_inter[i])) for i in 1:length(obs_inter)]

# Get the bins for the simulated distance matrices - note that the upper bound is always the observed maximum
bin_s_intra = [Fauxcurrences._bin_distribution(sim_intra[i], maximum(obs_intra[i])) for i in 1:length(obs_intra)]
bin_s_inter = [Fauxcurrences._bin_distribution(sim_inter[i], maximum(obs_inter[i])) for i in 1:length(obs_inter)]
~~~

This version of the `_bin_distribution` function is allocating an array for the
bins, but the internal function is over-writing it, to avoid unwanted
allocations.

**Step 7**. Measure the initial divergence between the observed and simulated distributions.

~~~julia
# Measure the initial divergences
D = Fauxcurrences.score_distributions(W, bin_intra, bin_s_intra, bin_inter, bin_s_inter)
~~~

This step will return a vector, the sum of which is the total divergence between
the matrices.

**Step 8**. Setup the actual run. This step has infinitely many variations, as
`Fauxcurrences` only offers a method to do *a single step forward*. In this
example, we setup a `ProgressMeter.Progress` object, and then run 5x10⁵ steps.

~~~julia
progress = zeros(Float64, 200_000)
progress[1] = sum(D)
progbar = ProgressMeter.Progress(length(progress); showspeed=true)
~~~

**Step 9**. Run! The `step!` function takes most of what we have allocated so
far, which is a lot, but allows considerable performance gains. The last
argument to `step!` is the current divergence, and the return value of `step!`
(in addition to modifying the simulated points) is the new divergence.

~~~julia
for i in 2:length(progress)
    progress[i] = Fauxcurrences.step!(sim, layer, W, obs_intra, obs_inter, sim_intra, sim_inter, bin_intra, bin_inter, bin_s_intra, bin_s_inter, progress[i-1])
    ProgressMeter.next!(progbar; showvalues=[(:Optimum, progress[i])])
end
~~~

During this time, you can setup a counter for steps without improvement, in
order to cut the runs early if required.

**Step 10**. Congratulations, your run is done! Maybe check the convergence with
a simple plot:

~~~julia
# Performance change plot
plot(progress, c=:black, lw=2, lab="Overall", dpi=400)
xaxis!("Iteration step", (1, length(progress)))
yaxis!("Jensen-Shannon distance", (0, 1))
~~~

You can also look at the per-matrix score, out of all the distance bins (set as
a package-wide variable, `Fauxcurrences._number_of_bins`):

~~~julia
# Matrix-wise plots
x = LinRange(0.0, 1.0, length(bin_intra[1]))
c = distinguishable_colors(length(sim) + 2)[(end-length(sim)+1):end]

plot(x, bin_intra, m=:circle, frame=:box, dpi=400, c=c', lab="")
plot!(x, bin_s_intra, m=:diamond, lab="", lc=:lightgrey, c=c')
xaxis!("Distance bin", 0, 1)
yaxis!("Density", 0, 0.2)
title!("Intra-specific distances")

plot(x, bin_inter, lab="", m=:circle, frame=:box, dpi=400, c=c')
plot!(x, bin_s_inter, m=:diamond, lab="", lc=:lightgrey, c=c')
xaxis!("Distance bin", 0, 1)
yaxis!("Density", 0, 0.2)
title!("Inter-specific distances")
~~~

## Suspected and known changes to the original package

The changes are classified by whether or not we **KNOW** or **SUSPECT** a
change, and further by whether the change is a **difference** (the two packages
do things differently), a **removal** (features from `fauxcurrence` have not
been ported), or an **addition** (`Fauxcurrences.jl` has unique features).

**KNOWN/difference** The distance between distribution is measured using the square
root of the ranged Jensen-Shannon divergence (the original package uses the
Kullback-Leibler divergence) - this measure gives a value in 0-1 *and* is a true
metric. The JS distance is symmetrical for any two distributions, but more
importantly, never returns an infinite value when one density is 0 and the other
is not. For sparse datasets and/or clumped occurrences, this means that JS will
return a value that can still be compared by the optimizer. Note also that for a
JS distance of x, the equivalent KL divergence would be of the order of x².

**KNOWN/addition** The number of points to simulate can be fixed *per species* -
this is important because we may want to benchmark algorithms under the
unrealistic assumption that the sampling effort is the same.

**KNOWN/removal** The bootstrap phase (generation of the initial null) picks
distances from the distance matrix, rather than performing an estimation of the
underlying distribution. This is mostly because the points will be refined
anyways, so the faster solution was selected.

**SUSPECTED/difference** The constraints on simulated points are as follow: the
intra-specific distance cannot be larger than the observed intra-specific
distance, and the inter-specific distance cannot be larger than the observed
pairwise inter-specific distance. This is motivated by two reasons. First, this
makes the binning of the distributions a lot more stable, as the upport bound of
the distribution remains the same. Second, this ensures that the optimizer does
not "cheat" by over-expanding the simulated points.

**SUSPECTED/difference** During optimization, the *only* criteria that is
checked is that the average of all divergences (intra-specific and pairwise
inter-specific) must decrease; this can result in *increases* of the distance
for one or more of the component distributions. There is no indication in the
original manuscript of what constitutes an acceptable move, and the clean-room
re-implementation means that the code was not consulted.

**KNOWN/removal** `Fauxcurrences.jl` does not offer non-pairwsie inter-specific
distances. This is a direct consequence of the next point, which is one of the
most significant additions to the package.

**KNOWN/addition** `Fauxcurrences.jl` offers the ability to weigh the different
matrices (intra v. inter). In the default configuration, all *matrices* have the
same weight. An alternative calibration scheme is to give an equivalent weight
to the sum of the *n* intra-specific matrices, and of the *n(n-1)/2*
inter-specific matrices. Additional calibrations can reflect other biological
constraints. This addition is important because in the case of multiple species,
the pairwise inter-specific distances can rapidly dominate the overall score.
The ability to set a weight matrix can lead to, for example, starting the null
model with only the intra-specific matrices, and then optimizing the
inter-specific matrices.

**KNOWN/difference** `Faucurrences.jl` does not generate distribution of *raster
cells*, and is focused on *observations*. This has been motivated by our
use-cases where rasters can have different spatial resolutions. Generating
occurrences is a little bit more computationallig expensive, but the memory
footprint has been optimized.

**KNOWN/difference** By default, `Fauxcurrences.jl` uses the Haversine distance
for both the evaluation of distance matrices and the generation of new points.
This decision was taken because (i) the Haversine distance is probably a good
enough approximation given the possible measurement error, sampling biases, and
raster resolution, and (ii) the first geodetic problem can be solved in a very
computationally efficient way for this distance, speeding up the generation of
new points significantly.