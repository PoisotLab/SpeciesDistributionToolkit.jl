import{_ as n,c as o,a2 as a,j as i,a as t,G as l,B as p,o as r}from"./chunks/framework.Blr9SLS9.js";const f=JSON.parse('{"title":"Additional operations of GBIF data","description":"","frontmatter":{},"headers":[],"relativePath":"manual/gbif.jl.md","filePath":"manual/gbif.jl.md","lastUpdated":null}'),d={name:"manual/gbif.jl.md"},k={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""};function c(g,s,b,y,m,u){const e=p("Badge");return r(),o("div",null,[s[6]||(s[6]=a('<h1 id="Additional-operations-of-GBIF-data" tabindex="-1">Additional operations of GBIF data <a class="header-anchor" href="#Additional-operations-of-GBIF-data" aria-label="Permalink to &quot;Additional operations of GBIF data {#Additional-operations-of-GBIF-data}&quot;">​</a></h1><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>SimpleSDMLayers.longitudes(records::GBIF.GBIFRecords)</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>SimpleSDMLayers.latitudes(records::GBIF.GBIFRecords)</code>. Check Documenter&#39;s build log for details.</p></div>',3)),i("details",k,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SimpleSDMLayers.mask",href:"#SimpleSDMLayers.mask"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask")],-1)),s[1]||(s[1]=t()),l(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, template</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a copy of the first layer masked according to the second layer. See also <code>mask!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/SimpleSDMLayers/src/mask.jl#L16-L20" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(records</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GBIFRecords</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, multipolygon</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/polygons.jl#L88-L90" target="_blank" rel="noreferrer">source</a></p>',5))]),i("details",h,[i("summary",null,[s[3]||(s[3]=i("a",{id:"SimpleSDMLayers.mask!",href:"#SimpleSDMLayers.mask!"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask!")],-1)),s[4]||(s[4]=t()),l(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, template</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Updates the positions in the first layer to be those that have a value in the second layer.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/SimpleSDMLayers/src/mask.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, multipolygon</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b6bf5ee2345dabb1cf8bc433c909a6d45dabbfcf/src/polygons/polygons.jl#L71-L73" target="_blank" rel="noreferrer">source</a></p>',5))])])}const D=n(d,[["render",c]]);export{f as __pageData,D as default};
