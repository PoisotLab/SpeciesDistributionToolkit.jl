import{_ as l,c as r,j as s,a,G as i,a2 as n,B as h,o as p}from"./chunks/framework.Cg-3chSZ.js";const D=JSON.parse('{"title":"What happens when the user requests a dataset?","description":"","frontmatter":{},"headers":[],"relativePath":"internals.md","filePath":"internals.md","lastUpdated":null}'),o={name:"internals.md"},d={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""};function c(u,e,g,b,m,y){const t=h("Badge");return p(),r("div",null,[e[6]||(e[6]=s("h1",{id:"What-happens-when-the-user-requests-a-dataset?",tabindex:"-1"},[a("What happens when the user requests a dataset? "),s("a",{class:"header-anchor",href:"#What-happens-when-the-user-requests-a-dataset?","aria-label":'Permalink to "What happens when the user requests a dataset? {#What-happens-when-the-user-requests-a-dataset?}"'},"​")],-1)),e[7]||(e[7]=s("h2",{id:"The-downloader",tabindex:"-1"},[a("The downloader "),s("a",{class:"header-anchor",href:"#The-downloader","aria-label":'Permalink to "The downloader {#The-downloader}"'},"​")],-1)),s("details",d,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SimpleSDMDatasets.downloader",href:"#SimpleSDMDatasets.downloader"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.downloader")],-1)),e[1]||(e[1]=a()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">SimpleSDMDatasets</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">downloader</span></span></code></pre></div><p>...</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/downloader.jl#L10-L14" target="_blank" rel="noreferrer">source</a></p>',3))]),e[8]||(e[8]=s("h2",{id:"The-keychecker",tabindex:"-1"},[a("The keychecker "),s("a",{class:"header-anchor",href:"#The-keychecker","aria-label":'Permalink to "The keychecker {#The-keychecker}"'},"​")],-1)),s("details",k,[s("summary",null,[e[3]||(e[3]=s("a",{id:"SimpleSDMDatasets.keychecker",href:"#SimpleSDMDatasets.keychecker"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.keychecker")],-1)),e[4]||(e[4]=a()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">SimpleSDMDatasets</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">keychecker</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(data</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">R</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; kwargs</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {R </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> RasterData</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>Checks that the keyword arguments passed to a downloader are correct, <em>i.e.</em> the data provider / source being retrieved supports them.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/keychecker.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))])])}const S=l(o,[["render",c]]);export{D as __pageData,S as default};
