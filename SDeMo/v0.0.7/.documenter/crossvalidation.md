
# Cross-validation

## Confusion matrix {#Confusion-matrix}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.ConfusionMatrix' href='#SDeMo.ConfusionMatrix'><span class="jlbinding">SDeMo.ConfusionMatrix</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
ConfusionMatrix{T <: Number}
```


A structure to store the true positives, true negatives, false positives, and false negatives counts (or proportion) during model evaluation. Empty confusion matrices can be created using the `zero` method.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/confusionmatrix.jl#L1-L7)

</details>


## Folds

These methods will all take as input a vector of labels and a matrix of features, and return a vector of tuples, that have the training indices in the first position, and the validation data in the second. This is not true for `holdout`, which returns a single tuple.
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.holdout' href='#SDeMo.holdout'><span class="jlbinding">SDeMo.holdout</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
holdout(y, X; proportion = 0.2, permute = true)
```


Sets aside a proportion (given by the `proportion` keyword, defaults to `0.2`) of observations to use for validation, and the rest for training. An additional argument `permute` (defaults to `true`) can be used to shuffle the order of observations before they are split.

This method returns a single tuple with the training data first and the validation data second. To use this with `crossvalidate`, it must be put in `[]`.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L24-L35)



```julia
holdout(sdm::SDM)
```


Version of `holdout` using the instances and labels of an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L126-L130)



```julia
holdout(sdm::Bagging)
```


Version of `holdout` using the instances and labels of a bagged SDM. In this case, the instances of the model used as a reference to build the bagged model are used.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L133-L137)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.montecarlo' href='#SDeMo.montecarlo'><span class="jlbinding">SDeMo.montecarlo</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
montecarlo(y, X; n = 100, kwargs...)
```


Returns `n` (def. `100`) samples of `holdout`. Other keyword arguments are passed to `holdout`.

This method returns a vector of tuples, with each entry have the training data first, and the validation data second.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L57-L65)



```julia
montecarlo(sdm::SDM)
```


Version of `montecarlo` using the instances and labels of an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L126-L130)



```julia
montecarlo(sdm::Bagging)
```


Version of `montecarlo` using the instances and labels of a bagged SDM. In this case, the instances of the model used as a reference to build the bagged model are used.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L133-L137)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.leaveoneout' href='#SDeMo.leaveoneout'><span class="jlbinding">SDeMo.leaveoneout</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
leaveoneout(y, X)
```


Returns the splits for leave-one-out cross-validation. Each sample is used once, on its own, for validation.

This method returns a vector of tuples, with each entry have the training data first, and the validation data second.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L1-L9)



```julia
leaveoneout(sdm::SDM)
```


Version of `leaveoneout` using the instances and labels of an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L126-L130)



```julia
leaveoneout(sdm::Bagging)
```


Version of `leaveoneout` using the instances and labels of a bagged SDM. In this case, the instances of the model used as a reference to build the bagged model are used.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L133-L137)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.kfold' href='#SDeMo.kfold'><span class="jlbinding">SDeMo.kfold</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
kfold(y, X; k = 10, permute = true)
```


Returns splits of the data in which 1 group is used for validation, and `k`-1 groups are used for training. All `k``groups have the (approximate) same size, and each instance is only used once for validation (and`k`-1 times for training).

This method returns a vector of tuples, with each entry have the training data first, and the validation data second.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L80-L89)



```julia
kfold(sdm::SDM)
```


Version of `kfold` using the instances and labels of an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L126-L130)



```julia
kfold(sdm::Bagging)
```


Version of `kfold` using the instances and labels of a bagged SDM. In this case, the instances of the model used as a reference to build the bagged model are used.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L133-L137)

</details>


## Cross-validation {#Cross-validation-2}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.crossvalidate' href='#SDeMo.crossvalidate'><span class="jlbinding">SDeMo.crossvalidate</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
crossvalidate(sdm, folds; thr = nothing, kwargs...)
```


Performs cross-validation on a model, given a vector of tuples representing the data splits. The threshold can be fixed through the `thr` keyword arguments. All other keywords are passed to the `train!` method.

This method returns two vectors of `ConfusionMatrix`, with the confusion matrix for each set of validation data first, and the confusion matrix for the training data second.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/crossvalidation.jl#L150-L160)

</details>


## Null classifiers {#Null-classifiers}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.noskill' href='#SDeMo.noskill'><span class="jlbinding">SDeMo.noskill</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
noskill(labels::Vector{Bool})
```


