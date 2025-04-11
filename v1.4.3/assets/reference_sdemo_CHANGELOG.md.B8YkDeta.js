import{_ as o,c as a,o as t,ag as r}from"./chunks/framework.CPZFeiPD.js";const g=JSON.parse('{"title":"Changelog","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/CHANGELOG.md","filePath":"reference/sdemo/CHANGELOG.md","lastUpdated":null}'),i={name:"reference/sdemo/CHANGELOG.md"};function n(l,e,s,d,c,h){return t(),a("div",null,e[0]||(e[0]=[r('<h1 id="changelog" tabindex="-1">Changelog <a class="header-anchor" href="#changelog" aria-label="Permalink to &quot;Changelog&quot;">​</a></h1><p>All notable changes to this project will be documented in this file.</p><p>The format is based on <a href="https://keepachangelog.com/en/1.1.0/" target="_blank" rel="noreferrer">Keep a Changelog</a>, and this project adheres to <a href="https://semver.org/spec/v2.0.0.html" target="_blank" rel="noreferrer">Semantic Versioning</a>.</p><h2 id="v1.3.2" tabindex="-1"><code>v1.3.2</code> <a class="header-anchor" href="#v1.3.2" aria-label="Permalink to &quot;`v1.3.2` {#v1.3.2}&quot;">​</a></h2><ul><li><p>** fixed** the problem with hyper-parameters not being restored</p></li><li><p>** fixed** the typing issue in Shapley values</p></li></ul><h2 id="v1.3.2-2" tabindex="-1"><code>v1.3.2</code> <a class="header-anchor" href="#v1.3.2-2" aria-label="Permalink to &quot;`v1.3.2` {#v1.3.2-2}&quot;">​</a></h2><ul><li><strong>fixed</strong> a bug where the Shapley values calculation would not work when applied to a dataset not used for testing</li></ul><h2 id="v1.3.1" tabindex="-1"><code>v1.3.1</code> <a class="header-anchor" href="#v1.3.1" aria-label="Permalink to &quot;`v1.3.1` {#v1.3.1}&quot;">​</a></h2><ul><li><strong>fixed</strong> a bug where the verbose output of variable selection was wrong</li></ul><h2 id="v1.3.0" tabindex="-1"><code>v1.3.0</code> <a class="header-anchor" href="#v1.3.0" aria-label="Permalink to &quot;`v1.3.0` {#v1.3.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> the option to report on validation loss when training a logistic</p></li><li><p><strong>added</strong> the option to pass arbitrary keywords to the training of the classifier</p></li><li><p><strong>improved</strong> the verbose output of logistic regression</p></li><li><p><strong>improved</strong> the internals of <code>train!</code> to use a simpler syntax</p></li><li><p><strong>improved</strong> the verbose output of variable selection</p></li></ul><h2 id="v1.2.3" tabindex="-1"><code>v1.2.3</code> <a class="header-anchor" href="#v1.2.3" aria-label="Permalink to &quot;`v1.2.3` {#v1.2.3}&quot;">​</a></h2><ul><li><p><strong>fixed</strong> the threading mechanism for cross-validation</p></li><li><p><strong>added</strong> a QOL function to sum confusion matrices</p></li></ul><h2 id="v1.2.2" tabindex="-1"><code>v1.2.2</code> <a class="header-anchor" href="#v1.2.2" aria-label="Permalink to &quot;`v1.2.2` {#v1.2.2}&quot;">​</a></h2><ul><li><p><strong>added</strong> the <code>verbose</code> field to <code>Logistic</code> to determine whether to print an output for gradient descent</p></li><li><p><strong>added</strong> the <code>interactions</code> field to <code>Logistic</code> to determine which interactions to include</p></li><li><p><strong>changed</strong> the creation of parameters for <code>Logistic</code> to allow only some interaction terms</p></li><li><p><strong>improved</strong> the performance (speed and memory consumption) of training logistic regressions</p></li></ul><h2 id="v1.2.1" tabindex="-1"><code>v1.2.1</code> <a class="header-anchor" href="#v1.2.1" aria-label="Permalink to &quot;`v1.2.1` {#v1.2.1}&quot;">​</a></h2><ul><li><strong>added</strong> <code>Logistic</code> as a new classifier using logistic regression with gradient descent</li></ul><h2 id="v1.2.0" tabindex="-1"><code>v1.2.0</code> <a class="header-anchor" href="#v1.2.0" aria-label="Permalink to &quot;`v1.2.0` {#v1.2.0}&quot;">​</a></h2><ul><li><strong>changed</strong> the default for bagging to maintain class balance in all bagged models</li></ul><h2 id="v1.1.2" tabindex="-1"><code>v1.1.2</code> <a class="header-anchor" href="#v1.1.2" aria-label="Permalink to &quot;`v1.1.2` {#v1.1.2}&quot;">​</a></h2><ul><li><p><strong>improved</strong> the performance (speed and memory requirement) of prediction with Naive Bayes</p></li><li><p><strong>improved</strong> the performance (speed) of training BIOCLIM</p></li><li><p><strong>improved</strong> the performance (GC) of Shapley explanations</p></li><li><p><strong>improved</strong> the performance (speed) of variable importance</p></li></ul><h2 id="v1.1.1" tabindex="-1"><code>v1.1.1</code> <a class="header-anchor" href="#v1.1.1" aria-label="Permalink to &quot;`v1.1.1` {#v1.1.1}&quot;">​</a></h2><ul><li><strong>improved</strong> the performance (speed and memory requirement) of training decision trees</li></ul><h2 id="v1.1.0" tabindex="-1"><code>v1.1.0</code> <a class="header-anchor" href="#v1.1.0" aria-label="Permalink to &quot;`v1.1.0` {#v1.1.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> backward selection with protected variables (to mirror forced variables in forward selection)</p></li><li><p><strong>added</strong> stratification of presence/absence for cross-validation (prevalence is maintained across folds)</p></li></ul><h2 id="v1.0.0" tabindex="-1"><code>v1.0.0</code> <a class="header-anchor" href="#v1.0.0" aria-label="Permalink to &quot;`v1.0.0` {#v1.0.0}&quot;">​</a></h2><ul><li><p><strong>changed</strong> the default training option for transformers to be presence-only, with the <code>absences=true</code> keyword to use absences as well</p></li><li><p><strong>added</strong> the <code>transformer</code> and <code>classifier</code> methods, that return the transformer and classifier of <code>SDM</code> and <code>Bagging</code> models</p></li></ul>',27)]))}const v=o(i,[["render",n]]);export{g as __pageData,v as default};
