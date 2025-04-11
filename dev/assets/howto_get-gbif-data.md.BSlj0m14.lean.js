import{_ as o,C as r,c as h,o as d,ag as n,j as s,G as i,a,w as l}from"./chunks/framework.5VWB6o6B.js";const v=JSON.parse('{"title":"... get data from GBIF?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/get-gbif-data.md","filePath":"howto/get-gbif-data.md","lastUpdated":null}'),p={name:"howto/get-gbif-data.md"},c={class:"jldocstring custom-block"},g={class:"jldocstring custom-block"},k={class:"jldocstring custom-block"};function u(y,t,F,m,f,B){const e=r("Badge");return d(),h("div",null,[t[20]||(t[20]=n("",40)),s("details",c,[s("summary",null,[t[0]||(t[0]=s("a",{id:"GBIF.taxon-howto-get-gbif-data",href:"#GBIF.taxon-howto-get-gbif-data"},[s("span",{class:"jlbinding"},"GBIF.taxon")],-1)),t[1]||(t[1]=a()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[4]||(t[4]=n("",7)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[2]||(t[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/taxon.jl#L1-L27",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),t[5]||(t[5]=n("",3)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[3]||(t[3]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/taxon.jl#L72-L79",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",g,[s("summary",null,[t[6]||(t[6]=s("a",{id:"GBIF.occurrences-howto-get-gbif-data",href:"#GBIF.occurrences-howto-get-gbif-data"},[s("span",{class:"jlbinding"},"GBIF.occurrences")],-1)),t[7]||(t[7]=a()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[11]||(t[11]=n("",4)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[8]||(t[8]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/occurrence.jl#L74-L88",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),t[12]||(t[12]=n("",2)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[9]||(t[9]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/occurrence.jl#L103-L107",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),t[13]||(t[13]=n("",2)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[10]||(t[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/occurrence.jl#L115-L119",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",k,[s("summary",null,[t[14]||(t[14]=s("a",{id:"GBIF.occurrences!-howto-get-gbif-data",href:"#GBIF.occurrences!-howto-get-gbif-data"},[s("span",{class:"jlbinding"},"GBIF.occurrences!")],-1)),t[15]||(t[15]=a()),i(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),t[17]||(t[17]=s("p",null,[s("strong",null,"Get the next page of results")],-1)),t[18]||(t[18]=s("p",null,[a("This function will retrieve the next page of results. By default, it will walk through queries 20 at a time. This can be modified by changing the "),s("code",null,'.query["limit"]'),a(" value, to any value "),s("em",null,"up to"),a(" 300, which is the limit set by GBIF for the queries.")],-1)),t[19]||(t[19]=s("p",null,[a("If filters have been applied to this query before, they will be "),s("em",null,"removed"),a(" to ensure that the previous and the new occurrences have the same status, but only for records that have already been retrieved.")],-1)),i(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>t[16]||(t[16]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/GBIF/src/paging.jl#L21-L32",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const x=o(p,[["render",u]]);export{v as __pageData,x as default};
