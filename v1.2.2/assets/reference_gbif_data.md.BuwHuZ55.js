import{_ as r,C as n,c as l,o as c,j as t,a as s,ag as o,G as a}from"./chunks/framework.RaFiNGy7.js";const C=JSON.parse('{"title":"Retrieving data","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/data.md","filePath":"reference/gbif/data.md","lastUpdated":null}'),d={name:"reference/gbif/data.md"},p={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""};function m(B,e,T,A,v,I){const i=n("Badge");return c(),l("div",null,[e[27]||(e[27]=t("h1",{id:"Retrieving-data",tabindex:"-1"},[s("Retrieving data "),t("a",{class:"header-anchor",href:"#Retrieving-data","aria-label":'Permalink to "Retrieving data {#Retrieving-data}"'},"​")],-1)),e[28]||(e[28]=t("h2",{id:"Getting-taxonomic-information",tabindex:"-1"},[s("Getting taxonomic information "),t("a",{class:"header-anchor",href:"#Getting-taxonomic-information","aria-label":'Permalink to "Getting taxonomic information {#Getting-taxonomic-information}"'},"​")],-1)),t("details",p,[t("summary",null,[e[0]||(e[0]=t("a",{id:"GBIF.taxon",href:"#GBIF.taxon"},[t("span",{class:"jlbinding"},"GBIF.taxon")],-1)),e[1]||(e[1]=s()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=o('<p><strong>Get information about a taxon at any level</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>taxon(name::String)</span></span></code></pre></div><p>This function will look for a taxon by its (scientific) name in the GBIF reference taxonomy.</p><p>Optional arguments are</p><ul><li><p><code>rank::Union{Symbol,Nothing}=:SPECIES</code> – the rank of the taxon you want. This is part of a controlled vocabulary, and can only be one of <code>:DOMAIN</code>, <code>:CLASS</code>, <code>:CULTIVAR</code>, <code>:FAMILY</code>, <code>:FORM</code>, <code>:GENUS</code>, <code>:INFORMAL</code>, <code>:ORDER</code>, <code>:PHYLUM,</code>, <code>:SECTION</code>, <code>:SUBCLASS</code>, <code>:VARIETY</code>, <code>:TRIBE</code>, <code>:KINGDOM</code>, <code>:SUBFAMILY</code>, <code>:SUBFORM</code>, <code>:SUBGENUS</code>, <code>:SUBKINGDOM</code>, <code>:SUBORDER</code>, <code>:SUBPHYLUM</code>, <code>:SUBSECTION</code>, <code>:SUBSPECIES</code>, <code>:SUBTRIBE</code>, <code>:SUBVARIETY</code>, <code>:SUPERCLASS</code>, <code>:SUPERFAMILY</code>, <code>:SUPERORDER</code>, and <code>:SPECIES</code></p></li><li><p><code>strict::Bool=true</code> – whether the match should be strict, or fuzzy</p></li></ul><p>Finally, one can also specify other levels of the taxonomy, using <code>kingdom</code>, <code>phylum</code>, <code>class</code>, <code>order</code>, <code>family</code>, and <code>genus</code>, all of which can either be <code>String</code> or <code>Nothing</code>.</p><p>If a match is found, the result will be given as a <code>GBIFTaxon</code>. If not, this function will return <code>nothing</code> and give a warning.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/taxon.jl#L1-L27" target="_blank" rel="noreferrer">source</a></p><p><strong>Get information about a taxon at any level using taxonID</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>taxon(id::Int)</span></span></code></pre></div><p>This function will look for a taxon by its taxonID in the GBIF reference taxonomy.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/taxon.jl#L72-L79" target="_blank" rel="noreferrer">source</a></p>',12))]),e[29]||(e[29]=t("h2",{id:"Searching-for-occurrence-data",tabindex:"-1"},[s("Searching for occurrence data "),t("a",{class:"header-anchor",href:"#Searching-for-occurrence-data","aria-label":'Permalink to "Searching for occurrence data {#Searching-for-occurrence-data}"'},"​")],-1)),e[30]||(e[30]=t("p",null,[s("The most common task is to retrieve many occurrences according to a query. The core type of this package is "),t("code",null,"GBIFRecord"),s(", which is a very lightweight type containing information about the query, and a list of "),t("code",null,"GBIFRecord"),s(' for every matching occurrence. Note that the GBIF "search" API is limited to 100000 results, and will not return more than this amount.')],-1)),e[31]||(e[31]=t("h3",{id:"Single-occurrence",tabindex:"-1"},[s("Single occurrence "),t("a",{class:"header-anchor",href:"#Single-occurrence","aria-label":'Permalink to "Single occurrence {#Single-occurrence}"'},"​")],-1)),t("details",u,[t("summary",null,[e[3]||(e[3]=t("a",{id:"GBIF.occurrence",href:"#GBIF.occurrence"},[t("span",{class:"jlbinding"},"GBIF.occurrence")],-1)),e[4]||(e[4]=s()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(key</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a GBIF occurrence identified by a key. The key can be given as a string or as an integer (there is a second method for integer keys). In case the status of the HTTP request is anything other than 200 (success), this function <em>will</em> throw an error.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L32-L39" target="_blank" rel="noreferrer">source</a></p>',3))]),e[32]||(e[32]=t("h3",{id:"Multiple-occurrences",tabindex:"-1"},[s("Multiple occurrences "),t("a",{class:"header-anchor",href:"#Multiple-occurrences","aria-label":'Permalink to "Multiple occurrences {#Multiple-occurrences}"'},"​")],-1)),t("details",h,[t("summary",null,[e[6]||(e[6]=t("a",{id:"GBIF.occurrences-Tuple{}",href:"#GBIF.occurrences-Tuple{}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[7]||(e[7]=s()),a(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[8]||(e[8]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This function will return the latest occurrences matching the queries – usually 20, but this is entirely determined by the server default page size. The query parameters must be given as pairs, and are optional. Omitting the query will return the latest recorded occurrences for all taxa.</p><p>The arguments accepted as queries are documented on the <a href="https://www.gbif.org/developer/occurrence" target="_blank" rel="noreferrer">GBIF API</a> website.</p><p><strong>Note that</strong> this function will return even observations where the &quot;occurrenceStatus&quot; is &quot;ABSENT&quot;; therefore, for the majority of uses, your query will <em>at least</em> contain <code>&quot;occurrenceStatus&quot; =&gt; &quot;PRESENT&quot;</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L74-L88" target="_blank" rel="noreferrer">source</a></p>',5))]),t("details",g,[t("summary",null,[e[9]||(e[9]=t("a",{id:"GBIF.occurrences-Tuple{GBIFTaxon}",href:"#GBIF.occurrences-Tuple{GBIFTaxon}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[10]||(e[10]=s()),a(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[11]||(e[11]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(t</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GBIFTaxon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns occurrences for a given taxon – the query arguments are the same as the <code>occurrences</code> function.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L103-L107" target="_blank" rel="noreferrer">source</a></p>',3))]),e[33]||(e[33]=t("p",null,[s("When called with no arguments, this function will return a list of the latest 20 occurrences recorded in GBIF. Note that the "),t("code",null,"GBIFRecords"),s(" type, which is the return type of "),t("code",null,"occurrences"),s(", implements the iteration interface.")],-1)),e[34]||(e[34]=t("h3",{id:"Query-parameters",tabindex:"-1"},[s("Query parameters "),t("a",{class:"header-anchor",href:"#Query-parameters","aria-label":'Permalink to "Query parameters {#Query-parameters}"'},"​")],-1)),e[35]||(e[35]=t("p",null,"The queries must be given as pairs of values.",-1)),t("details",k,[t("summary",null,[e[12]||(e[12]=t("a",{id:"GBIF.occurrences-Tuple{Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[13]||(e[13]=s()),a(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[14]||(e[14]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This function will return the latest occurrences matching the queries – usually 20, but this is entirely determined by the server default page size. The query parameters must be given as pairs, and are optional. Omitting the query will return the latest recorded occurrences for all taxa.</p><p>The arguments accepted as queries are documented on the <a href="https://www.gbif.org/developer/occurrence" target="_blank" rel="noreferrer">GBIF API</a> website.</p><p><strong>Note that</strong> this function will return even observations where the &quot;occurrenceStatus&quot; is &quot;ABSENT&quot;; therefore, for the majority of uses, your query will <em>at least</em> contain <code>&quot;occurrenceStatus&quot; =&gt; &quot;PRESENT&quot;</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L74-L88" target="_blank" rel="noreferrer">source</a></p>',5))]),t("details",f,[t("summary",null,[e[15]||(e[15]=t("a",{id:"GBIF.occurrences-Tuple{GBIFTaxon, Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{GBIFTaxon, Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[16]||(e[16]=s()),a(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[17]||(e[17]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(t</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GBIFTaxon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns occurrences for a given taxon – the query arguments are the same as the <code>occurrences</code> function.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L103-L107" target="_blank" rel="noreferrer">source</a></p>',3))]),t("details",b,[t("summary",null,[e[18]||(e[18]=t("a",{id:"GBIF.occurrences-Tuple{Vector{GBIFTaxon}, Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{Vector{GBIFTaxon}, Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[19]||(e[19]=s()),a(i,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[20]||(e[20]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(t</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Vector{GBIFTaxon}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns occurrences for a series of taxa – the query arguments are the same as the <code>occurrences</code> function.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/occurrence.jl#L115-L119" target="_blank" rel="noreferrer">source</a></p>',3))]),e[36]||(e[36]=t("h3",{id:"Batch-download-of-occurrences",tabindex:"-1"},[s("Batch-download of occurrences "),t("a",{class:"header-anchor",href:"#Batch-download-of-occurrences","aria-label":'Permalink to "Batch-download of occurrences {#Batch-download-of-occurrences}"'},"​")],-1)),e[37]||(e[37]=t("p",null,[s("When calling "),t("code",null,"occurrences"),s(", the list of possible "),t("code",null,"GBIFRecord"),s(" will be pre-allocated. Any subsequent call to "),t("code",null,"occurrences!"),s(" (on the "),t("code",null,"GBIFRecords"),s(' variable) will retrieve the next "page" of results, and add them to the collection:')],-1)),t("details",y,[t("summary",null,[e[21]||(e[21]=t("a",{id:"GBIF.occurrences!",href:"#GBIF.occurrences!"},[t("span",{class:"jlbinding"},"GBIF.occurrences!")],-1)),e[22]||(e[22]=s()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[23]||(e[23]=t("p",null,[t("strong",null,"Get the next page of results")],-1)),e[24]||(e[24]=t("p",null,[s("This function will retrieve the next page of results. By default, it will walk through queries 20 at a time. This can be modified by changing the "),t("code",null,'.query["limit"]'),s(" value, to any value "),t("em",null,"up to"),s(" 300, which is the limit set by GBIF for the queries.")],-1)),e[25]||(e[25]=t("p",null,[s("If filters have been applied to this query before, they will be "),t("em",null,"removed"),s(" to ensure that the previous and the new occurrences have the same status, but only for records that have already been retrieved.")],-1)),e[26]||(e[26]=t("p",null,[t("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/paging.jl#L21-L32",target:"_blank",rel:"noreferrer"},"source")],-1))])])}const S=r(d,[["render",m]]);export{C as __pageData,S as default};
