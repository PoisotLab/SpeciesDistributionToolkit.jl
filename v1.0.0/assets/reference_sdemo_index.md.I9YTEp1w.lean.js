import{_ as n,c as o,j as s,a as i,G as a,a2 as l,B as r,o as p}from"./chunks/framework.D9BeJ9z8.js";const E=JSON.parse('{"title":"Tools for SDM demos and education","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/index.md","filePath":"reference/sdemo/index.md","lastUpdated":null}'),d={name:"reference/sdemo/index.md"},h={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""};function M(T,e,F,L,B,x){const t=r("Badge");return p(),o("div",null,[e[45]||(e[45]=s("h1",{id:"Tools-for-SDM-demos-and-education",tabindex:"-1"},[i("Tools for SDM demos and education "),s("a",{class:"header-anchor",href:"#Tools-for-SDM-demos-and-education","aria-label":'Permalink to "Tools for SDM demos and education {#Tools-for-SDM-demos-and-education}"'},"​")],-1)),e[46]||(e[46]=s("h2",{id:"The-prediction-pipeline",tabindex:"-1"},[i("The prediction pipeline "),s("a",{class:"header-anchor",href:"#The-prediction-pipeline","aria-label":'Permalink to "The prediction pipeline {#The-prediction-pipeline}"'},"​")],-1)),s("details",h,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.AbstractSDM",href:"#SDeMo.AbstractSDM"},[s("span",{class:"jlbinding"},"SDeMo.AbstractSDM")],-1)),e[1]||(e[1]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AbstractSDM</span></span></code></pre></div><p>This abstract type covers both the regular and the ensemble models.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",c,[s("summary",null,[e[3]||(e[3]=s("a",{id:"SDeMo.AbstractEnsembleSDM",href:"#SDeMo.AbstractEnsembleSDM"},[s("span",{class:"jlbinding"},"SDeMo.AbstractEnsembleSDM")],-1)),e[4]||(e[4]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[5]||(e[5]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AbstractEnsembleSDM</span></span></code></pre></div><p>This abstract types covers model that combine different SDMs to make a prediction, which currently covers <code>Bagging</code> and <code>Ensemble</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L8-L12" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",k,[s("summary",null,[e[6]||(e[6]=s("a",{id:"SDeMo.SDM",href:"#SDeMo.SDM"},[s("span",{class:"jlbinding"},"SDeMo.SDM")],-1)),e[7]||(e[7]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[8]||(e[8]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SDM</span></span></code></pre></div><p>This type specifies a <em>full</em> model, which is composed of a transformer (which applies a transformation on the data), a classifier (which returns a quantitative score), a threshold (above which the score corresponds to the prediction of a presence).</p><p>In addition, the SDM carries with it the training features and labels, as well as a vector of indices indicating which variables are actually used by the model.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L29-L40" target="_blank" rel="noreferrer">source</a></p>',4))]),s("details",u,[s("summary",null,[e[9]||(e[9]=s("a",{id:"SDeMo.Transformer",href:"#SDeMo.Transformer"},[s("span",{class:"jlbinding"},"SDeMo.Transformer")],-1)),e[10]||(e[10]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Transformer</span></span></code></pre></div><p>This abstract type covers all transformations that are applied to the data before fitting the classifier.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L15-L19" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",b,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.Classifier",href:"#SDeMo.Classifier"},[s("span",{class:"jlbinding"},"SDeMo.Classifier")],-1)),e[13]||(e[13]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[14]||(e[14]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Classifier</span></span></code></pre></div><p>This abstract type covers all algorithms to convert transformed data into prediction.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L22-L26" target="_blank" rel="noreferrer">source</a></p>',3))]),e[47]||(e[47]=s("h3",{id:"Utility-functions",tabindex:"-1"},[i("Utility functions "),s("a",{class:"header-anchor",href:"#Utility-functions","aria-label":'Permalink to "Utility functions {#Utility-functions}"'},"​")],-1)),s("details",f,[s("summary",null,[e[15]||(e[15]=s("a",{id:"SDeMo.features",href:"#SDeMo.features"},[s("span",{class:"jlbinding"},"SDeMo.features")],-1)),e[16]||(e[16]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[17]||(e[17]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">features</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the features stored in the field <code>X</code> of the SDM. Note that the features are an array, and this does not return a copy of it – any change made to the output of this function <em>will</em> change the content of the SDM features.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L81-L87" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">features</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, n)</span></span></code></pre></div><p>Returns the <em>n</em>-th feature stored in the field <code>X</code> of the SDM.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L90-L94" target="_blank" rel="noreferrer">source</a></p>',6))]),s("details",g,[s("summary",null,[e[18]||(e[18]=s("a",{id:"SDeMo.labels",href:"#SDeMo.labels"},[s("span",{class:"jlbinding"},"SDeMo.labels")],-1)),e[19]||(e[19]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[20]||(e[20]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">labels</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the labels stored in the field <code>y</code> of the SDM – note that this is not a copy of the labels, but the object itself.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L110-L115" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",m,[s("summary",null,[e[21]||(e[21]=s("a",{id:"SDeMo.threshold",href:"#SDeMo.threshold"},[s("span",{class:"jlbinding"},"SDeMo.threshold")],-1)),e[22]||(e[22]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[23]||(e[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">threshold</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This returns the value above which the score returned by the SDM is considered to be a presence.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L66-L71" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",y,[s("summary",null,[e[24]||(e[24]=s("a",{id:"SDeMo.threshold!",href:"#SDeMo.threshold!"},[s("span",{class:"jlbinding"},"SDeMo.threshold!")],-1)),e[25]||(e[25]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[26]||(e[26]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">threshold!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, τ)</span></span></code></pre></div><p>Sets the value of the threshold.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L74-L78" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",D,[s("summary",null,[e[27]||(e[27]=s("a",{id:"SDeMo.variables",href:"#SDeMo.variables"},[s("span",{class:"jlbinding"},"SDeMo.variables")],-1)),e[28]||(e[28]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[29]||(e[29]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">variables</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the list of variables used by the SDM – these <em>may</em> be ordered by importance. This does not return a copy of the variables array, but the array itself.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L118-L124" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",v,[s("summary",null,[e[30]||(e[30]=s("a",{id:"SDeMo.variables!",href:"#SDeMo.variables!"},[s("span",{class:"jlbinding"},"SDeMo.variables!")],-1)),e[31]||(e[31]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[32]||(e[32]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">variables!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, v)</span></span></code></pre></div><p>Sets the list of variables.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L127-L131" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",A,[s("summary",null,[e[33]||(e[33]=s("a",{id:"SDeMo.instance",href:"#SDeMo.instance"},[s("span",{class:"jlbinding"},"SDeMo.instance")],-1)),e[34]||(e[34]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[35]||(e[35]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">instance</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, n; strict</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the <em>n</em>-th instance stored in the field <code>X</code> of the SDM. If the keyword argument <code>strict</code> is <code>true</code>, only the variables used for prediction are returned.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/models.jl#L97-L101" target="_blank" rel="noreferrer">source</a></p>',3))]),e[48]||(e[48]=s("h3",{id:"Training-and-predicting",tabindex:"-1"},[i("Training and predicting "),s("a",{class:"header-anchor",href:"#Training-and-predicting","aria-label":'Permalink to "Training and predicting {#Training-and-predicting}"'},"​")],-1)),s("details",j,[s("summary",null,[e[36]||(e[36]=s("a",{id:"SDeMo.train!",href:"#SDeMo.train!"},[s("span",{class:"jlbinding"},"SDeMo.train!")],-1)),e[37]||(e[37]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[38]||(e[38]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">train!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ensemble</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bagging</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Trains all the model in an ensemble model - the keyword arguments are passed to <code>train!</code> for each model. Note that this retrains the <em>entire</em> model, which includes the transformers.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/pipeline.jl#L12-L18" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">train!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ensemble</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Ensemble</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Trains all the model in an heterogeneous ensemble model - the keyword arguments are passed to <code>train!</code> for each model. Note that this retrains the <em>entire</em> model, which includes the transformers.</p><p>The keywod arguments are passed to <code>train!</code> and can include the <code>training</code> indices.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/pipeline.jl#L60-L69" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">train!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; threshold</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, training</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:, optimality</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">mcc)</span></span></code></pre></div><p>This is the main training function to train a SDM.</p><p>The three keyword arguments are:</p><ul><li><p><code>training</code>: defaults to <code>:</code>, and is the range (or alternatively the indices) of the data that are used to train the model</p></li><li><p><code>threshold</code>: defaults to <code>true</code>, and performs moving threshold by evaluating 200 possible values between the minimum and maximum output of the model, and returning the one that is optimal</p></li><li><p><code>optimality</code>: defaults to <code>mcc</code>, and is the function applied to the confusion matrix to evaluate which value of the threshold is the best</p></li><li><p><code>absences</code>: defaults to <code>false</code>, and indicates whether the (pseudo) absences are used to train the transformer; when using actual absences, this should be set to <code>true</code></p></li></ul><p>Internally, this function trains the transformer, then projects the data, then trains the classifier. If <code>threshold</code> is <code>true</code>, the threshold is then optimized.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/pipeline.jl#L1-L20" target="_blank" rel="noreferrer">source</a></p>',13))]),s("details",C,[s("summary",null,[e[39]||(e[39]=s("a",{id:"StatsAPI.predict",href:"#StatsAPI.predict"},[s("span",{class:"jlbinding"},"StatsAPI.predict")],-1)),e[40]||(e[40]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[41]||(e[41]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">predict</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">RegressionModel</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, [newX])</span></span></code></pre></div><p>Form the predicted response of <code>model</code>. An object with new covariate values <code>newX</code> can be supplied, which should have the same type and structure as that used to fit <code>model</code>; e.g. for a GLM it would generally be a <code>DataFrame</code> with the same variable names as the original predictors.</p><p><a href="https://github.com/JuliaStats/StatsAPI.jl/blob/v1.7.0/src/regressionmodel.jl#L74-L80" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",S,[s("summary",null,[e[42]||(e[42]=s("a",{id:"SDeMo.reset!",href:"#SDeMo.reset!"},[s("span",{class:"jlbinding"},"SDeMo.reset!")],-1)),e[43]||(e[43]=i()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[44]||(e[44]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">reset!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, thr</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Resets a model, with a potentially specified value of the threshold. This amounts to re-using all the variables, and removing the tuned threshold version.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/pipeline.jl#L86-L91" target="_blank" rel="noreferrer">source</a></p>',3))])])}const P=n(d,[["render",M]]);export{E as __pageData,P as default};