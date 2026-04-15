
# Tools for SDM demos and education {#Tools-for-SDM-demos-and-education}

## The prediction pipeline {#The-prediction-pipeline}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.AbstractSDM' href='#SDeMo.AbstractSDM'><span class="jlbinding">SDeMo.AbstractSDM</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
AbstractSDM
```


TODO


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L1-L5)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.AbstractEnsembleSDM' href='#SDeMo.AbstractEnsembleSDM'><span class="jlbinding">SDeMo.AbstractEnsembleSDM</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
AbstractEnsembleSDM
```


TODO


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L8-L12)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.SDM' href='#SDeMo.SDM'><span class="jlbinding">SDeMo.SDM</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
SDM
```


This type specifies a _full_ model, which is composed of a transformer (which applies a transformation on the data), a classifier (which returns a quantitative score), a threshold (above which the score corresponds to the prediction of a presence).

In addition, the SDM carries with it the training features and labels, as well as a vector of indices indicating which variables are actually used by the model.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L30-L41)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.Transformer' href='#SDeMo.Transformer'><span class="jlbinding">SDeMo.Transformer</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Transformer
```


TODO


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L16-L20)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.Classifier' href='#SDeMo.Classifier'><span class="jlbinding">SDeMo.Classifier</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Classifier
```


TODO


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L23-L27)

</details>


### Utility functions {#Utility-functions}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.features' href='#SDeMo.features'><span class="jlbinding">SDeMo.features</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
features(sdm::SDM)
```


Returns the features stored in the field `X` of the SDM. Note that the features are an array, and this does not return a copy of it – any change made to the output of this function _will_ change the content of the SDM features.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L82-L88)



```julia
features(sdm::SDM, n)
```


Returns the _n_-th feature stored in the field `X` of the SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L91-L95)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.labels' href='#SDeMo.labels'><span class="jlbinding">SDeMo.labels</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
labels(sdm::SDM)
```


Returns the labels stored in the field `y` of the SDM – note that this is not a copy of the labels, but the object itself.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L111-L116)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.threshold' href='#SDeMo.threshold'><span class="jlbinding">SDeMo.threshold</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
threshold(sdm::SDM)
```


This returns the value above which the score returned by the SDM is considered to be a presence.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L67-L72)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.threshold!' href='#SDeMo.threshold!'><span class="jlbinding">SDeMo.threshold!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
threshold!(sdm::SDM, τ)
```


Sets the value of the threshold.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L75-L79)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.variables' href='#SDeMo.variables'><span class="jlbinding">SDeMo.variables</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
variables(sdm::SDM)
```


Returns the list of variables used by the SDM – these _may_ be ordered by importance. This does not return a copy of the variables array, but the array itself.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L119-L125)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.variables!' href='#SDeMo.variables!'><span class="jlbinding">SDeMo.variables!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
variables!(sdm::SDM, v)
```


Sets the list of variables.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L128-L132)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.instance' href='#SDeMo.instance'><span class="jlbinding">SDeMo.instance</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
instance(sdm::SDM, n; strict=true)
```


Returns the _n_-th instance stored in the field `X` of the SDM. If the keyword argument `strict` is `true`, only the variables used for prediction are returned.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/models.jl#L98-L102)

</details>


### Training and predicting {#Training-and-predicting}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.train!' href='#SDeMo.train!'><span class="jlbinding">SDeMo.train!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
train!(ensemble::Bagging; kwargs...)
```


Trains all the model in an ensemble model - the keyword arguments are passed to `train!` for each model. Note that this retrains the _entire_ model, which includes the transformers.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L12-L18)



```julia
train!(ensemble::Ensemble; kwargs...)
```


Trains all the model in an heterogeneous ensemble model - the keyword arguments are passed to `train!` for each model. Note that this retrains the _entire_ model, which includes the transformers.

The keywod arguments are passed to `train!` and can include the `training` indices.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L60-L69)



```julia
train!(sdm::SDM; threshold=true, training=:, optimality=mcc)
```


This is the main training function to train a SDM.

The three keyword arguments are:
- `training`: defaults to `:`, and is the range (or alternatively the indices) of the data that are used to train the model
  
- `threshold`: defaults to `true`, and performs moving threshold by evaluating 200 possible values between the minimum and maximum output of the model, and returning the one that is optimal
  
- `optimality`: defaults to `mcc`, and is the function applied to the confusion matrix to evaluate which value of the threshold is the best
  

Internally, this function trains the transformer, then projects the data, then trains the classifier. If `threshold` is `true`, the threshold is then optimized.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/pipeline.jl#L1-L19)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='StatsAPI.predict' href='#StatsAPI.predict'><span class="jlbinding">StatsAPI.predict</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
StatsAPI.predict(ensemble::Bagging, X; consensus = median, kwargs...)
```


Returns the prediction for the ensemble of models a dataset `X`. The function used to aggregate the outputs from different models is `consensus` (defaults to `median`). All other keyword arguments are passed to `predict`.

To get a direct estimate of the variability, the `consensus` function can be changed to `iqr` (inter-quantile range), or any measure of variance.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L30-L39)



```julia
StatsAPI.predict(ensemble::Bagging; kwargs...)
```


Predicts the ensemble model for all training data.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L51-L55)



```julia
StatsAPI.predict(ensemble::Ensemble, X; consensus = median, kwargs...)
```


Returns the prediction for the heterogeneous ensemble of models a dataset `X`. The function used to aggregate the outputs from different models is `consensus` (defaults to `median`). All other keyword arguments are passed to `predict`.

To get a direct estimate of the variability, the `consensus` function can be changed to `iqr` (inter-quantile range), or any measure of variance.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L77-L86)



```julia
StatsAPI.predict(ensemble::Ensemble; kwargs...)
```


Predicts the heterogeneous ensemble model for all training data.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/ensembles/pipeline.jl#L98-L102)



```julia
StatsAPI.predict(sdm::SDM, X; threshold = true)
```


This is the main prediction function, and it takes as input an SDM and a matrix of features. The only keyword argument is `threshold`, which determines whether the prediction is returned raw or as a binary value (default is `true`).


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/pipeline.jl#L34-L40)



```julia
StatsAPI.predict(sdm::SDM; kwargs...)
```


This method performs the prediction on the entire set of training data available for the training of an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/pipeline.jl#L67-L72)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.reset!' href='#SDeMo.reset!'><span class="jlbinding">SDeMo.reset!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
reset!(sdm::SDM, thr=0.5)
```


Resets a model, with a potentially specified value of the threshold. This amounts to re-using all the variables, and removing the tuned threshold version.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/pipeline.jl#L77-L82)

</details>

