import{_ as i,c as r,j as a,a as s,G as n,a2 as l,B as o,o as u}from"./chunks/framework.BZ4NNby6.js";const y=JSON.parse('{"title":"Enumerated values","description":"","frontmatter":{},"headers":[],"relativePath":"enums.md","filePath":"enums.md","lastUpdated":null}'),d={name:"enums.md"},p={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function h(m,e,b,k,g,v){const t=o("Badge");return u(),r("div",null,[e[6]||(e[6]=a("h1",{id:"Enumerated-values",tabindex:"-1"},[s("Enumerated values "),a("a",{class:"header-anchor",href:"#Enumerated-values","aria-label":'Permalink to "Enumerated values {#Enumerated-values}"'},"​")],-1)),e[7]||(e[7]=a("p",null,'The GBIF API has a number of controlled vocabularies to perform queries (also called "enumerations"). In order to keep the API and the package in sync, when the package is loaded, we query the API to see what values are enumerable, and what values are acceptable for each of these categories.',-1)),a("details",p,[a("summary",null,[e[0]||(e[0]=a("a",{id:"GBIF.enumerablevalues",href:"#GBIF.enumerablevalues"},[a("span",{class:"jlbinding"},"GBIF.enumerablevalues")],-1)),e[1]||(e[1]=s()),n(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">enumerablevalues</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>Returns an <em>array</em> of values that can be enumerated by the GBIF API.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/GBIF.jl#L22-L26" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",c,[a("summary",null,[e[3]||(e[3]=a("a",{id:"GBIF.enumeratedvalues",href:"#GBIF.enumeratedvalues"},[a("span",{class:"jlbinding"},"GBIF.enumeratedvalues")],-1)),e[4]||(e[4]=s()),n(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">enumeratedvalues</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(enumerable</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>For a given enumerable value (given as a string as reported by the output of the <code>enumerablevalues</code> function), this function will return an array of possible values.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/GBIF.jl#L36-L40" target="_blank" rel="noreferrer">source</a></p>',3))]),e[8]||(e[8]=a("p",null,[s("These functions are "),a("em",null,"not"),s(" exported, and are only called once per session to populate a dictionary with the accepted values. Note that at the moment, the only enumerated values that we store are the one accepted as search argument by the occurrence search endpoint.")],-1))])}const F=i(d,[["render",h]]);export{y as __pageData,F as default};