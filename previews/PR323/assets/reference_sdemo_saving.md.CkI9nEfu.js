import{_ as o,c as n,j as e,a as i,G as t,a2 as l,B as d,o as r}from"./chunks/framework.BBYNtJYl.js";const y=JSON.parse('{"title":"Saving models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/saving.md","filePath":"reference/sdemo/saving.md","lastUpdated":null}'),p={name:"reference/sdemo/saving.md"},h={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""};function c(m,s,g,u,f,b){const a=d("Badge");return r(),n("div",null,[s[6]||(s[6]=e("h1",{id:"Saving-models",tabindex:"-1"},[i("Saving models "),e("a",{class:"header-anchor",href:"#Saving-models","aria-label":'Permalink to "Saving models {#Saving-models}"'},"​")],-1)),e("details",h,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.loadsdm",href:"#SDeMo.loadsdm"},[e("span",{class:"jlbinding"},"SDeMo.loadsdm")],-1)),s[1]||(s[1]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">loadsdm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(file</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Loads a model to a <code>JSON</code> file. The keyword arguments are passed to <code>train!</code>. The model is trained in full upon loading.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/SDeMo/src/utilities/io.jl#L50-L55" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",k,[e("summary",null,[s[3]||(s[3]=e("a",{id:"SDeMo.writesdm",href:"#SDeMo.writesdm"},[e("span",{class:"jlbinding"},"SDeMo.writesdm")],-1)),s[4]||(s[4]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">writesdm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(file</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Writes a model to a <code>JSON</code> file. This method is very bare-bones, and only saves the <em>structure</em> of the model, as well as the data.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/SDeMo/src/utilities/io.jl#L38-L43" target="_blank" rel="noreferrer">source</a></p>',3))])])}const A=o(p,[["render",c]]);export{y as __pageData,A as default};
