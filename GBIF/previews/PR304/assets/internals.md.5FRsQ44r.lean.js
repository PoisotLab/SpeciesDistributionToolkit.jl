import{_ as i,c as r,j as s,a as t,G as o,a2 as n,B as l,o as p}from"./chunks/framework.BZ4NNby6.js";const j=JSON.parse('{"title":"Internals","description":"","frontmatter":{},"headers":[],"relativePath":"internals.md","filePath":"internals.md","lastUpdated":null}'),c={name:"internals.md"},d={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""};function b(g,e,f,m,k,y){const a=l("Badge");return p(),r("div",null,[e[10]||(e[10]=s("h1",{id:"internals",tabindex:"-1"},[t("Internals "),s("a",{class:"header-anchor",href:"#internals","aria-label":'Permalink to "Internals"'},"​")],-1)),s("details",d,[s("summary",null,[e[0]||(e[0]=s("a",{id:"GBIF.format_date",href:"#GBIF.format_date"},[s("span",{class:"jlbinding"},"GBIF.format_date")],-1)),e[1]||(e[1]=t()),o(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=s("p",null,[s("strong",null,"Internal function to format dates in records")],-1)),e[3]||(e[3]=s("p",null,[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/types/GBIFRecords.jl#L43-L45",target:"_blank",rel:"noreferrer"},"source")],-1))]),s("details",u,[s("summary",null,[e[4]||(e[4]=s("a",{id:"GBIF.validate_occurrence_query",href:"#GBIF.validate_occurrence_query"},[s("span",{class:"jlbinding"},"GBIF.validate_occurrence_query")],-1)),e[5]||(e[5]=t()),o(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[6]||(e[6]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">validate_occurrence_query</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(query</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Pair</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Checks that the queries for occurrences searches are well formatted.</p><p>This is used internally.</p><p>Everything this function does is derived from the GBIF API documentation, including (and especially) the values for enum types. This modifies the queryset. Filters that are not allowed are removed, and filters that have incorrect values are dropped too.</p><p>This feels like the most conservative option – the user can always filter the results when they are returned.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/query.jl#L1-L15" target="_blank" rel="noreferrer">source</a></p>',6))]),s("details",h,[s("summary",null,[e[7]||(e[7]=s("a",{id:"Base.show",href:"#Base.show"},[s("span",{class:"jlbinding"},"Base.show")],-1)),e[8]||(e[8]=t()),o(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[9]||(e[9]=n('<p><strong>Show an occurrence</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, o::GBIFRecord)</span></span></code></pre></div><p>Displays the key, the taxon name, and the country of observation.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/types/show.jl#L6-L12" target="_blank" rel="noreferrer">source</a></p><p><strong>Show several occurrences</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, o::GBIFRecords)</span></span></code></pre></div><p>Displays the total number, and the number of currently unmasked records.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/types/show.jl#L17-L23" target="_blank" rel="noreferrer">source</a></p><p><strong>Show a taxonomic record</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, t::GBIFTaxon)</span></span></code></pre></div><p>Displays the taxon name.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/GBIF/src/types/show.jl#L28-L34" target="_blank" rel="noreferrer">source</a></p>',12))])])}const F=i(c,[["render",b]]);export{j as __pageData,F as default};
