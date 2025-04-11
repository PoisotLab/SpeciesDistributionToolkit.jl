import{_ as n,c as o,a2 as e,j as i,a,G as l,B as r,o as p}from"./chunks/framework.Blr9SLS9.js";const m=JSON.parse('{"title":"Access GADM polygons","description":"","frontmatter":{},"headers":[],"relativePath":"manual/gadm.md","filePath":"manual/gadm.md","lastUpdated":null}'),h={name:"manual/gadm.md"},d={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function k(g,s,b,u,y,A){const t=r("Badge");return p(),o("div",null,[s[6]||(s[6]=e('<h1 id="Access-GADM-polygons" tabindex="-1">Access GADM polygons <a class="header-anchor" href="#Access-GADM-polygons" aria-label="Permalink to &quot;Access GADM polygons {#Access-GADM-polygons}&quot;">​</a></h1><p>The package come with a <em>very</em> lightweight series of convenience functions to interact with <a href="https://gadm.org/" target="_blank" rel="noreferrer">GADM</a>. The <a href="https://github.com/JuliaGeo/GADM.jl" target="_blank" rel="noreferrer"><code>GADM.jl</code> package</a> is an alternative solution to the same problem.</p><p>All methods assume that the first argument is an alpha-3 code valid under <a href="https://www.iso.org/obp/ui/#search" target="_blank" rel="noreferrer">ISO 3166-1</a>, and the following levels are sub-divisions of this territory.</p><h2 id="Accessing-polygons" tabindex="-1">Accessing polygons <a class="header-anchor" href="#Accessing-polygons" aria-label="Permalink to &quot;Accessing polygons {#Accessing-polygons}&quot;">​</a></h2>',4)),i("details",d,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SpeciesDistributionToolkit.gadm",href:"#SpeciesDistributionToolkit.gadm"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.gadm")],-1)),s[1]||(s[1]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the <code>GeoJSON</code> object associated to a the alpha-3 code defined by <a href="https://www.iso.org/obp/ui/#search/code/" target="_blank" rel="noreferrer">ISO</a>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L37-L42" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, places</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all polygons nested within an arbitrary sequence of areas according to GADM. For example, getting all counties in Oklahoma is achieved with the arguments <code>&quot;USA&quot;, &quot;Oklahoma&quot;</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L45-L51" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, level</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all areas within the top-level territory <code>code</code>, at the level <code>level</code>. For example, getting all <em>départements</em> in France is done with the arguments <code>&quot;FRA&quot;, 2</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L71-L77" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, level</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, places</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all areas within the <code>places</code> within a country defined by <code>code</code> at a specific level. For example, the <em>districts</em> in the French region of Bretagne are obtained with the arguments <code>&quot;FRA&quot;, 3, &quot;Bretagne&quot;</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L83-L89" target="_blank" rel="noreferrer">source</a></p>',12))]),s[7]||(s[7]=i("h2",{id:"Listing-polygons",tabindex:"-1"},[a("Listing polygons "),i("a",{class:"header-anchor",href:"#Listing-polygons","aria-label":'Permalink to "Listing polygons {#Listing-polygons}"'},"​")],-1)),i("details",c,[i("summary",null,[s[3]||(s[3]=i("a",{id:"SpeciesDistributionToolkit.gadmlist",href:"#SpeciesDistributionToolkit.gadmlist"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.gadmlist")],-1)),s[4]||(s[4]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all top-level divisions of the territory defined by its <code>code</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L107-L111" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, level</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all <code>level</code> divisions of the territory defined by its <code>code</code>, regardless of which higher-level divisions they belong to.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L130-L135" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(code</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, level</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, places</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">String...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns all <code>level</code> divisions of the territory defined by its <code>code</code>, that belong to the hierarchy defined by <code>places</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/gadm.jl#L141-L146" target="_blank" rel="noreferrer">source</a></p>',9))])])}const C=n(h,[["render",k]]);export{m as __pageData,C as default};
