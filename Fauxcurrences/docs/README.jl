# # Fauxcurrences.jl

# This package is a *clean-room*, *feature-equivalent* re-write in Julia of most
# of the functionalities of the [`fauxcurrence` package for R][paper]. The
# original code is licensed under the GPL, and this package is licensed under
# the MIT. For this reason, the original code, and any document distributed with
# it, has not been consulted during the implementation; the work is entirely
# based on the published article. As detailed in the following sections, the two
# packages do not have *feature parity*, but there is an overlap in the most
# significant functions.

# [paper]: https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.05880

# The citation for the original `fauxcurrence` paper is

# > Osborne, O. G., Fell, H. G., Atkins, H., van Tol, J., Phillips, D.,
# > Herrera‐Alsina, L., Mynard, P., Bocedi, G., Gubry‐Rangin, C., Lancaster, L.
# > T., Creer, S., Nangoy, M., Fahri, F., Lupiyaningdyah, P., Sudiana, I. M.,
# > Juliandi, B., Travis, J. M. J., Papadopulos, A. S. T., & Algar, A. C.
# > (2022). Fauxcurrence: Simulating multi‐species occurrences for null models
# > in species distribution modelling and biogeography. Ecography.
# > https://doi.org/10.1111/ecog.05880

# ## Why?

# Interoperability: this package uses `SimpleSDMLayers`, `Distances`, and `GBIF`
# as backends, making it fit very snuggly with the rest of the (Eco)Julia
# ecosystem, and working towards integration of tools to build SDMs at scale.

# Expandability: the package is built on modular functions, to ensure that
# custom workflows can be built, while maintaining a general interface.

# Performance: by relying on pre-allocated matrices, the operations are fairly
# fast. Whenever a point changes, only the matrices that are impacted are
# updated, which results in notable improvements for more taxa.

# Licensing: the package uses the more permissive MIT license, imposing fewer
# constraints on contributors.

# ## Overview of methods

# Note that *none* of the methods are exported, so they need to be called with
# `Fauxcurrences.method_name`. These methods are the ones that users will need to
# call to set-up a whole run of the pipeline.

#=
| method                             | description                                                  |
| ---------------------------------- | ------------------------------------------------------------ |
| `get_valid_coordinates`            | transforms GBIF observations to a matrix of coordinates      |
| `preallocate_distance_matrices`    | prepares the matrices for the intra/inter-specific distances |
| `measure_intraspecific_distances!` | updates the intra-specific distances                         |
| `measure_interspecific_distances!` | updates the inter-specific distances                         |
| `preallocate_simulated_points`     | prepare the matrix for the coordinates of simulated points   |
| `bootstrap!`                       | generates the initial proposition for the null               |
| `score_distributions`              | measures the distribution distance                           |
=#

# ## Anatomy of a `Fauxcurrences`  run

# **Step 0**. Prepare the run - the minimal ingredients are a set of coordinates
# (for example using the `GBIF.jl` package), and a layer (one of the
# `SimpleSDMLayer` types, predictor or response does not matter).

using Fauxcurrences
using SimpleSDMLayers
using GBIF

#-

import Random
Random.seed!(616525434012345)

# ### Prepare the occurence data

# Get the observation data in the correct format, which is an array of matrices
# with two rows (longitude, latitude) and one column for observed occurrence.
# This is usually an array of GBIF observations, but all that matters is that
# this is a matrix with longitudes in the first row, and latitudes in the second
# row. The matrix *has* to be column-major, with observations as columns. To
# make sure that we cover a reasonable spatial extent, we will look at the
# default (small) raster distributed with `SimpleSDMLayers`.

layer = geotiff(SimpleSDMPredictor, joinpath(dirname(pathof(SimpleSDMLayers)), "..", "data", "connectivity.tiff"))

# This covers a small area in the Laurentians, north of Montréal, so looking for
# racoons, deers, and white-footed mice is a safe bet:

taxa = taxon.(["Procyon lotor", "Odocoileus virginianus", "Peromyscus leucopus"])

observations = [occurrences(t,
    "hasCoordinate" => "true",
    "decimalLatitude" => extrema(latitudes(layer)),
    "decimalLongitude" => extrema(longitudes(layer)),
    "limit" => 100) for t in taxa]

# The last step is to turn these occurrences into a matrix of latitudes and
# longitudes:

obs = [Fauxcurrences.get_valid_coordinates(o, layer) for o in observations]

# ### Parameters for the run

# Decide on the number of points to generate, and the weight matrix. The number
# of points to generate is, by default, the number of observations in the
# original dataset, but this can be changed to generate balanced samples:

points_to_generate = fill(30, length(obs))

# The weight matrix is used to determine whether intra or inter-specific
# distances are more important in the distribution score. For example, this will
# set up a scoring scheme where intra-specific distances count for 75% of the
# total. The only constraint is that the matrix `W` *must* sum to 1, which is
# enforced by the code internally:

