
# Features selection and importance {#Features-selection-and-importance}

## Feature selection {#Feature-selection}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.noselection!' href='#SDeMo.noselection!'><span class="jlbinding">SDeMo.noselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
noselection!(model, folds; verbose::Bool = false, kwargs...)
```


Returns the model to the state where all variables are used.

All keyword arguments are passed to `train!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/selection.jl#L1-L7)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.backwardselection!' href='#SDeMo.backwardselection!'><span class="jlbinding">SDeMo.backwardselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
backwardselection!(model, folds; verbose::Bool = false, optimality=mcc, kwargs...)
```


Removes variables one at a time until the `optimality` measure stops increasing.

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/selection.jl#L14-L20)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.forwardselection!' href='#SDeMo.forwardselection!'><span class="jlbinding">SDeMo.forwardselection!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
forwardselection!(model, folds, pool; verbose::Bool = false, optimality=mcc, kwargs...)
```


Adds variables one at a time until the `optimality` measure stops increasing. The variables in `pool` are added at the start. 

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/selection.jl#L56-L63)



```julia
forwardselection!(model, folds; verbose::Bool = false, optimality=mcc, kwargs...)
```


Adds variables one at a time until the `optimality` measure stops increasing.

All keyword arguments are passed to `crossvalidate!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/selection.jl#L100-L106)

</details>


## Feature importance {#Feature-importance}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.variableimportance' href='#SDeMo.variableimportance'><span class="jlbinding">SDeMo.variableimportance</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
variableimportance(model, folds, variable; reps=10, optimality=mcc, kwargs...)
```


Returns the importance of one variable in the model. The `samples` keyword fixes the number of bootstraps to run (defaults to `10`, which is not enough!).

The keywords are passed to `ConfusionMatrix`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/importance.jl#L2-L9)



```julia
variableimportance(model, folds; kwargs...)
```


Returns the importance of all variables in the model. The keywords are passed to `variableimportance`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/variables/importance.jl#L31-L36)

</details>

