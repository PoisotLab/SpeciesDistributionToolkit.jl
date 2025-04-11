import{_ as i,c as a,a2 as t,o as n}from"./chunks/framework.D6CyLWpr.js";const e="/SpeciesDistributionToolkit.jl/v1.1.1/assets/14468087708618707321-trimmed-layer.CJLOnkT-.png",l="/SpeciesDistributionToolkit.jl/v1.1.1/assets/14468087708618707321-districts.C2xbGX6V.png",p="/SpeciesDistributionToolkit.jl/v1.1.1/assets/14468087708618707321-zone-index.CaErIZ_c.png",h="/SpeciesDistributionToolkit.jl/v1.1.1/assets/14468087708618707321-highlight-areas.Dw2RhfTA.png",C=JSON.parse('{"title":"Zonal statistics","description":"","frontmatter":{},"headers":[],"relativePath":"howto/zonal-statistics.md","filePath":"howto/zonal-statistics.md","lastUpdated":null}'),k={name:"howto/zonal-statistics.md"};function r(d,s,o,A,c,g){return n(),a("div",null,s[0]||(s[0]=[t(`<h1 id="Zonal-statistics" tabindex="-1">Zonal statistics <a class="header-anchor" href="#Zonal-statistics" aria-label="Permalink to &quot;Zonal statistics {#Zonal-statistics}&quot;">​</a></h1><p>In this tutorial, we will grab some bioclimatic variables for New Zealand, and then identify the districts that have extreme values of this variable.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><p>We will get the BIO19 layer from CHELSA2 (most precipitation in the coldest quarter):</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 165.739746</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> -</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">47.587547</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 180.812988</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> -</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">33.649514</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, BioClim)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;BIO19&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 2865888 UInt16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (1674, 1712)</span></span></code></pre></div><p>This layer is trimmed to the landmass (according to GADM):</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer, SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;NZL&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 417341 UInt16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (1578, 1455)</span></span></code></pre></div><p><img src="`+e+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig, ax, plt </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer; axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidespines!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidedecorations!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span></code></pre></div></details><p>We can now get the lower level sub-division. Note that not all territories covered by GADM have the same number of sub-divisions!</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">districts </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;NZL&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">);</span></span></code></pre></div><p>We can start looking at how these map onto the landscape, using the <code>zone</code> function. It will return a layer where the value of each pixel is the index of the polygon containing this pixel:</p><p><img src="`+l+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">zone</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer, districts); colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :hokusai, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span></code></pre></div></details><p>Note that the pixels that are not within a polygon are turned off, which can sometimes happen if the overlap between polygons is not perfect. There is a variant of the <code>mosaic</code> method that uses polygon to assign the values:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">z </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> mosaic</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(median, layer, districts)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(z, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 417284 Float64 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (1578, 1455)</span></span></code></pre></div><p><img src="`+p+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig, ax, plt </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(z; axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidespines!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidedecorations!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span></code></pre></div></details><p>In order to make a plot identifying some areas, we get their full names using <code>gadmlist</code>:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">districtnames </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;NZL&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">districtnames[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">10</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>10-element Vector{String}:</span></span>
<span class="line"><span> &quot;Auckland&quot;</span></span>
<span class="line"><span> &quot;AreaOutsideTerritorialAuthori&quot;</span></span>
<span class="line"><span> &quot;Kawerau&quot;</span></span>
<span class="line"><span> &quot;Opotiki&quot;</span></span>
<span class="line"><span> &quot;Rotorua&quot;</span></span>
<span class="line"><span> &quot;Tauranga&quot;</span></span>
<span class="line"><span> &quot;WesternBayofPlenty&quot;</span></span>
<span class="line"><span> &quot;Whakatane&quot;</span></span>
<span class="line"><span> &quot;Ashburton&quot;</span></span>
<span class="line"><span> &quot;Christchurch&quot;</span></span></code></pre></div><p>Finally, we can get the median value within each of these polygons using the <code>byzone</code> method:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">top5 </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    first</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">        sort</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">            byzone</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(median, layer, districts, districtnames);</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">            by </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (x) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">-&gt;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> x</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">second,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">            rev </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        )[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    )</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>5-element Vector{String}:</span></span>
<span class="line"><span> &quot;Westland&quot;</span></span>
<span class="line"><span> &quot;Grey&quot;</span></span>
<span class="line"><span> &quot;Opotiki&quot;</span></span>
<span class="line"><span> &quot;Buller&quot;</span></span>
<span class="line"><span> &quot;NewPlymouth&quot;</span></span></code></pre></div><p><img src="`+h+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig, ax, plt </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer; axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()), colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [:lightgrey, :black])</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">[</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    lines!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax, districts[i]; label </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> districtnames[i], linewidth </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    i </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> indexin</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(top5, districtnames)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">axislegend</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(; position </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.7</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">), nbanks </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div></details>`,29)]))}const D=i(k,[["render",r]]);export{C as __pageData,D as default};
