import{_ as i,c as a,a2 as e,o as n}from"./chunks/framework.f24Mep3v.js";const t="/SpeciesDistributionToolkit.jl/previews/PR304/assets/9837309552719493241-2047381977542963546-resistance-map.BYUDlqOE.png",A=JSON.parse('{"title":"Arithmetic on layers","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/arithmetic.md","filePath":"tutorials/arithmetic.md","lastUpdated":null}'),l={name:"tutorials/arithmetic.md"};function p(h,s,k,r,d,o){return n(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Arithmetic-on-layers" tabindex="-1">Arithmetic on layers <a class="header-anchor" href="#Arithmetic-on-layers" aria-label="Permalink to &quot;Arithmetic on layers {#Arithmetic-on-layers}&quot;">​</a></h1><p>Layers can be manipulated as any other objects on which you can perform arithmetic. In other words, you can substract, add, multiply, and divide layers, either with other layers or with numbers. In this vignette, we will take a look at how this can facilitate the creation of a resistance map for functional connectivity analysis.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><p>We will work on the twelve classes of landcover provided by the <em>EarthEnv</em> data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(EarthEnv, LandCover)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{EarthEnv, LandCover}(EarthEnv, LandCover)</span></span></code></pre></div><p>In order to only read what is relevant to our illustration we will define a bounding box over Corsica.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 8.412</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 41.325</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 9.662</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 43.060</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>As a good practice, we check the names of the layers again. Note that checking the name of the layers will <em>not</em> download the data, so this may be a good time to remove some layers you are not interested in (which of course would not be a good idea for this specific application).</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">landcover_classes </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">layers</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>12-element Vector{String}:</span></span>
<span class="line"><span> &quot;Evergreen/Deciduous Needleleaf Trees&quot;</span></span>
<span class="line"><span> &quot;Evergreen Broadleaf Trees&quot;</span></span>
<span class="line"><span> &quot;Deciduous Broadleaf Trees&quot;</span></span>
<span class="line"><span> &quot;Mixed/Other Trees&quot;</span></span>
<span class="line"><span> &quot;Shrubs&quot;</span></span>
<span class="line"><span> &quot;Herbaceous Vegetation&quot;</span></span>
<span class="line"><span> &quot;Cultivated and Managed Vegetation&quot;</span></span>
<span class="line"><span> &quot;Regularly Flooded Vegetation&quot;</span></span>
<span class="line"><span> &quot;Urban/Built-up&quot;</span></span>
<span class="line"><span> &quot;Snow/Ice&quot;</span></span>
<span class="line"><span> &quot;Barren&quot;</span></span>
<span class="line"><span> &quot;Open Water&quot;</span></span></code></pre></div><p>To create a resistance map, we need to decide on a score for the resistance of each class of land use. For the sake of an hypothetical example, we will assume that the species we care about can easily traverse forested habitats, is less fond of shrubs, fields, etc., and is a poor swimmer who is afraid of cities. Think of it as your typical forestry graduate student.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">classes_resistance </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.4</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.7</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.9</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1.2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.8</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1.2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.95</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">classes_resistance </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> classes_resistance </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> sum</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(classes_resistance)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>12-element Vector{Float64}:</span></span>
<span class="line"><span> 0.013986013986013988</span></span>
<span class="line"><span> 0.013986013986013988</span></span>
<span class="line"><span> 0.013986013986013988</span></span>
<span class="line"><span> 0.027972027972027975</span></span>
<span class="line"><span> 0.05594405594405595</span></span>
<span class="line"><span> 0.06993006993006994</span></span>
<span class="line"><span> 0.0979020979020979</span></span>
<span class="line"><span> 0.1258741258741259</span></span>
<span class="line"><span> 0.16783216783216784</span></span>
<span class="line"><span> 0.1118881118881119</span></span>
<span class="line"><span> 0.16783216783216784</span></span>
<span class="line"><span> 0.13286713286713286</span></span></code></pre></div><p>The next step is to download the layers – we do so with a list comprehension, in order to get a vector of layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">landuse </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> class, full </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    class </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> landcover_classes</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">];</span></span></code></pre></div><p>The aggregation of the layers is simply ∑wᵢLᵢ, where wᵢ is the resistance of the <em>i</em>-th layer Lᵢ. In order to have the resistance layer expressed between 0 and 1, we finally call the <code>rescale!</code> method with new endpoints for the layer:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">resistance_layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    reduce</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.+</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, [landuse[i] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.*</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> classes_resistance[i] </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> i </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> eachindex</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(landuse)])</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">rescale!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(resistance_layer)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 31559 Float64 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p>The remaining step is to visualize this resistance map, and add a little colorbar to show which areas will be more difficult to cross:</p><p><img src="`+t+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">resistance_map </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    resistance_layer;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Reverse</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(:linear_protanopic_deuteranopic_kbjyw_5_95_c25_n256),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">400</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">350</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        xlabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Latitude&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        ylabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Longitude&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        title </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Movement resistance&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    ),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">Colorbar</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(resistance_map</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">figure[:, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">end</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> +</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">], resistance_map</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">plot; height </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Relative</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span></code></pre></div></details><p>This layer can then be used in landscape connectivity analyses using <em>e.g.</em> <a href="https://juliapackages.com/p/omniscape" target="_blank" rel="noreferrer">Omniscape.jl</a>.</p>`,24)]))}const g=i(l,[["render",p]]);export{A as __pageData,g as default};
