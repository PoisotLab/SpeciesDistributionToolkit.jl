import{_ as l,c as o,j as s,a as i,G as t,a2 as n,B as r,o as p}from"./chunks/framework.D9BeJ9z8.js";const v=JSON.parse('{"title":"Ensembles","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/ensembles.md","filePath":"reference/sdemo/ensembles.md","lastUpdated":null}'),d={name:"reference/sdemo/ensembles.md"},h={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function u(m,e,f,y,D,A){const a=r("Badge");return p(),o("div",null,[e[15]||(e[15]=s("h1",{id:"ensembles",tabindex:"-1"},[i("Ensembles "),s("a",{class:"header-anchor",href:"#ensembles","aria-label":'Permalink to "Ensembles"'},"​")],-1)),e[16]||(e[16]=s("h2",{id:"bagging",tabindex:"-1"},[i("Bagging "),s("a",{class:"header-anchor",href:"#bagging","aria-label":'Permalink to "Bagging"'},"​")],-1)),s("details",h,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.Bagging",href:"#SDeMo.Bagging"},[s("span",{class:"jlbinding"},"SDeMo.Bagging")],-1)),e[1]||(e[1]=i()),t(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Bagging</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/bagging.jl#L22-L24" target="_blank" rel="noreferrer">source</a></p>',2))]),s("details",g,[s("summary",null,[e[3]||(e[3]=s("a",{id:"SDeMo.outofbag",href:"#SDeMo.outofbag"},[s("span",{class:"jlbinding"},"SDeMo.outofbag")],-1)),e[4]||(e[4]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">outofbag</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ensemble</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bagging</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This method returns the confusion matrix associated to the out of bag error, wherein the succes in predicting instance <em>i</em> is calculated on the basis of all models that have not been trained on <em>i</em>. The consensus of the different models is a simple majority rule.</p><p>The additional keywords arguments are passed to <code>predict</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/bagging.jl#L50-L59" target="_blank" rel="noreferrer">source</a></p>',4))]),s("details",k,[s("summary",null,[e[6]||(e[6]=s("a",{id:"SDeMo.bootstrap",href:"#SDeMo.bootstrap"},[s("span",{class:"jlbinding"},"SDeMo.bootstrap")],-1)),e[7]||(e[7]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[8]||(e[8]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">bootstrap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(y, X; n </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 50</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/bagging.jl#L1-L3" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">bootstrap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/bagging.jl#L15-L17" target="_blank" rel="noreferrer">source</a></p>',4))]),s("details",b,[s("summary",null,[e[9]||(e[9]=s("a",{id:"SDeMo.iqr",href:"#SDeMo.iqr"},[s("span",{class:"jlbinding"},"SDeMo.iqr")],-1)),e[10]||(e[10]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[11]||(e[11]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">iqr</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(x, m</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.25</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, M</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.75</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the inter-quantile range, by default between 25% and 75% of observations.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/utilities/varia.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))]),e[17]||(e[17]=s("h2",{id:"Heterogeneous-ensembles",tabindex:"-1"},[i("Heterogeneous ensembles "),s("a",{class:"header-anchor",href:"#Heterogeneous-ensembles","aria-label":'Permalink to "Heterogeneous ensembles {#Heterogeneous-ensembles}"'},"​")],-1)),s("details",c,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.Ensemble",href:"#SDeMo.Ensemble"},[s("span",{class:"jlbinding"},"SDeMo.Ensemble")],-1)),e[13]||(e[13]=i()),t(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[14]||(e[14]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Ensemble</span></span></code></pre></div><p>An heterogeneous ensemble model is defined as a vector of <code>SDM</code>s.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/ensembles/ensemble.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))])])}const C=l(d,[["render",u]]);export{v as __pageData,C as default};