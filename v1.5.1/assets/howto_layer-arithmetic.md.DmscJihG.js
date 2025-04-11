import{_ as i,c as a,o as n,ag as e}from"./chunks/framework.DJWGqVem.js";const t="/SpeciesDistributionToolkit.jl/v1.5.1/assets/2574295142017526939-resistance-map.E8sjqXvx.png",c=JSON.parse('{"title":"Arithmetic on layers","description":"","frontmatter":{},"headers":[],"relativePath":"howto/layer-arithmetic.md","filePath":"howto/layer-arithmetic.md","lastUpdated":null}'),l={name:"howto/layer-arithmetic.md"};function p(h,s,k,r,F,d){return n(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Arithmetic-on-layers" tabindex="-1">Arithmetic on layers <a class="header-anchor" href="#Arithmetic-on-layers" aria-label="Permalink to &quot;Arithmetic on layers {#Arithmetic-on-layers}&quot;">​</a></h1><p>Layers can be manipulated as any other objects on which you can perform arithmetic. In other words, you can substract, add, multiply, and divide layers, either with other layers or with numbers. In this vignette, we will take a look at how this can facilitate the creation of a resistance map for functional connectivity analysis.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> CairoMakie</span></span></code></pre></div><p>We will work on the twelve classes of landcover provided by the <em>EarthEnv</em> data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">dataprovider </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> RasterData</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(EarthEnv</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> LandCover)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{EarthEnv, LandCover}(EarthEnv, LandCover)</span></span></code></pre></div><p>In order to only read what is relevant to our illustration we will define a bounding box over Corsica.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">spatial_extent </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (left </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 8.412</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> bottom </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 41.325</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> right </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 9.662</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> top </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 43.060</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>As a good practice, we check the names of the layers again. Note that checking the name of the layers will <em>not</em> download the data, so this may be a good time to remove some layers you are not interested in (which of course would not be a good idea for this specific application).</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">landcover_classes </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SimpleSDMDatasets</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">layers</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>12-element Vector{String}:</span></span>
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
<span class="line"><span> &quot;Open Water&quot;</span></span></code></pre></div><p>To create a resistance map, we need to decide on a score for the resistance of each class of land use. For the sake of an hypothetical example, we will assume that the species we care about can easily traverse forested habitats, is less fond of shrubs, fields, etc., and is a poor swimmer who is afraid of cities. Think of it as your typical forestry graduate student.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">classes_resistance </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.4</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.5</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.7</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.9</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1.2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.8</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1.2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.95</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">classes_resistance </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> classes_resistance </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">./</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> sum</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(classes_resistance)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>12-element Vector{Float64}:</span></span>
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
<span class="line"><span> 0.13286713286713286</span></span></code></pre></div><p>The next step is to download the layers – we do so with a list comprehension, in order to get a vector of layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">landuse </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> class</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> full </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">for</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    class </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> landcover_classes</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span></code></pre></div><p>The aggregation of the layers is simply ∑wᵢLᵢ, where wᵢ is the resistance of the <em>i</em>-th layer Lᵢ. In order to have the resistance layer expressed between 0 and 1, we finally call the <code>rescale!</code> method with new endpoints for the layer:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">resistance_layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    reduce</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.+</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [landuse[i] </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.*</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> classes_resistance[i] </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">for</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> i </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> eachindex</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(landuse)])</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">rescale!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(resistance_layer)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 31559 Float64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>The remaining step is to visualize this resistance map, and add a little colorbar to show which areas will be more difficult to cross:</p><p><img src="`+t+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">resistance_map </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    resistance_layer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colormap </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Reverse</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(:linear_protanopic_deuteranopic_kbjyw_5_95_c25_n256)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">400</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 350</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        aspect </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">()</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        xlabel </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Latitude&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        ylabel </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Longitude&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        title </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Movement resistance&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    )</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Colorbar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(resistance_map</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">figure[:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> end</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> resistance_map</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">plot</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> height </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Relative</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.5</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span></span></code></pre></div></details><p>This layer can then be used in landscape connectivity analyses using <em>e.g.</em> <a href="https://juliapackages.com/p/omniscape" target="_blank" rel="noreferrer">Omniscape.jl</a>.</p>`,24)]))}const B=i(l,[["render",p]]);export{c as __pageData,B as default};