W = Fauxcurrences.weighted_components(length(obs), 0.75)

# ### Pre-allocate the objects

# This is an important part of the run, as `Fauxcurrences` is built to *not*
# allocate more memory than needed. As such, these objects are going to be
# re-written many, many times. The upside is that, if this steps fits in your
# memory, the entire workflow will also fit in your memory.

obs_intra, obs_inter, sim_intra, sim_inter = Fauxcurrences.preallocate_distance_matrices(obs; samples=points_to_generate);

# The entire workflow is designed to use multiple species (as most relevant
# questions will require multiple species). Using a single-species approach only
# required to pass `[obs]` as opposed to `obs`.

# ### Measure the intra and inter-specific distances

# This is an important step as *all generated points* will maintain the upper
# bounds of these distances matrices, *even if the inter-specific distance are
# weightless*.

Fauxcurrences.measure_intraspecific_distances!(obs_intra, obs);
Fauxcurrences.measure_interspecific_distances!(obs_inter, obs);

# ### Bootstrap the initial set of points

# This is a two-step process, involving first the pre-allocation of coordinate
# matrices, and second the population of these matrices using random points.

sim = Fauxcurrences.preallocate_simulated_points(obs; samples=points_to_generate);

# The actual bootstrapping can be a little longer:

Fauxcurrences.bootstrap!(sim, layer, obs, obs_intra, obs_inter, sim_intra, sim_inter);

# ### Bin the distance matrices

# This is to prepare the scoring of the initial solution. Note that the package
# will *never* allow points in the simulated occurrences to create a distance
# matrix where the maximum distance is larger than the maximum distance in the
# empirical matrix.

bin_intra = [Fauxcurrences._bin_distribution(obs_intra[i], maximum(obs_intra[i])) for i in 1:length(obs_intra)];
bin_inter = [Fauxcurrences._bin_distribution(obs_inter[i], maximum(obs_inter[i])) for i in 1:length(obs_inter)];
bin_s_intra = [Fauxcurrences._bin_distribution(sim_intra[i], maximum(obs_intra[i])) for i in 1:length(obs_intra)];
bin_s_inter = [Fauxcurrences._bin_distribution(sim_inter[i], maximum(obs_inter[i])) for i in 1:length(obs_inter)];

# This version of the `_bin_distribution` function is allocating an array for
# the bins, but the internal function is over-writing it, to avoid unwanted
# allocations.

# ### Measure the initial divergence

# This will be the starting point between the observed and simulated
# distributions, and the score that we want to improve. Note that it accounts
# for the weights in the matrix. This step will return a vector, the sum of
# which is the total divergence between the matrices.

D = Fauxcurrences.score_distributions(W, bin_intra, bin_s_intra, bin_inter, bin_s_inter)

# ### Setup the actual run

# This step has infinitely many variations, as `Fauxcurrences` only offers a
# method to do *a single step forward*. In most cases, using *e.g.*
# `ProgressMeter` will be a good way to track the progress of the run, and to
# allow, for example, to stop it when a condition of criteria (absolute/relative
# divergence, globally, on average, or per-species) are met. For the sake of
# simplicity, we return the sum of all divergences, measures for 500000
# timesteps.

progress = zeros(Float64, 500_000)
progress[1] = sum(D)

# ### Run!

# The `step!` function takes most of what we have allocated so far, which is a
# lot, but allows considerable performance gains. The last argument to `step!`
# is the current divergence, and the return value of `step!` (in addition to
# modifying the simulated points) is the new divergence.

# Before running the actual loop, it is a good idea to time a handful of steps?
# Why a handful? Because Julia do be compiling, and because depending on the
# structure of your points, the problem might be more or less difficult to
# solve. In practice, using `ProgressMeter` will make the timing of the whole
# process a lot more informative. In this simple version, we rely on a manually
# created progress report:

for i in 2:length(progress)
    progress[i] = Fauxcurrences.step!(sim, layer, W, obs_intra, obs_inter, sim_intra, sim_inter, bin_intra, bin_inter, bin_s_intra, bin_s_inter, progress[i-1])
    if iszero(i%20_000)
        println("[$(lpad(round(Int64, 100*(i/length(progress))), 3))%]\tJS-divergence: $(round(progress[i]; digits=3))")
    end
end

# The call to `step!` is... lengthy. The reason for this is very simple: `step!`
# will update as much information as it can *in place* when a change is made.
# This means that there are no objects creates (only changed), but the downside
# is that the function needs to be given a lot of information.

# ### Congratulations, your run is done!

# Here, it would make sense to look at the total improvement (or to plot the
# timeseries of the improvement):

println("Improvement: $(round(progress[begin]/progress[end]; digits=2)) ×")

# Note that for a small number of iterations (like we used here), this
# improvement is unlikely to be very large; note also that the returns (in terms
# of improvement over time) are very much diminishing. The good news is that
# re-starting the process is as easy as running the loop with calls to `step!`
# again, as the packages has modified the matrices, and is ready to restart at
# any time.

