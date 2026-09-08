
# Explanations

## Shapley values {#Shapley-values}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.explain' href='#SDeMo.explain'><span class="jlbinding">SDeMo.explain</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
explain(model::AbstractSDM, j; observation = nothing, instances = nothing, samples = 100, kwargs..., )
```


Uses the MCMC approximation of Shapley values to provide explanations to specific predictions. The second argument `j` is the variable for which the explanation should be provided.

The `observation` keywords is a row in the `instances` dataset for which explanations must be provided. If `instances` is `nothing`, the explanations will be given on the training data.

All other keyword arguments are passed to `predict`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/explanations/shapley.jl#L51-L63)

</details>


## Counterfactuals
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.counterfactual' href='#SDeMo.counterfactual'><span class="jlbinding">SDeMo.counterfactual</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
counterfactual(model::AbstractSDM, x::Vector{T}, yhat, λ; maxiter=100, minvar=5e-5, kwargs...) where {T <: Number}
```


Generates one counterfactual explanation given an input vector `x`, and a target rule to reach `yhat`. The learning rate is `λ`. The maximum number of iterations used in the Nelder-Mead algorithm is `maxiter`, and the variance improvement under which the model will stop is `minvar`. Other keywords are passed to `predict`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/explanations/counterfactual.jl#L104-L112)

</details>


## Partial responses {#Partial-responses}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.partialresponse' href='#SDeMo.partialresponse'><span class="jlbinding">SDeMo.partialresponse</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
partialresponse(model::T, i::Integer, args...; inflated::Bool, kwargs...)
```


This method returns the partial response of applying the trained model to a simulated dataset where all variables _except_ `i` are set to their mean value. The `inflated` keywork, when set to `true`, will instead pick a random value within the range of the observations.

The different arguments that can follow the variable position are
- nothing, where the unique values for the `i`-th variable are used (sorted)
  
- a number, in which point that many evenly spaced points within the range of the variable are used
  
- an array, in which case each value of this array is evaluated
  

All keyword arguments are passed to `predict`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/explanations/partialresponse.jl#L31-L47)



```julia
partialresponse(model::T, i::Integer, j::Integer, s::Tuple=(50, 50); inflated::Bool, kwargs...)
```


This method returns the partial response of applying the trained model to a simulated dataset where all variables _except_ `i` and `j` are set to their mean value.

This function will return a grid corresponding to evenly spaced values of `i` and `j`, the size of which is given by the last argument `s` (defaults to 50 × 50).

All keyword arguments are passed to `predict`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/explanations/partialresponse.jl#L54-L66)

</details>

