import{_ as o,C as d,c as r,o as p,j as e,a as t,ag as l,G as a,w as n}from"./chunks/framework.DKTAB-CG.js";const S=JSON.parse('{"title":"Saving models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/saving.md","filePath":"reference/sdemo/saving.md","lastUpdated":null}'),k={name:"reference/sdemo/saving.md"},h={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function m(g,s,u,F,b,f){const i=d("Badge");return p(),r("div",null,[s[8]||(s[8]=e("h1",{id:"Saving-models",tabindex:"-1"},[t("Saving models "),e("a",{class:"header-anchor",href:"#Saving-models","aria-label":'Permalink to "Saving models {#Saving-models}"'},"​")],-1)),e("details",h,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.loadsdm",href:"#SDeMo.loadsdm"},[e("span",{class:"jlbinding"},"SDeMo.loadsdm")],-1)),s[1]||(s[1]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[3]||(s[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">loadsdm</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(file</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Loads a model to a <code>JSON</code> file. The keyword arguments are passed to <code>train!</code>. The model is trained in full upon loading.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/utilities/io.jl#L52-L57",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",c,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SDeMo.writesdm",href:"#SDeMo.writesdm"},[e("span",{class:"jlbinding"},"SDeMo.writesdm")],-1)),s[5]||(s[5]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[7]||(s[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">writesdm</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(file</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> model</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Writes a model to a <code>JSON</code> file. This method is very bare-bones, and only saves the <em>structure</em> of the model, as well as the data.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/5f331dede5bb42b89697a6cd3c576c08e4e008f4/SDeMo/src/utilities/io.jl#L40-L45",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const B=o(k,[["render",m]]);export{S as __pageData,B as default};
