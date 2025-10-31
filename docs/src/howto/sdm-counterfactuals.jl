# # Counterfactuals

# The purpose of this vignette is to show how to generate counterfactual
# explanations from `SDeMo` models.

using SpeciesDistributionToolkit
using PrettyTables
import Random #hide
Random.seed!(123451234123121); #hide

# We will work on the demo data:

X, y = SDeMo.__demodata()
sdm = SDM(RawData, NaiveBayes, X, y)
variables!(sdm, [1, 12])
train!(sdm)

# We will focus on generating a counterfactual input, *i.e.* a set of
# hypothetical inputs that lead the model to predicting the other outcome.
# Internally, candidate points are generated using the Nelder-Mead algorithm,
# which works well enough but is not compatible with categorical data.

# We will pick one prediction to flip:

inst = 6

# And look at its outcome:

outcome = predict(sdm)[inst]

# Our target is expressed in terms of the score we want the counterfactual to
# reach (and not in terms of true/false, this is very important):

target = outcome ? 0.9threshold(sdm) : 1.1threshold(sdm)

# The actual counterfactual is generated as (we only account for the relevant variables):

cf = [
    counterfactual(
        sdm,
        instance(sdm, inst; strict = false),
        target,
        200.0;
        threshold = false,
    ) for _ in 1:5
]
cf = hcat(cf...)

# The last value (set to `200.0` here) is the learning rate, which usually needs
# to be tuned. The input for the observation we are interested in is, as well as
# five possible counterfactuals, are given in the following table:

pretty_table(
    hcat(variables(sdm), instance(sdm, inst), cf[variables(sdm), :]);
    alignment = [:l, :c, :c, :c, :c, :c, :c],
    backend = :markdown,
    column_labels = ["Variable", "Obs.", "C. 1", "C. 2", "C. 3", "C. 4", "C. 5"],
    formatters = [fmt__printf("%4.1f", [2, 3, 4, 5, 6]), fmt__printf("%d", [1])],
)

# We can check the prediction that would be made on all the counterfactuals:

predict(sdm, cf)
