import{_ as r,C as l,c as d,o as p,ag as o,j as s,G as a,a as i,w as n}from"./chunks/framework.DOx8QQ6_.js";const P=JSON.parse('{"title":"Models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/models.md","filePath":"reference/sdemo/models.md","lastUpdated":null}'),u={name:"reference/sdemo/models.md"},c={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""};function v(j,e,_,S,D,C){const t=l("Badge");return p(),d("div",null,[e[36]||(e[36]=o('<h1 id="models" tabindex="-1">Models <a class="header-anchor" href="#models" aria-label="Permalink to &quot;Models&quot;">​</a></h1><p>This page provides information about the models that are currently implemented. All models have three components: a transformer to prepare the data, a classifier to produce a quantitative prediction, and a threshold to turn it into a presence/absence prediction. All three of these components are trained when training a model (plus or minus the keyword arguments to <code>train!</code>).</p><div class="warning custom-block"><p class="custom-block-title">Training of transformers</p><p>The transformers, by default, are only trained on the <em>presences</em>. This is because, in most cases, the pseudo-absences are sampled from the background. When the model uses actual absences, passing <code>absences=true</code> to functions that train the model will instead use the absence data as well.</p></div><h2 id="Transformers-univariate" tabindex="-1">Transformers (univariate) <a class="header-anchor" href="#Transformers-univariate" aria-label="Permalink to &quot;Transformers (univariate) {#Transformers-univariate}&quot;">​</a></h2>',4)),s("details",c,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.RawData",href:"#SDeMo.RawData"},[s("span",{class:"jlbinding"},"SDeMo.RawData")],-1)),e[1]||(e[1]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RawData</span></span></code></pre></div><p>A transformer that does <em>nothing</em> to the data. This is passing the raw data to the classifier, and can be a good first step for models that assume that the features are independent, or are not sensitive to the scale of the features.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[2]||(e[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/transformers/univariate.jl#L1-L7",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",m,[s("summary",null,[e[4]||(e[4]=s("a",{id:"SDeMo.ZScore",href:"#SDeMo.ZScore"},[s("span",{class:"jlbinding"},"SDeMo.ZScore")],-1)),e[5]||(e[5]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[7]||(e[7]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">ZScore</span></span></code></pre></div><p>A transformer that scales and centers the data, using only the data that are avaiable to the model at training time.</p><p>For all variables in the SDM features (regardless of whether they are used), this transformer will store the observed mean and standard deviation. There is no correction on the sample size, because there is no reason to expect that the sample size will be the same for the training and prediction situation.</p>',3)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[6]||(e[6]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/transformers/univariate.jl#L23-L33",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[37]||(e[37]=s("h2",{id:"Transformers-multivariate",tabindex:"-1"},[i("Transformers (multivariate) "),s("a",{class:"header-anchor",href:"#Transformers-multivariate","aria-label":'Permalink to "Transformers (multivariate) {#Transformers-multivariate}"'},"​")],-1)),e[38]||(e[38]=s("p",null,[i("The multivariate transformers are using "),s("a",{href:"https://juliastats.org/MultivariateStats.jl/dev/",target:"_blank",rel:"noreferrer"},[s("code",null,"MultivariateStats")]),i(" to handle the training data. During projection, the features are projected using the transformation that was learned from the training data.")],-1)),s("details",f,[s("summary",null,[e[8]||(e[8]=s("a",{id:"SDeMo.PCATransform",href:"#SDeMo.PCATransform"},[s("span",{class:"jlbinding"},"SDeMo.PCATransform")],-1)),e[9]||(e[9]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">PCATransform</span></span></code></pre></div><p>The PCA transform will project the model features, which also serves as a way to decrease the dimensionality of the problem. Note that this method will only use the training instances, and unless the <code>absences=true</code> keyword is used, only the present cases. This ensure that there is no data leak (neither validation data nor the data from the raster are used).</p><p>This is an alias for <code>MultivariateTransform{PCA}</code>.</p>',3)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[10]||(e[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/transformers/multivariate.jl#L35-L41",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",h,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.WhiteningTransform",href:"#SDeMo.WhiteningTransform"},[s("span",{class:"jlbinding"},"SDeMo.WhiteningTransform")],-1)),e[13]||(e[13]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[15]||(e[15]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">WhiteningTransform</span></span></code></pre></div><p>The whitening transformation is a linear transformation of the input variables, after which the new variables have unit variance and no correlation. The input is transformed into white noise.</p><p>Because this transform will usually keep the first variable &quot;as is&quot;, and then apply increasingly important perturbations on the subsequent variables, it is sensitive to the order in which variables are presented, and is less useful when applying tools for interpretation.</p><p>This is an alias for <code>MultivariateTransform{Whitening}</code>.</p>',4)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[14]||(e[14]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/transformers/multivariate.jl#L45-L53",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",b,[s("summary",null,[e[16]||(e[16]=s("a",{id:"SDeMo.MultivariateTransform",href:"#SDeMo.MultivariateTransform"},[s("span",{class:"jlbinding"},"SDeMo.MultivariateTransform")],-1)),e[17]||(e[17]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[19]||(e[19]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">MultivariateTransform{T} </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> Transformer</span></span></code></pre></div><p><code>T</code> is a multivariate transformation, likely offered through the <code>MultivariateStats</code> package. The transformations currently supported are <code>PCA</code>, <code>PPCA</code>, <code>KernelPCA</code>, and <code>Whitening</code>, and they are documented through their type aliases (<em>e.g.</em> <code>PCATransform</code>).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[18]||(e[18]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/transformers/multivariate.jl#L5-L11",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[39]||(e[39]=s("h2",{id:"classifiers",tabindex:"-1"},[i("Classifiers "),s("a",{class:"header-anchor",href:"#classifiers","aria-label":'Permalink to "Classifiers"'},"​")],-1)),s("details",T,[s("summary",null,[e[20]||(e[20]=s("a",{id:"SDeMo.NaiveBayes",href:"#SDeMo.NaiveBayes"},[s("span",{class:"jlbinding"},"SDeMo.NaiveBayes")],-1)),e[21]||(e[21]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[23]||(e[23]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">NaiveBayes</span></span></code></pre></div><p>Naive Bayes Classifier</p><p>By default, upon training, the prior probability will be set to the prevalence of the training data.</p>',3)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[22]||(e[22]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/classifiers/naivebayes.jl#L1-L8",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",g,[s("summary",null,[e[24]||(e[24]=s("a",{id:"SDeMo.BIOCLIM",href:"#SDeMo.BIOCLIM"},[s("span",{class:"jlbinding"},"SDeMo.BIOCLIM")],-1)),e[25]||(e[25]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[27]||(e[27]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">BIOCLIM</span></span></code></pre></div><p>BIOCLIM</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[26]||(e[26]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/classifiers/bioclim.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",y,[s("summary",null,[e[28]||(e[28]=s("a",{id:"SDeMo.DecisionTree",href:"#SDeMo.DecisionTree"},[s("span",{class:"jlbinding"},"SDeMo.DecisionTree")],-1)),e[29]||(e[29]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[31]||(e[31]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">DecisionTree</span></span></code></pre></div><p>The depth and number of nodes can be adjusted with <code>maxnodes!</code> and <code>maxdepth!</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[30]||(e[30]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/classifiers/decisiontree.jl#L83-L87",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",k,[s("summary",null,[e[32]||(e[32]=s("a",{id:"SDeMo.Logistic",href:"#SDeMo.Logistic"},[s("span",{class:"jlbinding"},"SDeMo.Logistic")],-1)),e[33]||(e[33]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[35]||(e[35]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Logistic</span></span></code></pre></div><p>Logistic regression with default learning rate of 0.01, penalization (L2) of 0.1, and 2000 epochs. Note that interaction terms can be turned on and off through the use of the <code>interactions</code> field. Possible values are <code>:all</code> (default), <code>:self</code> (only squared terms), and <code>:none</code> (no interactions).</p><p>The <code>verbose</code> field (defaults to <code>false</code>) can be used to show the progress of gradient descent, by showing the loss every 100 epochs, or to the value of the <code>verbosity</code> field. Note that when doing cross-validation, the loss on the validation data will be automatically reported.</p>',3)),a(t,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[34]||(e[34]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SDeMo/src/classifiers/logistic.jl#L63-L75",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[40]||(e[40]=s("div",{class:"tip custom-block"},[s("p",{class:"custom-block-title"},"Adding new models"),s("p",null,[i("Adding a new transformer or classifier is relatively straightforward (refer to the implementation of "),s("code",null,"ZScore"),i(" and "),s("code",null,"BIOCLIM"),i(" for easily digestible examples). The only methods to implement are "),s("code",null,"train!"),i(" and "),s("code",null,"StatsAPI.predict"),i(".")])],-1))])}const A=r(u,[["render",v]]);export{P as __pageData,A as default};
