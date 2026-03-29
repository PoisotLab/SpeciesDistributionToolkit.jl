"""
    UntrainedModelError

An error returned when attempting to predict on a model that is not trained
"""
struct UntrainedModelError <: Exception end
