import{_ as i,C as r,c as d,o as l,j as t,a as o,ag as s,G as a}from"./chunks/framework.CDhplf9O.js";const T=JSON.parse('{"title":"Data representation","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/types.md","filePath":"reference/gbif/types.md","lastUpdated":null}'),c={name:"reference/gbif/types.md"},p={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""};function m(h,e,b,y,I,g){const n=r("Badge");return l(),d("div",null,[e[12]||(e[12]=t("h1",{id:"Data-representation",tabindex:"-1"},[o("Data representation "),t("a",{class:"header-anchor",href:"#Data-representation","aria-label":'Permalink to "Data representation {#Data-representation}"'},"​")],-1)),t("details",p,[t("summary",null,[e[0]||(e[0]=t("a",{id:"GBIF.GBIFTaxon",href:"#GBIF.GBIFTaxon"},[t("span",{class:"jlbinding"},"GBIF.GBIFTaxon")],-1)),e[1]||(e[1]=o()),a(n,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=s('<p><strong>Representation of a GBIF taxon</strong></p><p>All taxonomic level fields can either be <code>missing</code>, or a pair linking the name of the taxon/level to its unique key in the GBIF database.</p><p><code>name</code> - the vernacular name of the taxon</p><p><code>scientific</code> - the accepted scientific name of the species</p><p><code>status</code> - the status of the taxon</p><p><code>match</code> - the type of match</p><p><code>kingdom</code> - a <code>Pair</code> linking the name of the kingdom to its unique ID</p><p><code>phylum</code> - a <code>Pair</code> linking the name of the phylum to its unique ID</p><p><code>class</code> - a <code>Pair</code> linking the name of the class to its unique ID</p><p><code>order</code> - a <code>Pair</code> linking the name of the order to its unique ID</p><p><code>family</code> - a <code>Pair</code> linking the name of the family to its unique ID</p><p><code>genus</code> - a <code>Pair</code> linking the name of the genus to its unique ID</p><p><code>species</code> - a <code>Pair</code> linking the name of the species to its unique ID</p><p><code>confidence</code> - an <code>Int64</code> to note the confidence in the match</p><p><code>synonym</code> - a <code>Boolean</code> indicating whether the taxon is a synonym</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/d240686de45fba9c81a5a6f61fe6d675184f4616/GBIF/src/types/GBIFTaxon.jl#L1-L32" target="_blank" rel="noreferrer">source</a></p>',16))]),t("details",f,[t("summary",null,[e[3]||(e[3]=t("a",{id:"GBIF.GBIFRecord",href:"#GBIF.GBIFRecord"},[t("span",{class:"jlbinding"},"GBIF.GBIFRecord")],-1)),e[4]||(e[4]=o()),a(n,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[5]||(e[5]=s('<p><strong>Represents an occurrence in the GBIF format</strong></p><p>This is currently a subset of all the fields. This <code>struct</code> is <em>not</em> mutable – this ensures that the objects returned from the GBIF database are never modified by the user.</p><p>The <code>taxon</code> field is a <code>GBIFTaxon</code> object, and can therefore be manipulated as any other <code>GBIFTaxon</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/d240686de45fba9c81a5a6f61fe6d675184f4616/GBIF/src/types/GBIFRecords.jl#L1-L10" target="_blank" rel="noreferrer">source</a></p>',4))]),t("details",u,[t("summary",null,[e[6]||(e[6]=t("a",{id:"GBIF.GBIFRecords",href:"#GBIF.GBIFRecords"},[t("span",{class:"jlbinding"},"GBIF.GBIFRecords")],-1)),e[7]||(e[7]=o()),a(n,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[8]||(e[8]=t("p",null,[t("strong",null,"List of occurrences and metadata")],-1)),e[9]||(e[9]=t("p",null,[o("This type has actually very few information: the "),t("code",null,"query"),o(" field stores the query parameters. This type is mutable and fully iterable.")],-1)),e[10]||(e[10]=t("p",null,[o("The "),t("code",null,"occurrences"),o(" field is pre-allocated, meaning that it will contain "),t("code",null,"#undef"),o(" elements up to the total number of hits on GBIF. When iterating, this is taken care of automatically, but this needs to be accounted for if writing code that accesses this field directly.")],-1)),e[11]||(e[11]=t("p",null,[t("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/d240686de45fba9c81a5a6f61fe6d675184f4616/GBIF/src/types/GBIFRecords.jl#L135-L145",target:"_blank",rel:"noreferrer"},"source")],-1))])])}const G=i(c,[["render",m]]);export{T as __pageData,G as default};