Returns the confusion matrix for the no-skill classifier given a vector of labels. Predictions are made at random, with each class being selected by its proportion in the training data.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L1-L7)



```julia
noskill(sdm::SDM)
```


Version of `noskill` using the training labels for an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L65-L69)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.coinflip' href='#SDeMo.coinflip'><span class="jlbinding">SDeMo.coinflip</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
coinflip(labels::Vector{Bool})
```


Returns the confusion matrix for the no-skill classifier given a vector of labels. Predictions are made at random, with each class being selected with a probability of one half.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L17-L23)



```julia
coinflip(sdm::SDM)
```


Version of `coinflip` using the training labels for an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L65-L69)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.constantnegative' href='#SDeMo.constantnegative'><span class="jlbinding">SDeMo.constantnegative</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
constantnegative(labels::Vector{Bool})
```


Returns the confusion matrix for the constant positive classifier given a vector of labels. Predictions are assumed to always be negative.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L48-L53)



```julia
constantnegative(sdm::SDM)
```


Version of `constantnegative` using the training labels for an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L65-L69)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.constantpositive' href='#SDeMo.constantpositive'><span class="jlbinding">SDeMo.constantpositive</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
constantpositive(labels::Vector{Bool})
```


Returns the confusion matrix for the constant positive classifier given a vector of labels. Predictions are assumed to always be positive.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L33-L38)



```julia
constantpositive(sdm::SDM)
```


Version of `constantpositive` using the training labels for an SDM.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/null.jl#L65-L69)

</details>


## List of performance measures {#List-of-performance-measures}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.tpr' href='#SDeMo.tpr'><span class="jlbinding">SDeMo.tpr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
tpr(M::ConfusionMatrix)
```


True-positive rate

$\frac{TP}{TP+FN}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L1-L7)



```julia
tpr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `tpr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.tnr' href='#SDeMo.tnr'><span class="jlbinding">SDeMo.tnr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
tnr(M::ConfusionMatrix)
```


True-negative rate

$\frac{TN}{TN+FP}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L10-L16)



```julia
tnr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `tnr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.fpr' href='#SDeMo.fpr'><span class="jlbinding">SDeMo.fpr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
fpr(M::ConfusionMatrix)
```


False-positive rate

$\frac{FP}{FP+TN}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L46-L52)



```julia
fpr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `fpr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.fnr' href='#SDeMo.fnr'><span class="jlbinding">SDeMo.fnr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
fnr(M::ConfusionMatrix)
```


False-negative rate

$\frac{FN}{FN+TP}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L37-L43)



```julia
fnr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `fnr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.ppv' href='#SDeMo.ppv'><span class="jlbinding">SDeMo.ppv</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
ppv(M::ConfusionMatrix)
```


Positive predictive value

$\frac{TP}{TP+FP}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L19-L25)



```julia
ppv(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `ppv` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.npv' href='#SDeMo.npv'><span class="jlbinding">SDeMo.npv</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
npv(M::ConfusionMatrix)
```


Negative predictive value

$\frac{TN}{TN+FN}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L28-L34)



```julia
npv(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `npv` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.fdir' href='#SDeMo.fdir'><span class="jlbinding">SDeMo.fdir</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
fdir(M::ConfusionMatrix)
```


False discovery rate, 1 - `ppv`


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L55-L59)



```julia
fdir(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `fdir` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.fomr' href='#SDeMo.fomr'><span class="jlbinding">SDeMo.fomr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
fomr(M::ConfusionMatrix)
```


False omission rate, 1 - `npv`


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L62-L66)



```julia
fomr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `fomr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.plr' href='#SDeMo.plr'><span class="jlbinding">SDeMo.plr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
plr(M::ConfusionMatrix)
```


Positive likelihood ratio

$\frac{TPR}{FPR}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L69-L75)



```julia
plr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `plr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.nlr' href='#SDeMo.nlr'><span class="jlbinding">SDeMo.nlr</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
nlr(M::ConfusionMatrix)
```


Negative likelihood ratio

$\frac{FNR}{TNR}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L78-L84)



```julia
nlr(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `nlr` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.accuracy' href='#SDeMo.accuracy'><span class="jlbinding">SDeMo.accuracy</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
accuracy(M::ConfusionMatrix)
```


Accuracy

$\frac{TP + TN}{TP + TN + FP + FN}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L87-L93)



