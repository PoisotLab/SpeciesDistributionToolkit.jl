import{_ as o,c as l,j as s,a,G as t,a2 as r,B as n,o as d}from"./chunks/framework.jZ-ZOMvL.js";const S=JSON.parse('{"title":"Transformers and classifiers","description":"","frontmatter":{},"headers":[],"relativePath":"models.md","filePath":"models.md","lastUpdated":null}'),p={name:"models.md"},c={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""};function g(k,e,v,y,j,T){const i=n("Badge");return d(),l("div",null,[e[18]||(e[18]=s("h1",{id:"Transformers-and-classifiers",tabindex:"-1"},[a("Transformers and classifiers "),s("a",{class:"header-anchor",href:"#Transformers-and-classifiers","aria-label":'Permalink to "Transformers and classifiers {#Transformers-and-classifiers}"'},"​")],-1)),e[19]||(e[19]=s("h2",{id:"Transformers-(univariate)",tabindex:"-1"},[a("Transformers (univariate) "),s("a",{class:"header-anchor",href:"#Transformers-(univariate)","aria-label":'Permalink to "Transformers (univariate) {#Transformers-(univariate)}"'},"​")],-1)),s("details",c,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.RawData",href:"#SDeMo.RawData"},[s("span",{class:"jlbinding"},"SDeMo.RawData")],-1)),e[1]||(e[1]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RawData</span></span></code></pre></div><p>A transformer that does <em>nothing</em> to the data. This is passing the raw data to the classifier.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/univariate.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",b,[s("summary",null,[e[3]||(e[3]=s("a",{id:"SDeMo.ZScore",href:"#SDeMo.ZScore"},[s("span",{class:"jlbinding"},"SDeMo.ZScore")],-1)),e[4]||(e[4]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[5]||(e[5]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">ZScore</span></span></code></pre></div><p>A transformer that scales and centers the data, using only the data that are avaiable to the model at training time. For all variables in the SDM features (regardless of whether they are used), this transformer will store the observed mean and standard deviation.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/univariate.jl#L22-L29" target="_blank" rel="noreferrer">source</a></p>',3))]),e[20]||(e[20]=s("h2",{id:"Transformers-(multivariate)",tabindex:"-1"},[a("Transformers (multivariate) "),s("a",{class:"header-anchor",href:"#Transformers-(multivariate)","aria-label":'Permalink to "Transformers (multivariate) {#Transformers-(multivariate)}"'},"​")],-1)),s("details",u,[s("summary",null,[e[6]||(e[6]=s("a",{id:"SDeMo.MultivariateTransform",href:"#SDeMo.MultivariateTransform"},[s("span",{class:"jlbinding"},"SDeMo.MultivariateTransform")],-1)),e[7]||(e[7]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[8]||(e[8]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">MultivariateTransform{T} </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Transformer</span></span></code></pre></div><p><code>T</code> is a multivariate transformation, likely offered through the <code>MultivariateStats</code> package. The transformations currently supported are <code>PCA</code>, <code>PPCA</code>, <code>KernelPCA</code>, and <code>Whitening</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/transformers/multivariate.jl#L5-L11" target="_blank" rel="noreferrer">source</a></p>',3))]),e[21]||(e[21]=s("h2",{id:"classifiers",tabindex:"-1"},[a("Classifiers "),s("a",{class:"header-anchor",href:"#classifiers","aria-label":'Permalink to "Classifiers"'},"​")],-1)),s("details",f,[s("summary",null,[e[9]||(e[9]=s("a",{id:"SDeMo.NaiveBayes",href:"#SDeMo.NaiveBayes"},[s("span",{class:"jlbinding"},"SDeMo.NaiveBayes")],-1)),e[10]||(e[10]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">NaiveBayes</span></span></code></pre></div><p>Naive Bayes Classifier</p><p>By default, upon training, the prior probability will be set to the prevalence of the training data.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/naivebayes.jl#L1-L8" target="_blank" rel="noreferrer">source</a></p>',4))]),s("details",h,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.BIOCLIM",href:"#SDeMo.BIOCLIM"},[s("span",{class:"jlbinding"},"SDeMo.BIOCLIM")],-1)),e[13]||(e[13]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[14]||(e[14]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">BIOCLIM</span></span></code></pre></div><p>BIOCLIM</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/bioclim.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",m,[s("summary",null,[e[15]||(e[15]=s("a",{id:"SDeMo.DecisionTree",href:"#SDeMo.DecisionTree"},[s("span",{class:"jlbinding"},"SDeMo.DecisionTree")],-1)),e[16]||(e[16]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[17]||(e[17]=r('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">DecisionTree</span></span></code></pre></div><p>The depth and number of nodes can be adjusted with <code>maxnodes!</code> and <code>maxdepth!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5abe9a6b037d9cfc47f7bf9ee9f8b436606739cd/SDeMo/src/classifiers/decisiontree.jl#L76-L80" target="_blank" rel="noreferrer">source</a></p>',3))])])}const M=o(p,[["render",g]]);export{S as __pageData,M as default};