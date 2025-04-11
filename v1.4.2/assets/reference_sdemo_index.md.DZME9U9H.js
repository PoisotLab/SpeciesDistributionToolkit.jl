import{_ as o,C as r,c as d,o as p,j as e,a,ag as l,G as t,w as n}from"./chunks/framework.DKTAB-CG.js";const L=JSON.parse('{"title":"Tools for SDM demos and education","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/index.md","filePath":"reference/sdemo/index.md","lastUpdated":null}'),h={name:"reference/sdemo/index.md"},k={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},B={class:"jldocstring custom-block",open:""};function v(M,s,C,A,x,E){const i=r("Badge");return p(),d("div",null,[s[66]||(s[66]=e("h1",{id:"Tools-for-SDM-demos-and-education",tabindex:"-1"},[a("Tools for SDM demos and education "),e("a",{class:"header-anchor",href:"#Tools-for-SDM-demos-and-education","aria-label":'Permalink to "Tools for SDM demos and education {#Tools-for-SDM-demos-and-education}"'},"​")],-1)),s[67]||(s[67]=e("h2",{id:"The-prediction-pipeline",tabindex:"-1"},[a("The prediction pipeline "),e("a",{class:"header-anchor",href:"#The-prediction-pipeline","aria-label":'Permalink to "The prediction pipeline {#The-prediction-pipeline}"'},"​")],-1)),e("details",k,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.AbstractSDM",href:"#SDeMo.AbstractSDM"},[e("span",{class:"jlbinding"},"SDeMo.AbstractSDM")],-1)),s[1]||(s[1]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[3]||(s[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AbstractSDM</span></span></code></pre></div><p>This abstract type covers both the regular and the ensemble models.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",c,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SDeMo.AbstractEnsembleSDM",href:"#SDeMo.AbstractEnsembleSDM"},[e("span",{class:"jlbinding"},"SDeMo.AbstractEnsembleSDM")],-1)),s[5]||(s[5]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[7]||(s[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AbstractEnsembleSDM</span></span></code></pre></div><p>This abstract types covers model that combine different SDMs to make a prediction, which currently covers <code>Bagging</code> and <code>Ensemble</code>.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L8-L12",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",u,[e("summary",null,[s[8]||(s[8]=e("a",{id:"SDeMo.SDM",href:"#SDeMo.SDM"},[e("span",{class:"jlbinding"},"SDeMo.SDM")],-1)),s[9]||(s[9]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[11]||(s[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">SDM</span></span></code></pre></div><p>This type specifies a <em>full</em> model, which is composed of a transformer (which applies a transformation on the data), a classifier (which returns a quantitative score), a threshold (above which the score corresponds to the prediction of a presence).</p><p>In addition, the SDM carries with it the training features and labels, as well as a vector of indices indicating which variables are actually used by the model.</p>',3)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[10]||(s[10]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L29-L40",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",b,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SDeMo.Transformer",href:"#SDeMo.Transformer"},[e("span",{class:"jlbinding"},"SDeMo.Transformer")],-1)),s[13]||(s[13]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[15]||(s[15]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Transformer</span></span></code></pre></div><p>This abstract type covers all transformations that are applied to the data before fitting the classifier.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[14]||(s[14]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L15-L19",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",g,[e("summary",null,[s[16]||(s[16]=e("a",{id:"SDeMo.Classifier",href:"#SDeMo.Classifier"},[e("span",{class:"jlbinding"},"SDeMo.Classifier")],-1)),s[17]||(s[17]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[19]||(s[19]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Classifier</span></span></code></pre></div><p>This abstract type covers all algorithms to convert transformed data into prediction.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[18]||(s[18]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L22-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[68]||(s[68]=e("h3",{id:"Utility-functions",tabindex:"-1"},[a("Utility functions "),e("a",{class:"header-anchor",href:"#Utility-functions","aria-label":'Permalink to "Utility functions {#Utility-functions}"'},"​")],-1)),e("details",m,[e("summary",null,[s[20]||(s[20]=e("a",{id:"SDeMo.features",href:"#SDeMo.features"},[e("span",{class:"jlbinding"},"SDeMo.features")],-1)),s[21]||(s[21]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[24]||(s[24]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">features</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the features stored in the field <code>X</code> of the SDM. Note that the features are an array, and this does not return a copy of it – any change made to the output of this function <em>will</em> change the content of the SDM features.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[22]||(s[22]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L81-L87",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[25]||(s[25]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">features</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> n)</span></span></code></pre></div><p>Returns the <em>n</em>-th feature stored in the field <code>X</code> of the SDM.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[23]||(s[23]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L90-L94",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",F,[e("summary",null,[s[26]||(s[26]=e("a",{id:"SDeMo.labels",href:"#SDeMo.labels"},[e("span",{class:"jlbinding"},"SDeMo.labels")],-1)),s[27]||(s[27]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[29]||(s[29]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">labels</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the labels stored in the field <code>y</code> of the SDM – note that this is not a copy of the labels, but the object itself.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[28]||(s[28]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L110-L115",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",y,[e("summary",null,[s[30]||(s[30]=e("a",{id:"SDeMo.threshold",href:"#SDeMo.threshold"},[e("span",{class:"jlbinding"},"SDeMo.threshold")],-1)),s[31]||(s[31]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[33]||(s[33]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">threshold</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>This returns the value above which the score returned by the SDM is considered to be a presence.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[32]||(s[32]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L66-L71",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",f,[e("summary",null,[s[34]||(s[34]=e("a",{id:"SDeMo.threshold!",href:"#SDeMo.threshold!"},[e("span",{class:"jlbinding"},"SDeMo.threshold!")],-1)),s[35]||(s[35]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[37]||(s[37]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">threshold!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> τ)</span></span></code></pre></div><p>Sets the value of the threshold.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[36]||(s[36]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L74-L78",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",T,[e("summary",null,[s[38]||(s[38]=e("a",{id:"SDeMo.variables",href:"#SDeMo.variables"},[e("span",{class:"jlbinding"},"SDeMo.variables")],-1)),s[39]||(s[39]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[41]||(s[41]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">variables</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the list of variables used by the SDM – these <em>may</em> be ordered by importance. This does not return a copy of the variables array, but the array itself.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[40]||(s[40]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L118-L124",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",S,[e("summary",null,[s[42]||(s[42]=e("a",{id:"SDeMo.variables!",href:"#SDeMo.variables!"},[e("span",{class:"jlbinding"},"SDeMo.variables!")],-1)),s[43]||(s[43]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[45]||(s[45]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">variables!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> v)</span></span></code></pre></div><p>Sets the list of variables.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[44]||(s[44]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L127-L131",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",D,[e("summary",null,[s[46]||(s[46]=e("a",{id:"SDeMo.instance",href:"#SDeMo.instance"},[e("span",{class:"jlbinding"},"SDeMo.instance")],-1)),s[47]||(s[47]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[49]||(s[49]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> n</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> strict</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">true</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the <em>n</em>-th instance stored in the field <code>X</code> of the SDM. If the keyword argument <code>strict</code> is <code>true</code>, only the variables used for prediction are returned.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[48]||(s[48]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/models.jl#L97-L101",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[69]||(s[69]=e("h3",{id:"Training-and-predicting",tabindex:"-1"},[a("Training and predicting "),e("a",{class:"header-anchor",href:"#Training-and-predicting","aria-label":'Permalink to "Training and predicting {#Training-and-predicting}"'},"​")],-1)),e("details",_,[e("summary",null,[s[50]||(s[50]=e("a",{id:"SDeMo.train!",href:"#SDeMo.train!"},[e("span",{class:"jlbinding"},"SDeMo.train!")],-1)),s[51]||(s[51]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[55]||(s[55]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">train!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ensemble</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Bagging</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Trains all the model in an ensemble model - the keyword arguments are passed to <code>train!</code> for each model. Note that this retrains the <em>entire</em> model, which includes the transformers.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[52]||(s[52]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/ensembles/pipeline.jl#L12-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[56]||(s[56]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">train!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ensemble</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Ensemble</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Trains all the model in an heterogeneous ensemble model - the keyword arguments are passed to <code>train!</code> for each model. Note that this retrains the <em>entire</em> model, which includes the transformers.</p><p>The keywod arguments are passed to <code>train!</code> and can include the <code>training</code> indices.</p>',3)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[53]||(s[53]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/ensembles/pipeline.jl#L60-L69",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[57]||(s[57]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">train!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> threshold</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">true</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> training</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> optimality</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">mcc)</span></span></code></pre></div><p>This is the main training function to train a SDM.</p><p>The three keyword arguments are:</p><ul><li><p><code>training</code>: defaults to <code>:</code>, and is the range (or alternatively the indices) of the data that are used to train the model</p></li><li><p><code>threshold</code>: defaults to <code>true</code>, and performs moving threshold by evaluating 200 possible values between the minimum and maximum output of the model, and returning the one that is optimal</p></li><li><p><code>optimality</code>: defaults to <code>mcc</code>, and is the function applied to the confusion matrix to evaluate which value of the threshold is the best</p></li><li><p><code>absences</code>: defaults to <code>false</code>, and indicates whether the (pseudo) absences are used to train the transformer; when using actual absences, this should be set to <code>true</code></p></li></ul><p>Internally, this function trains the transformer, then projects the data, then trains the classifier. If <code>threshold</code> is <code>true</code>, the threshold is then optimized.</p>',5)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[54]||(s[54]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/pipeline.jl#L1-L20",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",j,[e("summary",null,[s[58]||(s[58]=e("a",{id:"StatsAPI.predict",href:"#StatsAPI.predict"},[e("span",{class:"jlbinding"},"StatsAPI.predict")],-1)),s[59]||(s[59]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[61]||(s[61]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">predict</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(model</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">RegressionModel</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [newX])</span></span></code></pre></div><p>Form the predicted response of <code>model</code>. An object with new covariate values <code>newX</code> can be supplied, which should have the same type and structure as that used to fit <code>model</code>; e.g. for a GLM it would generally be a <code>DataFrame</code> with the same variable names as the original predictors.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[60]||(s[60]=[e("a",{href:"https://github.com/JuliaStats/StatsAPI.jl/blob/v1.7.0/src/regressionmodel.jl#L74-L80",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",B,[e("summary",null,[s[62]||(s[62]=e("a",{id:"SDeMo.reset!",href:"#SDeMo.reset!"},[e("span",{class:"jlbinding"},"SDeMo.reset!")],-1)),s[63]||(s[63]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[65]||(s[65]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">reset!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(sdm</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> thr</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.5</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Resets a model, with a potentially specified value of the threshold. This amounts to re-using all the variables, and removing the tuned threshold version.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[64]||(s[64]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/pipeline.jl#L89-L94",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const I=o(h,[["render",v]]);export{L as __pageData,I as default};
