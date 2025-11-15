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
scatter!(ax, reliability(sdm, bins=11))
current_figure() #hide

# We can apply different types of calibration functions, such as for example
# isotonic regression:

C = calibrate(IsotonicRegression, sdm)

# The calibration can be applied by passing it to the `correct` function, which
# returns a function to correct a point prediction:

# fig-calibration-corrected
f = Figure()
x = LinRange(0.0, 1.0, 50)
ax = Axis(f[1, 1])
scatter!(ax, reliability(sdm, bins=11))
lines!(ax, x, correct(C).(x))
current_figure() #hide

# The calibration functions can be 