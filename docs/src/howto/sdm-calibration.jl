# # Calibration of SDM outputs

# The purpose of this vignette is to show how to calibrate the results of an
# SDM.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We will work on the demo data:

X, y = SDeMo.__demodata()
sdm = SDM(PCATransform, NaiveBayes, X, y)
variables!(sdm, ForwardSelection)

# This model returns the following class scores:

# fig-calibration-hist
f = Figure()
ax = Axis(f[1, 1])
hist!(ax, predict(sdm; threshold=false))
current_figure() #hide

# To figure out whether these are close to actual probabilities, we can look at
# the reliability curve

# fig-calibration-reliability
f = Figure()
ax = Axis(f[1, 1])
lines!(ax, [0, 1], [0, 1], color=:grey, linestyle=:dash)
scatterlines!(ax, reliability(sdm, bins=15)..., color=:red)
current_figure() #hide

# We can apply different types of calibration functions, such as for example
# isotonic regression:

C = calibrate(IsotonicCalibration, sdm)

# The calibration can be applied by passing it to the `correct` function, which
# returns a function to correct a point prediction:

# fig-calibration-corrected
f = Figure()
x = LinRange(0.0, 1.0, 50)
ax = Axis(f[1, 1])
lines!(ax, [0, 1], [0, 1], color=:grey, linestyle=:dash)
scatterlines!(ax, reliability(sdm, bins=15)..., color=:red)
lines!(ax, x, correct(C).(x), color=:black, linewidth=2)
current_figure() #hide

# We can check that this calibration is indeed making the model more reliable
# compared to the initial version:

# fig-calibration-check
f = Figure()
x = LinRange(0.0, 1.0, 50)
ax = Axis(f[1, 1])
lines!(ax, [0, 1], [0, 1], color=:grey, linestyle=:dash)
scatterlines!(ax, reliability(sdm, bins=15, link=correct(C))..., color=:red)
current_figure() #hide

# It is possible to pass a `sample` keyword to `calibrate` to only use a series
# of training points for calibration. This allows to use multiple samples to
# estimate the calibration function:

samples = first.(bootstrap(sdm))
C = [calibrate(IsotonicCalibration, sdm; samples=s) for s in samples]
cfunc = correct(C)

# The correction function will then average the results for each calibration to
# return the final probability:

# fig-calibration-ensemble
f = Figure()
x = LinRange(0.0, 1.0, 50)
ax = Axis(f[1, 1])
lines!(ax, [0, 1], [0, 1], color=:grey, linestyle=:dash)
scatterlines!(ax, reliability(sdm, bins=15)..., color=:red)
lines!(ax, x, cfunc.(x), color=:black, linewidth=2)
current_figure() #hide

# The package also implements Platt's calibration with a fast algorithm, which
# is appropriate when the relationship between scores and probabilities is
# sigmoid.