```julia
accuracy(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `accuracy` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.balancedaccuracy' href='#SDeMo.balancedaccuracy'><span class="jlbinding">SDeMo.balancedaccuracy</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
balanced(M::ConfusionMatrix)
```


Balanced accuracy

$\frac{1}{2} (TPR + TNR)$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L96-L102)



```julia
balancedaccuracy(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `balancedaccuracy` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.f1' href='#SDeMo.f1'><span class="jlbinding">SDeMo.f1</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
f1(M::ConfusionMatrix)
```


F₁ score, defined as the harmonic mean between precision and recall:

$2\times\frac{PPV\times TPR}{PPV + TPR}$

This uses the more general `fscore` internally.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L105-L113)



```julia
f1(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `f1` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.fscore' href='#SDeMo.fscore'><span class="jlbinding">SDeMo.fscore</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
fscore(M::ConfusionMatrix, β=1.0)
```


Fᵦ score, defined as the harmonic mean between precision and recall, using a positive factor β indicating the relative importance of recall over precision:

$(1 + \beta^2)\times\frac{PPV\times TPR}{(\beta^2 \times PPV) + TPR}$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L116-L123)



```julia
fscore(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `fscore` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.trueskill' href='#SDeMo.trueskill'><span class="jlbinding">SDeMo.trueskill</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
trueskill(M::ConfusionMatrix)
```


True skill statistic (a.k.a Youden&#39;s J, or informedness)

$TPR + TNR - 1$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L127-L133)



```julia
trueskill(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `trueskill` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.markedness' href='#SDeMo.markedness'><span class="jlbinding">SDeMo.markedness</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
markedness(M::ConfusionMatrix)
```


Markedness, a measure similar to informedness (TSS) that emphasizes negative predictions

$PPV + NPV -1$


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L136-L143)



```julia
markedness(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `markedness` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.dor' href='#SDeMo.dor'><span class="jlbinding">SDeMo.dor</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
dor(M::ConfusionMatrix)
```


Diagnostic odd ratio, defined as `plr`/`nlr`. A useful test has a value larger than unity, and this value has no upper bound.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L146-L151)



```julia
dor(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `dor` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.κ' href='#SDeMo.κ'><span class="jlbinding">SDeMo.κ</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
κ(M::ConfusionMatrix)
```


Cohen&#39;s κ


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L155-L159)



```julia
κ(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `κ` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.mcc' href='#SDeMo.mcc'><span class="jlbinding">SDeMo.mcc</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
mcc(M::ConfusionMatrix)
```


Matthew&#39;s correlation coefficient. This is the default measure of model performance, and there are rarely good reasons to use anything else to decide which model to use.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L165-L171)



```julia
mcc(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `mcc` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>


## Confidence interval {#Confidence-interval}
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.ci' href='#SDeMo.ci'><span class="jlbinding">SDeMo.ci</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
ci(C::Vector{ConfusionMatrix}, f)
```


Applies `f` to all confusion matrices in the vector, and returns the 95% CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L187-L191)



```julia
ci(C::Vector{ConfusionMatrix})
```


Applies the MCC (`mcc`) to all confusion matrices in the vector, and returns the 95% CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L197-L201)

</details>


## Aliases
<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.specificity' href='#SDeMo.specificity'><span class="jlbinding">SDeMo.specificity</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
specificity(M::ConfusionMatrix)
```


Alias for `tnr`, the true negative rate


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L220-L224)



```julia
specificity(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `specificity` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.sensitivity' href='#SDeMo.sensitivity'><span class="jlbinding">SDeMo.sensitivity</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
sensitivity(M::ConfusionMatrix)
```


Alias for `tpr`, the true positive rate


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L206-L210)



```julia
sensitivity(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `sensitivity` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.recall' href='#SDeMo.recall'><span class="jlbinding">SDeMo.recall</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
recall(M::ConfusionMatrix)
```


Alias for `tpr`, the true positive rate


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L213-L217)



```julia
recall(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `recall` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SDeMo.precision' href='#SDeMo.precision'><span class="jlbinding">SDeMo.precision</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
precision(M::ConfusionMatrix)
```


Alias for `ppv`, the positive predictive value


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L227-L231)



```julia
precision(C::Vector{ConfusionMatrix}, full::Bool=false)
```


Version of `precision` using a vector of confusion matrices. Returns the mean, and when the second argument is `true`, returns a tuple where the second argument is the CI.


[source](https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/41e5565320b25bf604f7d190dc50c83e70c32033/SDeMo/src/crossvalidation/validation.jl#L261-L265)

</details>

