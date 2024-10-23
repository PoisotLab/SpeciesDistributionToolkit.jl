
# Ensembles

## Bagging
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.Bagging' href='#SDeMo.Bagging'><span class="jlbinding">SDeMo.Bagging</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Bagging
```



[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/bagging.jl#L22-L24)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.outofbag' href='#SDeMo.outofbag'><span class="jlbinding">SDeMo.outofbag</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
outofbag(ensemble::Bagging; kwargs...)
```


This method returns the confusion matrix associated to the out of bag error, wherein the succes in predicting instance _i_ is calculated on the basis of all models that have not been trained on _i_. The consensus of the different models is a simple majority rule.

The additional keywords arguments are passed to `predict`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/bagging.jl#L50-L59)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.bootstrap' href='#SDeMo.bootstrap'><span class="jlbinding">SDeMo.bootstrap</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
bootstrap(y, X; n = 50)
```



[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/bagging.jl#L1-L3)



```julia
bootstrap(sdm::SDM; kwargs...)
```



[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/bagging.jl#L15-L17)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.iqr' href='#SDeMo.iqr'><span class="jlbinding">SDeMo.iqr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
iqr(x, m=0.25, M=0.75)
```


Returns the inter-quantile range, by default between 25% and 75% of observations.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/utilities/varia.jl#L1-L6)

</details>


## Heterogeneous ensembles {#Heterogeneous-ensembles}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.Ensemble' href='#SDeMo.Ensemble'><span class="jlbinding">SDeMo.Ensemble</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Ensemble
```


An heterogeneous ensemble model is defined as a vector of `SDM`s.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/ensemble.jl#L1-L5)

</details>

