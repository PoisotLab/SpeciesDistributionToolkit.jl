
# Saving models {#Saving-models}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.loadsdm' href='#SDeMo.loadsdm'><span class="jlbinding">SDeMo.loadsdm</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
loadsdm(file::String; kwargs...)
```


Loads a model to a `JSON` file. The keyword arguments are passed to `train!`. The model is trained in full upon loading.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/utilities/io.jl#L50-L55)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.writesdm' href='#SDeMo.writesdm'><span class="jlbinding">SDeMo.writesdm</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
writesdm(file::String, model::SDM)
```


Writes a model to a `JSON` file. This method is very bare-bones, and only saves the _structure_ of the model, as well as the data.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/utilities/io.jl#L38-L43)

</details>

