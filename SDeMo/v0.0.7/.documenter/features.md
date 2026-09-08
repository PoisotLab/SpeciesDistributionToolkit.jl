
# Features selection and importance {#Features-selection-and-importance}

## Feature selection {#Feature-selection}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.noselection!' href='#SDeMo.noselection!'><span class="jlbinding">SDeMo.noselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
noselection!(model, folds; verbose::Bool = false, kwargs...)
```


Returns the model to the state where all variables are used.

All keyword arguments are passed to `train!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/selection.jl#L1-L7)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.backwardselection!' href='#SDeMo.backwardselection!'><span class="jlbinding">SDeMo.backwardselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
backwardselection!(model, folds; verbose::Bool = false, optimality=mcc, kwargs...)
```


Removes variables one at a time until the `optimality` measure stops increasing.

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/selection.jl#L14-L20)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.forwardselection!' href='#SDeMo.forwardselection!'><span class="jlbinding">SDeMo.forwardselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
forwardselection!(model, folds, pool; verbose::Bool = false, optimality=mcc, kwargs...)
```


Adds variables one at a time until the `optimality` measure stops increasing. The variables in `pool` are added at the start. 

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/selection.jl#L56-L63)



```julia
forwardselection!(model, folds; verbose::Bool = false, optimality=mcc, kwargs...)
```


Adds variables one at a time until the `optimality` measure stops increasing.

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/selection.jl#L100-L106)

</details>


## Feature importance {#Feature-importance}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.variableimportance' href='#SDeMo.variableimportance'><span class="jlbinding">SDeMo.variableimportance</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
variableimportance(model, folds, variable; reps=10, optimality=mcc, kwargs...)
```


Returns the importance of one variable in the model. The `samples` keyword fixes the number of bootstraps to run (defaults to `10`, which is not enough!).

The keywords are passed to `ConfusionMatrix`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/importance.jl#L2-L9)



```julia
variableimportance(model, folds; kwargs...)
```


Returns the importance of all variables in the model. The keywords are passed to `variableimportance`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/importance.jl#L31-L36)

</details>


## Variance Inflation Factor {#Variance-Inflation-Factor}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.stepwisevif!' href='#SDeMo.stepwisevif!'><span class="jlbinding">SDeMo.stepwisevif!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
stepwisevif!(model::SDM, limit, tr=:;kwargs...)
```


Drops the variables with the largest variance inflation from the model, until all VIFs are under the threshold. The last positional argument (defaults to `:`) is the indices to use for the VIF calculation. All keyword arguments are passed to `train!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/vif.jl#L18-L22)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.vif' href='#SDeMo.vif'><span class="jlbinding">SDeMo.vif</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
vif(::Matrix)
```


Returns the variance inflation factor for each variable in a matrix, as the diagonal of the inverse of the correlation matrix between predictors.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/vif.jl#L3-L7)



```julia
vif(::AbstractSDM, tr=:)
```


Returns the VIF for the variables used in a SDM, optionally restricting to some training instances (defaults to `:` for all points). The VIF is calculated on the de-meaned predictors.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/variables/vif.jl#L10-L14)

</details>

