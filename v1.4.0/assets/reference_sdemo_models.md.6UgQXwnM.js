import{_ as n,C as l,c as d,o as p,ag as o,j as s,G as i,a as t,w as r}from"./chunks/framework.CmO0B0Vo.js";const D=JSON.parse('{"title":"Models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/models.md","filePath":"reference/sdemo/models.md","lastUpdated":null}'),u={name:"reference/sdemo/models.md"},c={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""};function k(y,e,_,j,S,C){const a=l("Badge");return p(),d("div",null,[e[32]||(e[32]=o('<h1 id="models" tabindex="-1">Models <a class="header-anchor" href="#models" aria-label="Permalink to &quot;Models&quot;">​</a></h1><p>This page provides information about the models that are currently implemented. All models have three components: a transformer to prepare the data, a classifier to produce a quantitative prediction, and a threshold to turn it into a presence/absence prediction. All three of these components are trained when training a model (plus or minus the keyword arguments to <code>train!</code>).</p><div class="warning custom-block"><p class="custom-block-title">Training of transformers</p><p>The transformers, by default, are only trained on the <em>presences</em>. This is because, in most cases, the pseudo-absences are sampled from the background. When the model uses actual absences, passing <code>absences=true</code> to functions that train the model will instead use the absence data as well.</p></div><h2 id="Transformers-univariate" tabindex="-1">Transformers (univariate) <a class="header-anchor" href="#Transformers-univariate" aria-label="Permalink to &quot;Transformers (univariate) {#Transformers-univariate}&quot;">​</a></h2>',4)),s("details",c,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.RawData",href:"#SDeMo.RawData"},[s("span",{class:"jlbinding"},"SDeMo.RawData")],-1)),e[1]||(e[1]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RawData</span></span></code></pre></div><p>A transformer that does <em>nothing</em> to the data. This is passing the raw data to the classifier, and can be a good first step for models that assume that the features are independent, or are not sensitive to the scale of the features.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[2]||(e[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/transformers/univariate.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",f,[s("summary",null,[e[4]||(e[4]=s("a",{id:"SDeMo.ZScore",href:"#SDeMo.ZScore"},[s("span",{class:"jlbinding"},"SDeMo.ZScore")],-1)),e[5]||(e[5]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[7]||(e[7]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">ZScore</span></span></code></pre></div><p>A transformer that scales and centers the data, using only the data that are avaiable to the model at training time.</p><p>For all variables in the SDM features (regardless of whether they are used), this transformer will store the observed mean and standard deviation. There is no correction on the sample size, because there is no reason to expect that the sample size will be the same for the training and prediction situation.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[6]||(e[6]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/transformers/univariate.jl#L22-L31",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[33]||(e[33]=s("h2",{id:"Transformers-multivariate",tabindex:"-1"},[t("Transformers (multivariate) "),s("a",{class:"header-anchor",href:"#Transformers-multivariate","aria-label":'Permalink to "Transformers (multivariate) {#Transformers-multivariate}"'},"​")],-1)),e[34]||(e[34]=s("p",null,[t("The multivariate transformers are using "),s("a",{href:"https://juliastats.org/MultivariateStats.jl/dev/",target:"_blank",rel:"noreferrer"},[s("code",null,"MultivariateStats")]),t(" to handle the training data. During projection, the features are projected using the transformation that was learned from the training data.")],-1)),s("details",h,[s("summary",null,[e[8]||(e[8]=s("a",{id:"SDeMo.PCATransform",href:"#SDeMo.PCATransform"},[s("span",{class:"jlbinding"},"SDeMo.PCATransform")],-1)),e[9]||(e[9]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">PCATransform</span></span></code></pre></div><p>The PCA transform will project the model features, which also serves as a way to decrease the dimensionality of the problem. Note that this method will only use the training instances, and unless the <code>absences=true</code> keyword is used, only the present cases. This ensure that there is no data leak (neither validation data nor the data from the raster are used).</p><p>This is an alias for <code>MultivariateTransform{PCA}</code>.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[10]||(e[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/transformers/multivariate.jl#L35-L41",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",m,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.WhiteningTransform",href:"#SDeMo.WhiteningTransform"},[s("span",{class:"jlbinding"},"SDeMo.WhiteningTransform")],-1)),e[13]||(e[13]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[15]||(e[15]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">WhiteningTransform</span></span></code></pre></div><p>The whitening transformation is a linear transformation of the input variables, after which the new variables have unit variance and no correlation. The input is transformed into white noise.</p><p>Because this transform will usually keep the first variable &quot;as is&quot;, and then apply increasingly important perturbations on the subsequent variables, it is sensitive to the order in which variables are presented, and is less useful when applying tools for interpretation.</p><p>This is an alias for <code>MultivariateTransform{Whitening}</code>.</p>',4)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[14]||(e[14]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/transformers/multivariate.jl#L45-L53",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",b,[s("summary",null,[e[16]||(e[16]=s("a",{id:"SDeMo.MultivariateTransform",href:"#SDeMo.MultivariateTransform"},[s("span",{class:"jlbinding"},"SDeMo.MultivariateTransform")],-1)),e[17]||(e[17]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[19]||(e[19]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">MultivariateTransform{T} </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> Transformer</span></span></code></pre></div><p><code>T</code> is a multivariate transformation, likely offered through the <code>MultivariateStats</code> package. The transformations currently supported are <code>PCA</code>, <code>PPCA</code>, <code>KernelPCA</code>, and <code>Whitening</code>, and they are documented through their type aliases (<em>e.g.</em> <code>PCATransform</code>).</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[18]||(e[18]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/transformers/multivariate.jl#L5-L11",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[35]||(e[35]=s("h2",{id:"classifiers",tabindex:"-1"},[t("Classifiers "),s("a",{class:"header-anchor",href:"#classifiers","aria-label":'Permalink to "Classifiers"'},"​")],-1)),s("details",T,[s("summary",null,[e[20]||(e[20]=s("a",{id:"SDeMo.NaiveBayes",href:"#SDeMo.NaiveBayes"},[s("span",{class:"jlbinding"},"SDeMo.NaiveBayes")],-1)),e[21]||(e[21]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[23]||(e[23]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">NaiveBayes</span></span></code></pre></div><p>Naive Bayes Classifier</p><p>By default, upon training, the prior probability will be set to the prevalence of the training data.</p>',3)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[22]||(e[22]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/classifiers/naivebayes.jl#L1-L8",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",g,[s("summary",null,[e[24]||(e[24]=s("a",{id:"SDeMo.BIOCLIM",href:"#SDeMo.BIOCLIM"},[s("span",{class:"jlbinding"},"SDeMo.BIOCLIM")],-1)),e[25]||(e[25]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[27]||(e[27]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">BIOCLIM</span></span></code></pre></div><p>BIOCLIM</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[26]||(e[26]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/classifiers/bioclim.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",v,[s("summary",null,[e[28]||(e[28]=s("a",{id:"SDeMo.DecisionTree",href:"#SDeMo.DecisionTree"},[s("span",{class:"jlbinding"},"SDeMo.DecisionTree")],-1)),e[29]||(e[29]=t()),i(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[31]||(e[31]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">DecisionTree</span></span></code></pre></div><p>The depth and number of nodes can be adjusted with <code>maxnodes!</code> and <code>maxdepth!</code>.</p>',2)),i(a,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[30]||(e[30]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/classifiers/decisiontree.jl#L83-L87",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[36]||(e[36]=s("div",{class:"tip custom-block"},[s("p",{class:"custom-block-title"},"Adding new models"),s("p",null,[t("Adding a new transformer or classifier is relatively straightforward (refer to the implementation of "),s("code",null,"ZScore"),t(" and "),s("code",null,"BIOCLIM"),t(" for easily digestible examples). The only methods to implement are "),s("code",null,"train!"),t(" and "),s("code",null,"StatsAPI.predict"),t(".")])],-1))])}const M=n(u,[["render",k]]);export{D as __pageData,M as default};
