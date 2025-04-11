import{_ as l,C as i,c as o,o as u,j as a,a as t,ag as n,G as r}from"./chunks/framework.CVdKYWal.js";const y=JSON.parse('{"title":"Enumerated values","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/enumerated.md","filePath":"reference/gbif/enumerated.md","lastUpdated":null}'),d={name:"reference/gbif/enumerated.md"},p={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function h(m,e,b,v,f,k){const s=i("Badge");return u(),o("div",null,[e[6]||(e[6]=a("h1",{id:"Enumerated-values",tabindex:"-1"},[t("Enumerated values "),a("a",{class:"header-anchor",href:"#Enumerated-values","aria-label":'Permalink to "Enumerated values {#Enumerated-values}"'},"​")],-1)),e[7]||(e[7]=a("p",null,'The GBIF API has a number of controlled vocabularies to perform queries (also called "enumerations"). In order to keep the API and the package in sync, when the package is loaded, we query the API to see what values are enumerable, and what values are acceptable for each of these categories.',-1)),a("details",p,[a("summary",null,[e[0]||(e[0]=a("a",{id:"GBIF.enumerablevalues",href:"#GBIF.enumerablevalues"},[a("span",{class:"jlbinding"},"GBIF.enumerablevalues")],-1)),e[1]||(e[1]=t()),r(s,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">enumerablevalues</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()</span></span></code></pre></div><p>Returns an <em>array</em> of values that can be enumerated by the GBIF API.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/74ab5783325ab66a34ea5e278adf6f1d44b9d378/GBIF/src/GBIF.jl#L22-L26" target="_blank" rel="noreferrer">source</a></p>',3))]),a("details",c,[a("summary",null,[e[3]||(e[3]=a("a",{id:"GBIF.enumeratedvalues",href:"#GBIF.enumeratedvalues"},[a("span",{class:"jlbinding"},"GBIF.enumeratedvalues")],-1)),e[4]||(e[4]=t()),r(s,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">enumeratedvalues</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(enumerable</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>For a given enumerable value (given as a string as reported by the output of the <code>enumerablevalues</code> function), this function will return an array of possible values.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/74ab5783325ab66a34ea5e278adf6f1d44b9d378/GBIF/src/GBIF.jl#L36-L40" target="_blank" rel="noreferrer">source</a></p>',3))]),e[8]||(e[8]=a("p",null,[t("These functions are "),a("em",null,"not"),t(" exported, and are only called once per session to populate a dictionary with the accepted values. Note that at the moment, the only enumerated values that we store are the one accepted as search argument by the occurrence search endpoint.")],-1))])}const _=l(d,[["render",h]]);export{y as __pageData,_ as default};
