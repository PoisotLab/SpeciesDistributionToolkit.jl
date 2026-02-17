
# Transformers and classifiers {#Transformers-and-classifiers}

## Transformers (univariate) {#Transformers-(univariate)}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.RawData' href='#SDeMo.RawData'><span class="jlbinding">SDeMo.RawData</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
RawData
```


A transformer that does _nothing_ to the data. This is passing the raw data to the classifier.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/univariate.jl#L1-L6)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.ZScore' href='#SDeMo.ZScore'><span class="jlbinding">SDeMo.ZScore</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
ZScore
```


A transformer that scales and centers the data, using only the data that are avaiable to the model at training time. For all variables in the SDM features (regardless of whether they are used), this transformer will store the observed mean and standard deviation.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/univariate.jl#L22-L29)

</details>


## Transformers (multivariate) {#Transformers-(multivariate)}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.MultivariateTransform' href='#SDeMo.MultivariateTransform'><span class="jlbinding">SDeMo.MultivariateTransform</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
MultivariateTransform{T} <: Transformer
```


`T` is a multivariate transformation, likely offered through the `MultivariateStats` package. The transformations currently supported are `PCA`, `PPCA`, `KernelPCA`, and `Whitening`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/multivariate.jl#L5-L11)

</details>


## Classifiers
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.NaiveBayes' href='#SDeMo.NaiveBayes'><span class="jlbinding">SDeMo.NaiveBayes</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NaiveBayes
```


Naive Bayes Classifier

By default, upon training, the prior probability will be set to the prevalence of the training data.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/naivebayes.jl#L1-L8)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.BIOCLIM' href='#SDeMo.BIOCLIM'><span class="jlbinding">SDeMo.BIOCLIM</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
BIOCLIM
```


BIOCLIM


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/bioclim.jl#L1-L5)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.DecisionTree' href='#SDeMo.DecisionTree'><span class="jlbinding">SDeMo.DecisionTree</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
DecisionTree
```


The depth and number of nodes can be adjusted with `maxnodes!` and `maxdepth!`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/decisiontree.jl#L76-L80)

</details>

