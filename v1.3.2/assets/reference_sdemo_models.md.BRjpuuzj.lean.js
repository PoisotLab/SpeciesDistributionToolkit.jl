import{_ as o,C as n,c as l,o as d,ag as t,j as a,a as s,G as r}from"./chunks/framework.DfWWDbyc.js";const A=JSON.parse('{"title":"Models","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/models.md","filePath":"reference/sdemo/models.md","lastUpdated":null}'),p={name:"reference/sdemo/models.md"},c={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""};function v(k,e,y,_,j,S){const i=n("Badge");return d(),l("div",null,[e[24]||(e[24]=t("",4)),a("details",c,[a("summary",null,[e[0]||(e[0]=a("a",{id:"SDeMo.RawData",href:"#SDeMo.RawData"},[a("span",{class:"jlbinding"},"SDeMo.RawData")],-1)),e[1]||(e[1]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=t("",3))]),a("details",h,[a("summary",null,[e[3]||(e[3]=a("a",{id:"SDeMo.ZScore",href:"#SDeMo.ZScore"},[a("span",{class:"jlbinding"},"SDeMo.ZScore")],-1)),e[4]||(e[4]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[5]||(e[5]=t("",4))]),e[25]||(e[25]=a("h2",{id:"Transformers-multivariate",tabindex:"-1"},[s("Transformers (multivariate) "),a("a",{class:"header-anchor",href:"#Transformers-multivariate","aria-label":'Permalink to "Transformers (multivariate) {#Transformers-multivariate}"'},"​")],-1)),e[26]||(e[26]=a("p",null,[s("The multivariate transformers are using "),a("a",{href:"https://juliastats.org/MultivariateStats.jl/dev/",target:"_blank",rel:"noreferrer"},[a("code",null,"MultivariateStats")]),s(" to handle the training data. During projection, the features are projected using the transformation that was learned from the training data.")],-1)),a("details",u,[a("summary",null,[e[6]||(e[6]=a("a",{id:"SDeMo.PCATransform",href:"#SDeMo.PCATransform"},[a("span",{class:"jlbinding"},"SDeMo.PCATransform")],-1)),e[7]||(e[7]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[8]||(e[8]=t("",4))]),a("details",m,[a("summary",null,[e[9]||(e[9]=a("a",{id:"SDeMo.WhiteningTransform",href:"#SDeMo.WhiteningTransform"},[a("span",{class:"jlbinding"},"SDeMo.WhiteningTransform")],-1)),e[10]||(e[10]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=t("",5))]),a("details",f,[a("summary",null,[e[12]||(e[12]=a("a",{id:"SDeMo.MultivariateTransform",href:"#SDeMo.MultivariateTransform"},[a("span",{class:"jlbinding"},"SDeMo.MultivariateTransform")],-1)),e[13]||(e[13]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[14]||(e[14]=t("",3))]),e[27]||(e[27]=a("h2",{id:"classifiers",tabindex:"-1"},[s("Classifiers "),a("a",{class:"header-anchor",href:"#classifiers","aria-label":'Permalink to "Classifiers"'},"​")],-1)),a("details",b,[a("summary",null,[e[15]||(e[15]=a("a",{id:"SDeMo.NaiveBayes",href:"#SDeMo.NaiveBayes"},[a("span",{class:"jlbinding"},"SDeMo.NaiveBayes")],-1)),e[16]||(e[16]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[17]||(e[17]=t("",4))]),a("details",T,[a("summary",null,[e[18]||(e[18]=a("a",{id:"SDeMo.BIOCLIM",href:"#SDeMo.BIOCLIM"},[a("span",{class:"jlbinding"},"SDeMo.BIOCLIM")],-1)),e[19]||(e[19]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[20]||(e[20]=t("",3))]),a("details",g,[a("summary",null,[e[21]||(e[21]=a("a",{id:"SDeMo.DecisionTree",href:"#SDeMo.DecisionTree"},[a("span",{class:"jlbinding"},"SDeMo.DecisionTree")],-1)),e[22]||(e[22]=s()),r(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[23]||(e[23]=t("",3))]),e[28]||(e[28]=a("div",{class:"tip custom-block"},[a("p",{class:"custom-block-title"},"Adding new models"),a("p",null,[s("Adding a new transformer or classifier is relatively straightforward (refer to the implementation of "),a("code",null,"ZScore"),s(" and "),a("code",null,"BIOCLIM"),s(" for easily digestible examples). The only methods to implement are "),a("code",null,"train!"),s(" and "),a("code",null,"StatsAPI.predict"),s(".")])],-1))])}const D=o(p,[["render",v]]);export{A as __pageData,D as default};
