import{_ as l,C as o,c as r,o as h,ag as i,j as e,a as s,G as n}from"./chunks/framework.RaFiNGy7.js";const A=JSON.parse('{"title":"... get data from GBIF?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/get-gbif-data.md","filePath":"howto/get-gbif-data.md","lastUpdated":null}'),d={name:"howto/get-gbif-data.md"},p={class:"jldocstring custom-block"},c={class:"jldocstring custom-block"},g={class:"jldocstring custom-block"};function k(u,t,y,f,b,m){const a=o("Badge");return h(),r("div",null,[t[12]||(t[12]=i("",40)),e("details",p,[e("summary",null,[t[0]||(t[0]=e("a",{id:"GBIF.taxon-howto-get-gbif-data",href:"#GBIF.taxon-howto-get-gbif-data"},[e("span",{class:"jlbinding"},"GBIF.taxon")],-1)),t[1]||(t[1]=s()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[2]||(t[2]=i("",12))]),e("details",c,[e("summary",null,[t[3]||(t[3]=e("a",{id:"GBIF.occurrences-howto-get-gbif-data",href:"#GBIF.occurrences-howto-get-gbif-data"},[e("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),t[4]||(t[4]=s()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[5]||(t[5]=i("",11))]),e("details",g,[e("summary",null,[t[6]||(t[6]=e("a",{id:"GBIF.occurrences!-howto-get-gbif-data",href:"#GBIF.occurrences!-howto-get-gbif-data"},[e("span",{class:"jlbinding"},"GBIF.occurrences!")],-1)),t[7]||(t[7]=s()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[8]||(t[8]=e("p",null,[e("strong",null,"Get the next page of results")],-1)),t[9]||(t[9]=e("p",null,[s("This function will retrieve the next page of results. By default, it will walk through queries 20 at a time. This can be modified by changing the "),e("code",null,'.query["limit"]'),s(" value, to any value "),e("em",null,"up to"),s(" 300, which is the limit set by GBIF for the queries.")],-1)),t[10]||(t[10]=e("p",null,[s("If filters have been applied to this query before, they will be "),e("em",null,"removed"),s(" to ensure that the previous and the new occurrences have the same status, but only for records that have already been retrieved.")],-1)),t[11]||(t[11]=e("p",null,[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/GBIF/src/paging.jl#L21-L32",target:"_blank",rel:"noreferrer"},"source")],-1))])])}const C=l(d,[["render",k]]);export{A as __pageData,C as default};
