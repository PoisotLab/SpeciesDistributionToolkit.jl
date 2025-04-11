import{_ as r,C as n,c as l,o as c,j as t,a as s,ag as o,G as i}from"./chunks/framework.DfWWDbyc.js";const C=JSON.parse('{"title":"Retrieving data","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/data.md","filePath":"reference/gbif/data.md","lastUpdated":null}'),d={name:"reference/gbif/data.md"},p={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""};function m(B,e,T,A,v,I){const a=n("Badge");return c(),l("div",null,[e[27]||(e[27]=t("h1",{id:"Retrieving-data",tabindex:"-1"},[s("Retrieving data "),t("a",{class:"header-anchor",href:"#Retrieving-data","aria-label":'Permalink to "Retrieving data {#Retrieving-data}"'},"​")],-1)),e[28]||(e[28]=t("h2",{id:"Getting-taxonomic-information",tabindex:"-1"},[s("Getting taxonomic information "),t("a",{class:"header-anchor",href:"#Getting-taxonomic-information","aria-label":'Permalink to "Getting taxonomic information {#Getting-taxonomic-information}"'},"​")],-1)),t("details",p,[t("summary",null,[e[0]||(e[0]=t("a",{id:"GBIF.taxon",href:"#GBIF.taxon"},[t("span",{class:"jlbinding"},"GBIF.taxon")],-1)),e[1]||(e[1]=s()),i(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[2]||(e[2]=o("",12))]),e[29]||(e[29]=t("h2",{id:"Searching-for-occurrence-data",tabindex:"-1"},[s("Searching for occurrence data "),t("a",{class:"header-anchor",href:"#Searching-for-occurrence-data","aria-label":'Permalink to "Searching for occurrence data {#Searching-for-occurrence-data}"'},"​")],-1)),e[30]||(e[30]=t("p",null,[s("The most common task is to retrieve many occurrences according to a query. The core type of this package is "),t("code",null,"GBIFRecord"),s(", which is a very lightweight type containing information about the query, and a list of "),t("code",null,"GBIFRecord"),s(' for every matching occurrence. Note that the GBIF "search" API is limited to 100000 results, and will not return more than this amount.')],-1)),e[31]||(e[31]=t("h3",{id:"Single-occurrence",tabindex:"-1"},[s("Single occurrence "),t("a",{class:"header-anchor",href:"#Single-occurrence","aria-label":'Permalink to "Single occurrence {#Single-occurrence}"'},"​")],-1)),t("details",u,[t("summary",null,[e[3]||(e[3]=t("a",{id:"GBIF.occurrence",href:"#GBIF.occurrence"},[t("span",{class:"jlbinding"},"GBIF.occurrence")],-1)),e[4]||(e[4]=s()),i(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[5]||(e[5]=o("",3))]),e[32]||(e[32]=t("h3",{id:"Multiple-occurrences",tabindex:"-1"},[s("Multiple occurrences "),t("a",{class:"header-anchor",href:"#Multiple-occurrences","aria-label":'Permalink to "Multiple occurrences {#Multiple-occurrences}"'},"​")],-1)),t("details",h,[t("summary",null,[e[6]||(e[6]=t("a",{id:"GBIF.occurrences-Tuple{}",href:"#GBIF.occurrences-Tuple{}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[7]||(e[7]=s()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[8]||(e[8]=o("",5))]),t("details",g,[t("summary",null,[e[9]||(e[9]=t("a",{id:"GBIF.occurrences-Tuple{GBIFTaxon}",href:"#GBIF.occurrences-Tuple{GBIFTaxon}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[10]||(e[10]=s()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[11]||(e[11]=o("",3))]),e[33]||(e[33]=t("p",null,[s("When called with no arguments, this function will return a list of the latest 20 occurrences recorded in GBIF. Note that the "),t("code",null,"GBIFRecords"),s(" type, which is the return type of "),t("code",null,"occurrences"),s(", implements the iteration interface.")],-1)),e[34]||(e[34]=t("h3",{id:"Query-parameters",tabindex:"-1"},[s("Query parameters "),t("a",{class:"header-anchor",href:"#Query-parameters","aria-label":'Permalink to "Query parameters {#Query-parameters}"'},"​")],-1)),e[35]||(e[35]=t("p",null,"The queries must be given as pairs of values.",-1)),t("details",k,[t("summary",null,[e[12]||(e[12]=t("a",{id:"GBIF.occurrences-Tuple{Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[13]||(e[13]=s()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[14]||(e[14]=o("",5))]),t("details",b,[t("summary",null,[e[15]||(e[15]=t("a",{id:"GBIF.occurrences-Tuple{GBIFTaxon, Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{GBIFTaxon, Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[16]||(e[16]=s()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[17]||(e[17]=o("",3))]),t("details",f,[t("summary",null,[e[18]||(e[18]=t("a",{id:"GBIF.occurrences-Tuple{Vector{GBIFTaxon}, Vararg{Pair}}",href:"#GBIF.occurrences-Tuple{Vector{GBIFTaxon}, Vararg{Pair}}"},[t("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),e[19]||(e[19]=s()),i(a,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),e[20]||(e[20]=o("",3))]),e[36]||(e[36]=t("h3",{id:"Batch-download-of-occurrences",tabindex:"-1"},[s("Batch-download of occurrences "),t("a",{class:"header-anchor",href:"#Batch-download-of-occurrences","aria-label":'Permalink to "Batch-download of occurrences {#Batch-download-of-occurrences}"'},"​")],-1)),e[37]||(e[37]=t("p",null,[s("When calling "),t("code",null,"occurrences"),s(", the list of possible "),t("code",null,"GBIFRecord"),s(" will be pre-allocated. Any subsequent call to "),t("code",null,"occurrences!"),s(" (on the "),t("code",null,"GBIFRecords"),s(' variable) will retrieve the next "page" of results, and add them to the collection:')],-1)),t("details",y,[t("summary",null,[e[21]||(e[21]=t("a",{id:"GBIF.occurrences!",href:"#GBIF.occurrences!"},[t("span",{class:"jlbinding"},"GBIF.occurrences!")],-1)),e[22]||(e[22]=s()),i(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[23]||(e[23]=t("p",null,[t("strong",null,"Get the next page of results")],-1)),e[24]||(e[24]=t("p",null,[s("This function will retrieve the next page of results. By default, it will walk through queries 20 at a time. This can be modified by changing the "),t("code",null,'.query["limit"]'),s(" value, to any value "),t("em",null,"up to"),s(" 300, which is the limit set by GBIF for the queries.")],-1)),e[25]||(e[25]=t("p",null,[s("If filters have been applied to this query before, they will be "),t("em",null,"removed"),s(" to ensure that the previous and the new occurrences have the same status, but only for records that have already been retrieved.")],-1)),e[26]||(e[26]=t("p",null,[t("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/paging.jl#L21-L32",target:"_blank",rel:"noreferrer"},"source")],-1))])])}const S=r(d,[["render",m]]);export{C as __pageData,S as default};
