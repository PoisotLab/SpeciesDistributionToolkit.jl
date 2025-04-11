import{_ as o,c as t,o as r,ag as a}from"./chunks/framework.5VWB6o6B.js";const p=JSON.parse('{"title":"Changelog","description":"","frontmatter":{},"headers":[],"relativePath":"reference/changelog/SDeMo.md","filePath":"reference/changelog/SDeMo.md","lastUpdated":null}'),i={name:"reference/changelog/SDeMo.md"};function s(n,e,l,d,c,h){return r(),t("div",null,e[0]||(e[0]=[a('<h1 id="changelog" tabindex="-1">Changelog <a class="header-anchor" href="#changelog" aria-label="Permalink to &quot;Changelog&quot;">​</a></h1><p>All notable changes to this project will be documented in this file.</p><p>The format is based on <a href="https://keepachangelog.com/en/1.1.0/" target="_blank" rel="noreferrer">Keep a Changelog</a>, and this project adheres to <a href="https://semver.org/spec/v2.0.0.html" target="_blank" rel="noreferrer">Semantic Versioning</a>.</p><h2 id="v1.4.0" tabindex="-1"><code>v1.4.0</code> <a class="header-anchor" href="#v1.4.0" aria-label="Permalink to &quot;`v1.4.0` {#v1.4.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> support <code>Bagging</code> models as a component in an <code>Ensemble</code></p></li><li><p><strong>added</strong> support for null classifiers based on <code>Bagging</code> models</p></li><li><p><strong>added</strong> variable selection for <code>Bagging</code> models <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/405" target="_blank" rel="noreferrer">#405</a></p></li><li><p><strong>added</strong> a more general syntax for variable selection (<code>VariableSelectionStrategy</code>)</p></li><li><p><strong>added</strong> a <code>ChainedTransform</code> type to chain two data transformation steps, useful for PCA + z-score <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/408" target="_blank" rel="noreferrer">#408</a></p></li><li><p><strong>fixed</strong> the issue with variable selection reseting the model variables <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/400" target="_blank" rel="noreferrer">#400</a></p></li><li><p><strong>added</strong> a method for <code>noselection!</code> where no folds are given</p></li></ul><h2 id="v1.3.4" tabindex="-1"><code>v1.3.4</code> <a class="header-anchor" href="#v1.3.4" aria-label="Permalink to &quot;`v1.3.4` {#v1.3.4}&quot;">​</a></h2><ul><li><strong>improved</strong> the memory allocation of Logistic regression</li></ul><h2 id="v1.3.3" tabindex="-1"><code>v1.3.3</code> <a class="header-anchor" href="#v1.3.3" aria-label="Permalink to &quot;`v1.3.3` {#v1.3.3}&quot;">​</a></h2><ul><li><p><strong>fixed</strong> the problem with hyper-parameters not being restored <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/371" target="_blank" rel="noreferrer">#371</a></p></li><li><p><strong>fixed</strong> the typing issue in Shapley values <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/392" target="_blank" rel="noreferrer">#392</a></p></li></ul><h2 id="v1.3.2" tabindex="-1"><code>v1.3.2</code> <a class="header-anchor" href="#v1.3.2" aria-label="Permalink to &quot;`v1.3.2` {#v1.3.2}&quot;">​</a></h2><ul><li><strong>fixed</strong> a bug where the Shapley values calculation would not work when applied to a dataset not used for testing <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/375" target="_blank" rel="noreferrer">#375</a></li></ul><h2 id="v1.3.1" tabindex="-1"><code>v1.3.1</code> <a class="header-anchor" href="#v1.3.1" aria-label="Permalink to &quot;`v1.3.1` {#v1.3.1}&quot;">​</a></h2><ul><li><strong>fixed</strong> a bug where the verbose output of variable selection was wrong <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/372" target="_blank" rel="noreferrer">#372</a></li></ul><h2 id="v1.3.0" tabindex="-1"><code>v1.3.0</code> <a class="header-anchor" href="#v1.3.0" aria-label="Permalink to &quot;`v1.3.0` {#v1.3.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> the option to report on validation loss when training a logistic <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/365" target="_blank" rel="noreferrer">#365</a></p></li><li><p><strong>added</strong> the option to pass arbitrary keywords to the training of the classifier</p></li><li><p><strong>improved</strong> the verbose output of logistic regression <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/364" target="_blank" rel="noreferrer">#364</a></p></li><li><p><strong>improved</strong> the internals of <code>train!</code> to use a simpler syntax</p></li><li><p><strong>improved</strong> the verbose output of variable selection <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/366" target="_blank" rel="noreferrer">#366</a></p></li></ul><h2 id="v1.2.3" tabindex="-1"><code>v1.2.3</code> <a class="header-anchor" href="#v1.2.3" aria-label="Permalink to &quot;`v1.2.3` {#v1.2.3}&quot;">​</a></h2><ul><li><p><strong>fixed</strong> the threading mechanism for cross-validation <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues/458" target="_blank" rel="noreferrer">#458</a></p></li><li><p><strong>added</strong> a QOL function to sum confusion matrices</p></li></ul><h2 id="v1.2.2" tabindex="-1"><code>v1.2.2</code> <a class="header-anchor" href="#v1.2.2" aria-label="Permalink to &quot;`v1.2.2` {#v1.2.2}&quot;">​</a></h2><ul><li><p><strong>added</strong> the <code>verbose</code> field to <code>Logistic</code> to determine whether to print an output for gradient descent</p></li><li><p><strong>added</strong> the <code>interactions</code> field to <code>Logistic</code> to determine which interactions to include</p></li><li><p><strong>changed</strong> the creation of parameters for <code>Logistic</code> to allow only some interaction terms</p></li><li><p><strong>improved</strong> the performance (speed and memory consumption) of training logistic regressions</p></li></ul><h2 id="v1.2.1" tabindex="-1"><code>v1.2.1</code> <a class="header-anchor" href="#v1.2.1" aria-label="Permalink to &quot;`v1.2.1` {#v1.2.1}&quot;">​</a></h2><ul><li><strong>added</strong> <code>Logistic</code> as a new classifier using logistic regression with gradient descent</li></ul><h2 id="v1.2.0" tabindex="-1"><code>v1.2.0</code> <a class="header-anchor" href="#v1.2.0" aria-label="Permalink to &quot;`v1.2.0` {#v1.2.0}&quot;">​</a></h2><ul><li><strong>changed</strong> the default for bagging to maintain class balance in all bagged models</li></ul><h2 id="v1.1.2" tabindex="-1"><code>v1.1.2</code> <a class="header-anchor" href="#v1.1.2" aria-label="Permalink to &quot;`v1.1.2` {#v1.1.2}&quot;">​</a></h2><ul><li><p><strong>improved</strong> the performance (speed and memory requirement) of prediction with Naive Bayes</p></li><li><p><strong>improved</strong> the performance (speed) of training BIOCLIM</p></li><li><p><strong>improved</strong> the performance (GC) of Shapley explanations</p></li><li><p><strong>improved</strong> the performance (speed) of variable importance</p></li></ul><h2 id="v1.1.1" tabindex="-1"><code>v1.1.1</code> <a class="header-anchor" href="#v1.1.1" aria-label="Permalink to &quot;`v1.1.1` {#v1.1.1}&quot;">​</a></h2><ul><li><strong>improved</strong> the performance (speed and memory requirement) of training decision trees</li></ul><h2 id="v1.1.0" tabindex="-1"><code>v1.1.0</code> <a class="header-anchor" href="#v1.1.0" aria-label="Permalink to &quot;`v1.1.0` {#v1.1.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> backward selection with protected variables (to mirror forced variables in forward selection)</p></li><li><p><strong>added</strong> stratification of presence/absence for cross-validation (prevalence is maintained across folds)</p></li></ul><h2 id="v1.0.0" tabindex="-1"><code>v1.0.0</code> <a class="header-anchor" href="#v1.0.0" aria-label="Permalink to &quot;`v1.0.0` {#v1.0.0}&quot;">​</a></h2><ul><li><p><strong>changed</strong> the default training option for transformers to be presence-only, with the <code>absences=true</code> keyword to use absences as well</p></li><li><p><strong>added</strong> the <code>transformer</code> and <code>classifier</code> methods, that return the transformer and classifier of <code>SDM</code> and <code>Bagging</code> models</p></li></ul>',31)]))}const u=o(i,[["render",s]]);export{p as __pageData,u as default};
