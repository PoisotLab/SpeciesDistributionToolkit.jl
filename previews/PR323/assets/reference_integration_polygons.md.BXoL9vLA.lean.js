import{_ as n,c as l,a2 as a,j as i,a as e,G as o,B as r,o as p}from"./chunks/framework.BBYNtJYl.js";const v=JSON.parse('{"title":"Working with polygons","description":"","frontmatter":{},"headers":[],"relativePath":"reference/integration/polygons.md","filePath":"reference/integration/polygons.md","lastUpdated":null}'),h={name:"reference/integration/polygons.md"},k={class:"jldocstring custom-block",open:""},d={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""};function u(b,s,f,m,A,D){const t=r("Badge");return p(),l("div",null,[s[15]||(s[15]=a('<h1 id="Working-with-polygons" tabindex="-1">Working with polygons <a class="header-anchor" href="#Working-with-polygons" aria-label="Permalink to &quot;Working with polygons {#Working-with-polygons}&quot;">​</a></h1><p>The package assumes that the polygons are read using <a href="https://github.com/JuliaGeo/GeoJSON.jl" target="_blank" rel="noreferrer">the <code>GeoJSON.jl</code> package</a>. As per <a href="https://datatracker.ietf.org/doc/html/rfc7946" target="_blank" rel="noreferrer">RFC7946</a>, the coordinates in the polygon must be WGS84.</p><h2 id="masking" tabindex="-1">Masking <a class="header-anchor" href="#masking" aria-label="Permalink to &quot;Masking&quot;">​</a></h2>',3)),i("details",k,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SimpleSDMLayers.mask!-Tuple{SDMLayer, GeoJSON.MultiPolygon}",href:"#SimpleSDMLayers.mask!-Tuple{SDMLayer, GeoJSON.MultiPolygon}"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask!")],-1)),s[1]||(s[1]=e()),o(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[2]||(s[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, multipolygon</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Turns of fall the cells outside the polygon (or within holes in the polygon). This modifies the object.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/polygons.jl#L71-L75" target="_blank" rel="noreferrer">source</a></p>',3))]),s[16]||(s[16]=i("h2",{id:"trimming",tabindex:"-1"},[e("Trimming "),i("a",{class:"header-anchor",href:"#trimming","aria-label":'Permalink to "Trimming"'},"​")],-1)),i("details",d,[i("summary",null,[s[3]||(s[3]=i("a",{id:"SpeciesDistributionToolkit.trim",href:"#SpeciesDistributionToolkit.trim"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.trim")],-1)),s[4]||(s[4]=e()),o(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a layer in which there are no empty rows/columns around the valued cells. This returns a <em>new</em> object. This will only remove the <em>terminal</em> empty rows/columns, so that gaps <em>inside</em> the layer are not affected.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/polygons.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, feature</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> GeoJSON.GeoJSONT</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Return a trimmed version of a layer, according to the feature defined a <code>GeoJSON</code> object. The object is first masked according to the <code>feature</code>, and then trimmed.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/polygons.jl#L26-L31" target="_blank" rel="noreferrer">source</a></p>',6))]),s[17]||(s[17]=i("h2",{id:"Mosaic-and-zonal-like-operations",tabindex:"-1"},[e("Mosaic and zonal-like operations "),i("a",{class:"header-anchor",href:"#Mosaic-and-zonal-like-operations","aria-label":'Permalink to "Mosaic and zonal-like operations {#Mosaic-and-zonal-like-operations}"'},"​")],-1)),i("details",g,[i("summary",null,[s[6]||(s[6]=i("a",{id:"SimpleSDMLayers.mosaic",href:"#SimpleSDMLayers.mosaic"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mosaic")],-1)),s[7]||(s[7]=e()),o(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[8]||(s[8]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mosaic</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(f, stack</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Vector{&lt;:SDMLayer}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a layer that is the application of <code>f</code> to the values at each cell in the array of layers given as the second argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/SimpleSDMLayers/src/mosaic.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mosaic</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(f, layer, polygons)</span></span></code></pre></div><p>Overload of the mosaic function where the layer is split according to the polygons given as the last argument, and then the function <code>f</code> is applied to all the zones defined this way. The <code>f</code> function can take both positional and keyword arguments.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/mosaic.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',6))]),i("details",c,[i("summary",null,[s[9]||(s[9]=i("a",{id:"SpeciesDistributionToolkit.zone",href:"#SpeciesDistributionToolkit.zone"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.zone")],-1)),s[10]||(s[10]=e()),o(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[11]||(s[11]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">zone</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, polygons)</span></span></code></pre></div><p>Returns a layer in which the value of each pixel is set to the index of the polygon to which it belongs. Initially valued cells that are not part of a polygon are turned off.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/zonal.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",y,[i("summary",null,[s[12]||(s[12]=i("a",{id:"SpeciesDistributionToolkit.byzone",href:"#SpeciesDistributionToolkit.byzone"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.byzone")],-1)),s[13]||(s[13]=e()),o(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[14]||(s[14]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">byzone</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(f, layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, polygons, polygonsnames </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">length</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(polygons))</span></span></code></pre></div><p>Applies the function <code>f</code> to all cells that belong to the same polygon, and returns the output as a dictionary. The function given as an argument can take both positional and keyword arguments.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/06b16835b569f4a9ef0e375d25afbbf2406626a7/src/polygons/zonal.jl#L17-L21" target="_blank" rel="noreferrer">source</a></p>',3))])])}const j=n(h,[["render",u]]);export{v as __pageData,j as default};
