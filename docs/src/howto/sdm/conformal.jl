# # Conformal prediction

# The purpose of this vignette is to show how we can detect which predictions
# are uncertain, using conformal prediction.

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

# We can now identify which proportion of the model predictions are uncertain:

pred = predict(sdm; threshold=false)
sets = predict(cp, pred)
n_uncertain = count(isequal(Set([true, false])), sets)
n_uncertain / length(pred)

# The reason this works is that predicting with a conformal predictor will
# return a set of values that are supported given the calibration data given to
# the model. For example, this is the set of possible values for the 10th
# prediction:

predict(cp, pred[10])

# Note that we can also perform the non-Mondrian version of conformal
# prediction, with the appropriate keyword:

train!(cp, sdm; mondrian=false)

# ::: info Why is Mondrian-CP the default?
# 
# Essentially, this is because we do not really trust absence data when they are
# generated with pseudo-absences. Therefore, it is important to have an
# estimation of uncertainty that reflects the fact that the two classes are
# really distinct. This is the same reason why most data transformers are
# trained on the presence data only.
# 
# :::

# We can now identify which of the model predictions are uncertain:

sets_2 = predict(cp, pred)
count(isequal(Set([true, false])), sets_2) / length(pred)

# 

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# SDeMo.Conformal
# ```