# You can also look at the per-matrix score, out of all the distance bins (set
# as a package-wide variable, `Fauxcurrences._number_of_bins`, which you are
# encouraged to tweak) -- under a *good* fit, the lines in `bin_intra` and
# `bin_s_intra` would overlap (same with `..._inter`).

# ## Suspected and known changes to the original package

# The changes are classified by whether or not we **KNOW** or **SUSPECT** a
# change, and further by whether the change is a **difference** (the two
# packages do things differently), a **removal** (features from `fauxcurrence`
# have not been ported), or an **addition** (`Fauxcurrences.jl` has unique
# features). Note that because the maintainers of the two packages *do* chat,
# this list may not be entirely up to date, and there has been exchange of ideas
# and features already.

# **KNOWN/difference** The distance between distribution is measured using the
# square root of the ranged Jensen-Shannon divergence (the original package uses
# the Kullback-Leibler divergence) - this measure gives a value in 0-1 *and* is
# a true metric. The JS distance is symmetrical for any two distributions, but
# more importantly, never returns an infinite value when one density is 0 and
# the other is not. For sparse datasets and/or clumped occurrences, this means
# that JS will return a value that can still be compared by the optimizer. Note
# also that for a JS distance of x, the equivalent KL divergence would be of the
# order of x². Using JS distance has the notable advantage of allowing to use an
# upper-triangular matrix for weights, which speeds up calculations
# significantly. Future releases of the package might allow complete matrices,
# but for the moment, these seem to require more guesses about the parameters
# than we are comfortable with.

# **KNOWN/addition** The number of points to simulate can be fixed *per
# species*, which is important because we may want to benchmark algorithms under
# the unrealistic assumption that the sampling effort is the same. It also
# allows users to generate smaller samples of simulated points, which is useful
# if some species have a lot of occurrences.

# **KNOWN/removal** The bootstrap phase (generation of the initial null) picks
# distances from the distance matrix, rather than performing an estimation of
# the underlying distribution. This is mostly because the points will be refined
# anyways, so the faster solution was selected, and because performing a kernel
# approximation sometimes smoothed out ecologically relevant structure in the
# data (notably archipelagos, or grid-based sampling).

# **SUSPECTED/difference** The constraints on simulated points are as follow:
# the intra-specific distance cannot be larger than the observed intra-specific
# distance, and the inter-specific distance cannot be larger than the observed
# pairwise inter-specific distance. This is motivated by two reasons. First,
# this makes the binning of the distributions a lot more stable, as the upport
# bound of the distribution remains the same. Second, this ensures that the
# optimizer does not "cheat" by over-expanding the simulated points.

# **SUSPECTED/difference** During optimization, the *only* criteria that is
# checked is that the average of all divergences (intra-specific and pairwise
# inter-specific) must decrease; this can result in *increases* of the distance
# for one or more of the component distributions. There is no indication in the
# original manuscript of what constitutes an acceptable move, and the clean-room
# re-implementation means that the code was not consulted. This is scheduled to
# be a change in future versions of the package, likely using a `strict` keyword
# to decide whether all divergences need to decrease for the move to be
# considered valid.

# **KNOWN/removal** `Fauxcurrences.jl` does not offer non-pairwsie
# inter-specific distances. This is a direct consequence of the next point,
# which is one of the most significant additions to the package.

# **KNOWN/addition** `Fauxcurrences.jl` offers the ability to weigh the
# different matrices (intra v. inter). In the default configuration, all
# *matrices* have the same weight. An alternative calibration scheme is to give
# an equivalent weight to the sum of the *n* intra-specific matrices, and of the
# *n(n-1)/2* inter-specific matrices. Additional calibrations can reflect other
# biological constraints. This addition is important because in the case of
# multiple species, the pairwise inter-specific distances can rapidly dominate
# the overall score. The ability to set a weight matrix can lead to, for
# example, starting the null model with only the intra-specific matrices, and
# then optimizing the inter-specific matrices.

# **KNOWN/difference** `Faucurrences.jl` does not generate distribution of
# *raster cells*, and is focused on *observations*. This has been motivated by
# our use-cases where rasters can have different spatial resolutions. Generating
# occurrences is a little bit more computationally expensive, but the memory
# footprint has been optimized and the code is rapid enough that downscaling the
# data prior to generation was not identified as a requirement.

# **KNOWN/difference** By default, `Fauxcurrences.jl` uses the Haversine
# distance for both the evaluation of distance matrices and the generation of
# new points. This decision was taken because (i) the Haversine distance is
# probably a good enough approximation given the possible measurement error,
# sampling biases, and raster resolution, and (ii) the first geodetic problem
# can be solved in a very computationally efficient way for this distance,
# speeding up the generation of new points significantly. Do note that generated
# points are *guaranteed* to lay on a valued cell of the layer given as a
# template.