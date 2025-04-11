import{_ as r,C as o,c as u,o as d,j as a,a as t,ag as l,G as n,w as i}from"./chunks/framework.DOx8QQ6_.js";const y=JSON.parse('{"title":"Enumerated values","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/enumerated.md","filePath":"reference/gbif/enumerated.md","lastUpdated":null}'),p={name:"reference/gbif/enumerated.md"},c={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""};function h(b,e,f,k,g,v){const s=o("Badge");return d(),u("div",null,[e[8]||(e[8]=a("h1",{id:"Enumerated-values",tabindex:"-1"},[t("Enumerated values "),a("a",{class:"header-anchor",href:"#Enumerated-values","aria-label":'Permalink to "Enumerated values {#Enumerated-values}"'},"​")],-1)),e[9]||(e[9]=a("p",null,'The GBIF API has a number of controlled vocabularies to perform queries (also called "enumerations"). In order to keep the API and the package in sync, when the package is loaded, we query the API to see what values are enumerable, and what values are acceptable for each of these categories.',-1)),a("details",c,[a("summary",null,[e[0]||(e[0]=a("a",{id:"GBIF.enumerablevalues",href:"#GBIF.enumerablevalues"},[a("span",{class:"jlbinding"},"GBIF.enumerablevalues")],-1)),e[1]||(e[1]=t()),n(s,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[3]||(e[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">enumerablevalues</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">()</span></span></code></pre></div><p>Returns an <em>array</em> of values that can be enumerated by the GBIF API.</p>',2)),n(s,{type:"info",class:"source-link",text:"source"},{default:i(()=>e[2]||(e[2]=[a("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/GBIF/src/GBIF.jl#L22-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),a("details",m,[a("summary",null,[e[4]||(e[4]=a("a",{id:"GBIF.enumeratedvalues",href:"#GBIF.enumeratedvalues"},[a("span",{class:"jlbinding"},"GBIF.enumeratedvalues")],-1)),e[5]||(e[5]=t()),n(s,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[7]||(e[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">enumeratedvalues</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(enumerable</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>For a given enumerable value (given as a string as reported by the output of the <code>enumerablevalues</code> function), this function will return an array of possible values.</p>',2)),n(s,{type:"info",class:"source-link",text:"source"},{default:i(()=>e[6]||(e[6]=[a("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/GBIF/src/GBIF.jl#L36-L40",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[10]||(e[10]=a("p",null,[t("These functions are "),a("em",null,"not"),t(" exported, and are only called once per session to populate a dictionary with the accepted values. Note that at the moment, the only enumerated values that we store are the one accepted as search argument by the occurrence search endpoint.")],-1))])}const B=r(p,[["render",h]]);export{y as __pageData,B as default};
