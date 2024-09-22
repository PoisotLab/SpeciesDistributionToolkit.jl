# # A demonstration

# The purpose of this vignette is to take a whistle-stop tour of the what the
# package has to offer.

using SDeMo
using CairoMakie
using PrettyTables
CairoMakie.activate!(; px_per_unit=3) #hide

# load the demo data

X, y = SDeMo.__demodata()

# preapre a NBC

sdm = SDM(MultivariateTransform{PCA}(), NBC(), 0.5, X, y, 1:size(X, 1))

# 