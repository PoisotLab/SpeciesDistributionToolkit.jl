import{_ as n,C as r,c as d,o as p,j as e,a as t,ag as l,G as a,w as o}from"./chunks/framework.DfgxSEAC.js";const v=JSON.parse('{"title":"Saving models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/saving.md","filePath":"reference/sdemo/saving.md","lastUpdated":null}'),k={name:"reference/sdemo/saving.md"},h={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function g(m,s,u,f,A,b){const i=r("Badge");return p(),d("div",null,[s[8]||(s[8]=e("h1",{id:"Saving-models",tabindex:"-1"},[t("Saving models "),e("a",{class:"header-anchor",href:"#Saving-models","aria-label":'Permalink to "Saving models {#Saving-models}"'},"​")],-1)),e("details",h,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.loadsdm",href:"#SDeMo.loadsdm"},[e("span",{class:"jlbinding"},"SDeMo.loadsdm")],-1)),s[1]||(s[1]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[3]||(s[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">loadsdm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(file</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Loads a model to a <code>JSON</code> file. The keyword arguments are passed to <code>train!</code>. The model is trained in full upon loading.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SDeMo/src/utilities/io.jl#L52-L57",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",c,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SDeMo.writesdm",href:"#SDeMo.writesdm"},[e("span",{class:"jlbinding"},"SDeMo.writesdm")],-1)),s[5]||(s[5]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[7]||(s[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">writesdm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(file</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Writes a model to a <code>JSON</code> file. This method is very bare-bones, and only saves the <em>structure</em> of the model, as well as the data.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SDeMo/src/utilities/io.jl#L40-L45",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const S=n(k,[["render",g]]);export{v as __pageData,S as default};
