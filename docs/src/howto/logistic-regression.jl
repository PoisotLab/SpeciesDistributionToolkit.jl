# # Logistic regression

# The purpose of this vignette is to show some functionalities of logistic
# regression in `SDeMo`.

using SpeciesDistributionToolkit
using CairoMakie
CairoMakie.activate!(; px_per_unit = 3) #hide

# We will work on the demo data:

X, y = SDeMo.__demodata()

# By default,`ZScore` is most likely the transformation you need for logistic
# regression. We will limit the model to two variables for the sake of
# illustration.

sdm = SDM(ZScore, Logistic, X, y)
variables!(sdm, [1, 12])

# By default, training this model will use all interactions (we will tweak this
# later), and perform L2 regularization (this is fixed and cannot be changed):

train!(sdm)

# **Although this syntax may change** as the function is not exported, we can
# look at the formula identified:

SDeMo.__equation(sdm)

# If we want to turn the interactions off, we can start by restricting them to self interactions between variables:

sdm.classifier.interactions = :self
train!(sdm)
SDeMo.__equation(sdm)

# We can similarly prevent any interactions

sdm.classifier.interactions = :none
train!(sdm)
SDeMo.__equation(sdm)

# Future releases will add a mechanism to more intuitively tweak the model parameters.

# The logistic regression uses gradient descent internally, which means that we
# can tweak the learning rate η (lower is slower but more stable), the
# regularization parameter λ, and the number of epochs used for training. For
# example, if we want slower learning with more penalty for large parameters, we
# can write

sdm.classifier.interactions = :all
sdm.classifier.η = 1e-4
sdm.classifier.λ = 0.2
sdm.classifier.epochs = 10_000
train!(sdm)
SDeMo.__equation(sdm)

# As the number of epochs is not always obvious, we can request verbose training:

sdm.classifier.interactions = :none
sdm.classifier.η = 1e-5
sdm.classifier.λ = 0.1
sdm.classifier.verbose = true
sdm.classifier.epochs = 2000
train!(sdm)
SDeMo.__equation(sdm)
