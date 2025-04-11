import{_ as t,c as n,a2 as a,j as i,a as l,G as p,B as o,o as h}from"./chunks/framework.DF-HKlxZ.js";const d="/SpeciesDistributionToolkit.jl/v1.1.0/assets/14524785539235868273-partialload.DjCz0Hr_.png",D=JSON.parse('{"title":"... get the bounding box for an object?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/get-boundingbox.md","filePath":"howto/get-boundingbox.md","lastUpdated":null}'),k={name:"howto/get-boundingbox.md"},r={class:"jldocstring custom-block"};function c(g,s,u,b,A,y){const e=o("Badge");return h(),n("div",null,[s[3]||(s[3]=a(`<h1 id="...-get-the-bounding-box-for-an-object?" tabindex="-1">... get the bounding box for an object? <a class="header-anchor" href="#...-get-the-bounding-box-for-an-object?" aria-label="Permalink to &quot;... get the bounding box for an object? {#...-get-the-bounding-box-for-an-object?}&quot;">​</a></h1><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><p>The <code>boundingbox</code> method accepts most types that <code>SpeciesDistributionToolkit</code> knows about, and returns a tuple:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">occ </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;hasCoordinate&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;country&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;BR&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;limit&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = -56.053413, right = -35.220363, bottom = -31.761202, top = -3.507399)</span></span></code></pre></div><p>We can also specify a padding (in degrees) that is added to the bounding box:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ; padding </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = -57.053413, right = -34.220363, bottom = -32.761202, top = -2.507399)</span></span></code></pre></div><div class="info custom-block"><p class="custom-block-title">Why specify the module?</p><p>Makie and CairoMakie export a method called <code>boundingbox</code>. To remove any ambiguities when the method is called at a time where any Makie backed is loaded, we must specific which module we are calling it from. Note that the dispatch signature of the method implemented by SpeciesDistributionToolkit is not ambiguous.</p></div><p>This is useful to restrict the part of a layer that is loaded:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">L </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, BioClim);</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ; padding </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 6342825 Int16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (3512, 2621)</span></span></code></pre></div><p>Note that the bounding box is returned in WGS84, but the function to load any part of a layer will handle the conversion.</p><p><img src="`+d+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(L; colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :Greys)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ)</span></span></code></pre></div></details><p>The same method also applies to polygons:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">CHE </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;CHE&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">);</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHE; padding </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 5.456099987030029, right = 10.994799613952637, bottom = 45.317298889160156, top = 48.30849838256836)</span></span></code></pre></div>`,18)),i("details",r,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SpeciesDistributionToolkit.boundingbox-howto-get-boundingbox",href:"#SpeciesDistributionToolkit.boundingbox-howto-get-boundingbox"},[i("span",{class:"jlbinding"},"SpeciesDistributionToolkit.boundingbox")],-1)),s[1]||(s[1]=l()),p(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()</span></span></code></pre></div><p>Returns a tuple with coordinates left, right, bottom, top in WGS84, which can be used to decide which part of a raster should be loaded.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b50fc08ec3eded0d54c527d81376c13a9e6a1ef6/src/boundingbox.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; padding</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the bounding box for a collection of occurrences, with an additional padding.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b50fc08ec3eded0d54c527d81376c13a9e6a1ef6/src/boundingbox.jl#L12-L17" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">boundingbox</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; padding</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the bounding box for a layer, with an additional padding.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b50fc08ec3eded0d54c527d81376c13a9e6a1ef6/src/boundingbox.jl#L24-L28" target="_blank" rel="noreferrer">source</a></p>',9))])])}const v=t(k,[["render",c]]);export{D as __pageData,v as default};
