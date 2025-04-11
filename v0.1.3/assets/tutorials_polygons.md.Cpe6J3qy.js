import{_ as i,c as a,a2 as e,o as t}from"./chunks/framework.Blr9SLS9.js";const n="/SpeciesDistributionToolkit.jl/v0.1.3/assets/12881152519641295018-10168662311427606421-whole-region.67p4LGEq.png",l="/SpeciesDistributionToolkit.jl/v0.1.3/assets/12881152519641295018-10168662311427606421-region-masked.D13mifpe.png",p="/SpeciesDistributionToolkit.jl/v0.1.3/assets/12881152519641295018-10168662311427606421-region-trimmed.B5VRWd24.png",h="/SpeciesDistributionToolkit.jl/v0.1.3/assets/12881152519641295018-10168662311427606421-all-occurrences.CxltopyB.png",k="/SpeciesDistributionToolkit.jl/v0.1.3/assets/12881152519641295018-10168662311427606421-trimmed-occurrences.C-bwbYQX.png",u=JSON.parse('{"title":"Working with polygons","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/polygons.md","filePath":"tutorials/polygons.md","lastUpdated":null}'),r={name:"tutorials/polygons.md"};function o(d,s,c,A,g,y){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Working-with-polygons" tabindex="-1">Working with polygons <a class="header-anchor" href="#Working-with-polygons" aria-label="Permalink to &quot;Working with polygons {#Working-with-polygons}&quot;">​</a></h1><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> GeoJSON</span></span></code></pre></div><p>In this tutorial, we will clip a layer to a polygon (in GeoJSON format), then use the same polygon to filter GBIF records.</p><div class="warning custom-block"><p class="custom-block-title">About coordinates</p><p><a href="https://geojson.org/" target="_blank" rel="noreferrer">GeoJSON</a> coordinates are expressed in WGS84. For this reason, <em>any</em> polygon is assumed to be in this CRS, and all operations will be done by projecting the layer coordinates to this CRS.</p></div><p>We provide a very lightweight wrapper around the <a href="https://gadm.org/index.html" target="_blank" rel="noreferrer">GADM</a> database, which will return data as ready-to-use GeoJSON files.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">DEU </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadm</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;DEU&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>FeatureCollection with 1 Features</span></span></code></pre></div><details class="details custom-block"><summary>More about GADM</summary><p>The only other function to interact with GADM is <code>gadmlist</code>, which takes either a series of places, as in</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;FRA&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Bretagne&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>4-element Vector{String}:</span></span>
<span class="line"><span> &quot;Côtes-d&#39;Armor&quot;</span></span>
<span class="line"><span> &quot;Finistère&quot;</span></span>
<span class="line"><span> &quot;Ille-et-Vilaine&quot;</span></span>
<span class="line"><span> &quot;Morbihan&quot;</span></span></code></pre></div><p>or a level, to provide a list of places within a three-letter coded area at a specific depth:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SpeciesDistributionToolkit</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">gadmlist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;FRA&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>3-element Vector{String}:</span></span>
<span class="line"><span> &quot;Belley&quot;</span></span>
<span class="line"><span> &quot;Bourg-en-Bresse&quot;</span></span>
<span class="line"><span> &quot;Gex&quot;</span></span></code></pre></div></details><p>The next step is to get a layer, and so we will download the data about deciduous broadleaf trees from <a href="/SpeciesDistributionToolkit.jl/v0.1.3/datasets/EarthEnv#landcover">EarthEnv</a>:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">provider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(EarthEnv, LandCover)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    provider;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Deciduous Broadleaf Trees&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 2.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 20.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 45.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 57.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 3110400 UInt8 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (1440, 2160)</span></span></code></pre></div><p>We can check that this polygon is larger than the area we want:</p><p><img src="`+n+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer; colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :linear_kbgyw_5_98_c62_n256, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span></code></pre></div></details><p>We can now mask this layer according to the polygon. This uses the same <code>mask!</code> method we use when masking with another layer:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer, DEU)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 661690 UInt8 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (1440, 2160)</span></span></code></pre></div><p><img src="`+l+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer; colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :linear_kbgyw_5_98_c62_n256, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span></code></pre></div></details><p>This is a much larger layer than we need! For this reason, we will trim it so that the empty areas are removed:</p><p><img src="'+p+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer); colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :linear_kbgyw_5_98_c62_n256, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span></code></pre></div></details><p>Let&#39;s now get some occurrences in the area defined by the layer boundingbox:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> taxon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Eliomys quercinus&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">presences </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    sp,</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer),</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;occurrenceStatus&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;PRESENT&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;limit&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">while</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> length</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(presences) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> count</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(presences)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    occurrences!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(presences)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><details class="details custom-block"><summary>Occurrences from a layer</summary><p>The <code>GBIF.occurrences</code> method can accept a layer as its second argument, to limit to the occurrence of a species within the bounding box of this layer. If a layer is used as the sole argument, all occurrences in the bounding box are queried.</p></details><p>We can plot the layer and the occurrences we have retrieved so far:</p><p><img src="`+h+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer); colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :linear_kbgyw_5_98_c62_n256, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(presences; color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :orange, markersize </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 4</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div></details><p>Some of these occurrences are outside of the masked region in the layer. For this reason, we will use the <em>non-mutating</em> <code>mask</code> method on the GBIF records:</p><p><img src="`+k+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">f, ax, plt </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">trim</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer); colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :linear_kbgyw_5_98_c62_n256, axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()))</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(presences, DEU); color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :orange, markersize </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 4</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidespines!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidedecorations!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span></code></pre></div></details><details class="details custom-block"><summary>A note about vectors of occurrences</summary><p>The reason why <code>mask</code> called on a GBIF result is not mutating the result is that GBIF results also store the query that was used. For this reason, it makes little sense to modify this object. The non-mutating <code>mask</code> returns a vector of GBIF records, which for most purposes can be used in-place of the result.</p></details>`,32)]))}const D=i(r,[["render",o]]);export{u as __pageData,D as default};
