# # Conformal prediction

# The purpose of this vignette is to show how we can detect which predictions
# are uncertain.

using SpeciesDistributionToolkit
import Random #hide
Random.seed!(123451234123121); #hide

# We will work on the demo data:

sdm = SDM(PCATransform, NaiveBayes, SDeMo.__demodata()...)
variables!(sdm, ForwardSelection)

# We are now going to set-up a conformal predictor with a risk level of α =
# 0.05:

cp = Conformal(0.05)

# We now train this conformal predictor:

train!(cp, sdm; mondrian=true)

# We can now identify which of the model predictions are uncertain:

pred = predict(sdm; threshold=false)
sets = predict(cp, pred)
n_uncertain = count(isequal(Set([true, false])), sets)
n_uncertain / length(pred)


# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.Conformal
# ```
