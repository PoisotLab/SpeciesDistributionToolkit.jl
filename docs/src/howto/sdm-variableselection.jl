# # Variable selection

# The purpose of this vignette is to show how to select variables from `SDeMo`
# models.

using SpeciesDistributionToolkit
using CairoMakie
using PrettyTables
CairoMakie.activate!(; px_per_unit = 3) #hide
import Random #hide
Random.seed!(123451234123121); #hide

# We will work on the demo data:

X, y = SDeMo.__demodata()

# We will start with the full set of BIOCLIM variables:

sdm = SDM(RawData, DecisionTree, X, y)

# Variable selections proceeds (in most cases) through cross-validation, so we
# can pick an appropriate splitting scheme for our data (here, 10 random holdout sets):

folds = montecarlo(sdm; n = 10)

# ::: warning Re-training
#
# Variable selection will retrain the model at the end of the process, so it can
# be used directly.
#
# :::

# We can apply different variable selection steps, the first of which is
# stepwise variance inflation factor:

variables!(sdm, StrictVarianceInflationFactor{5.0})
variables(sdm)

# There are routines for forward/backward selection. All of them accept a final
# argument that represents variables which _must_ be included in the model. All
# variable selection strategies are of the type `VariableSelectionStrategy`.

variables!(sdm, AllVariables)
variables!(sdm, ForwardSelection, folds; included = [1, 12])
variables(sdm)

# Note that there is a keyword, `verbose`, which can be used to print the
# progress of variable selection. All methods using stepwise selection perform
# cross-validation and optimize the MCC.

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.VariableSelectionStrategy
# SDeMo.ForwardSelection
# SDeMo.BackwardSelection
# SDeMo.AllVariables
# SDeMo.VarianceInflationFactor
# SDeMo.StrictVarianceInflationFactor
# ```
