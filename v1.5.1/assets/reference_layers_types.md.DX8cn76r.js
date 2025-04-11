import{_ as i,C as r,c as n,o as l,j as t,a,ag as d,G as o,w as p}from"./chunks/framework.DJWGqVem.js";const _=JSON.parse('{"title":"List of types","description":"","frontmatter":{},"headers":[],"relativePath":"reference/layers/types.md","filePath":"reference/layers/types.md","lastUpdated":null}'),c={name:"reference/layers/types.md"},m={class:"jldocstring custom-block",open:""};function f(h,e,y,u,g,b){const s=r("Badge");return l(),n("div",null,[e[4]||(e[4]=t("h1",{id:"List-of-types",tabindex:"-1"},[a("List of types "),t("a",{class:"header-anchor",href:"#List-of-types","aria-label":'Permalink to "List of types {#List-of-types}"'},"​")],-1)),t("details",m,[t("summary",null,[e[0]||(e[0]=t("a",{id:"SimpleSDMLayers.SDMLayer",href:"#SimpleSDMLayers.SDMLayer"},[t("span",{class:"jlbinding"},"SimpleSDMLayers.SDMLayer")],-1)),e[1]||(e[1]=a()),o(s,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=d('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">SDMLayer{T}</span></span></code></pre></div><p>Defines a layer of geospatial information.</p><p>The type has two data fields:</p><ul><li><p><strong>grid</strong>: a <code>Matrix</code> of type <code>T</code></p></li><li><p><strong>indices</strong>: a <code>BitMatrix</code> to see which positions are valued</p></li></ul><p>Each <em>row</em> in the <code>grid</code> field represents a slice of the raster of equal <em>northing</em>, <em>i.e.</em> the information is laid out in the matrix as it would be represented on a map once displayed. Similarly, columns have the same <em>easting</em>.</p><p>The geospatial information is represented by three positional fields:</p><ul><li><p><strong>x</strong> and <strong>y</strong>: two tuples, indicating the coordinates of the <em>corners</em> alongside the <em>x</em> and <em>y</em> dimensions (e.g. easting/northing) - the default values are <code>(-180., 180.)</code> and <code>(-90., 90.)</code>, which represents the entire surface of the globe in WGS84</p></li><li><p><strong>crs</strong>: any <code>String</code> representation of the CRS which can be handled by <code>Proj.jl</code> - the default is <code>&quot;+proj=longlat +datum=WGS84 +no_defs&quot;</code>, which represents a latitude/longitude coordinate system</p></li></ul>',7)),o(s,{type:"info",class:"source-link",text:"source"},{default:p(()=>e[2]||(e[2]=[t("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/820e0f143a5ad4572b611ed7f337c0b0a8bb65d1/SimpleSDMLayers/src/types.jl#L1-L24",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const L=i(c,[["render",f]]);export{_ as __pageData,L as default};
