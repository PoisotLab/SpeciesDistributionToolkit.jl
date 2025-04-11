import{_ as o,c as i,j as t,a as s,G as r,a2 as n,B as l,o as d}from"./chunks/framework.D9BeJ9z8.js";const S=JSON.parse('{"title":"List of types","description":"","frontmatter":{},"headers":[],"relativePath":"reference/layers/types.md","filePath":"reference/layers/types.md","lastUpdated":null}'),p={name:"reference/layers/types.md"},c={class:"jldocstring custom-block",open:""};function m(f,e,h,y,g,u){const a=l("Badge");return d(),i("div",null,[e[3]||(e[3]=t("h1",{id:"List-of-types",tabindex:"-1"},[s("List of types "),t("a",{class:"header-anchor",href:"#List-of-types","aria-label":'Permalink to "List of types {#List-of-types}"'},"​")],-1)),t("details",c,[t("summary",null,[e[0]||(e[0]=t("a",{id:"SimpleSDMLayers.SDMLayer",href:"#SimpleSDMLayers.SDMLayer"},[t("span",{class:"jlbinding"},"SimpleSDMLayers.SDMLayer")],-1)),e[1]||(e[1]=s()),r(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SDMLayer{T}</span></span></code></pre></div><p>Defines a layer of geospatial information.</p><p>The type has two data fields:</p><ul><li><p><strong>grid</strong>: a <code>Matrix</code> of type <code>T</code></p></li><li><p><strong>indices</strong>: a <code>BitMatrix</code> to see which positions are valued</p></li></ul><p>Each <em>row</em> in the <code>grid</code> field represents a slice of the raster of equal <em>northing</em>, <em>i.e.</em> the information is laid out in the matrix as it would be represented on a map once displayed. Similarly, columns have the same <em>easting</em>.</p><p>The geospatial information is represented by three positional fields:</p><ul><li><p><strong>x</strong> and <strong>y</strong>: two tuples, indicating the coordinates of the <em>corners</em> alongside the <em>x</em> and <em>y</em> dimensions (e.g. easting/northing) - the default values are <code>(-180., 180.)</code> and <code>(-90., 90.)</code>, which represents the entire surface of the globe in WGS84</p></li><li><p><strong>crs</strong>: any <code>String</code> representation of the CRS which can be handled by <code>Proj.jl</code> - the default is <code>&quot;+proj=longlat +datum=WGS84 +no_defs&quot;</code>, which represents a latitude/longitude coordinate system</p></li></ul><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SimpleSDMLayers/src/types.jl#L1-L24" target="_blank" rel="noreferrer">source</a></p>',8))])])}const L=o(p,[["render",m]]);export{S as __pageData,L as default};
