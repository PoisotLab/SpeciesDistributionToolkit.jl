import{_ as i,c as a,o as t,ag as n}from"./chunks/framework.DOx8QQ6_.js";const e="/SpeciesDistributionToolkit.jl/v1.5.0/assets/16764144180516042636-zscore.ANsdY8mZ.png",h="/SpeciesDistributionToolkit.jl/v1.5.0/assets/16764144180516042636-rescale.BOPd04oG.png",l="/SpeciesDistributionToolkit.jl/v1.5.0/assets/16764144180516042636-quantize.DSjHIELQ.png",y=JSON.parse('{"title":"Statistics on layers","description":"","frontmatter":{},"headers":[],"relativePath":"howto/layer-statistics.md","filePath":"howto/layer-statistics.md","lastUpdated":null}'),p={name:"howto/layer-statistics.md"};function k(F,s,d,r,B,o){return t(),a("div",null,s[0]||(s[0]=[n(`<h1 id="Statistics-on-layers" tabindex="-1">Statistics on layers <a class="header-anchor" href="#Statistics-on-layers" aria-label="Permalink to &quot;Statistics on layers {#Statistics-on-layers}&quot;">​</a></h1><p>The purpose of this vignette is to demonstrate how we can use common statistical functions on layers.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">import</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> StatsBase</span></span></code></pre></div><p>In this tutorial, we will have a look at the ways to transform layers and apply some functions from <code>Statistics</code>. As an illustration, we will produce a map of suitability for <em>Sitta whiteheadi</em> based on temperature and precipitation. As with other vignettes, we will define a bounding box encompassing out region of interest:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">spatial_extent </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (left </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 8.412</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> bottom </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 41.325</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> right </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 9.662</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> top </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 43.060</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>We will get our layers from CHELSA1. Because these layers are returned as <code>UInt16</code>, we multiply them by a float to get <code>Float64</code> layers.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">dataprovider </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> RasterData</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(CHELSA1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> BioClim)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">temperature </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.1</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;BIO1&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">precipitation </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1.0</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;BIO12&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14432 Float64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>A large number of functions from <code>Statistics</code> have overloads to be applied directly to the layers. We can get the mean temperature:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mean</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temperature)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>13.537673226163962</span></span></code></pre></div><p>Likewise, we can get the standard deviation:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">std</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temperature)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>3.18348206205476</span></span></code></pre></div><p>Because of the way layers support arithmetic operations, we can esasily get the z-score of temperature as a layer:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">z_temperature </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (temperature </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> mean</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temperature)) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">/</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> std</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temperature)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14432 Float64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>This can be plotted. Note that we do not need to do anything on the layer itself, since the package comes pre-loaded with <code>Makie</code> recipes. This will be very useful when we start using <code>GeoMakie</code> axes to incorporate projections into our figures (which we will not do here...).</p><p><img src="`+e+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">fig</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    z_temperature</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colormap </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :broc</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colorrange </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 2</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">800</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 400</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> aspect </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Colorbar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(fig[:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> end</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm)</span></span></code></pre></div></details><p>Another option to modify the layers is to use the <code>rescale</code> method. When given two values, it will rescale the layer to be between these two values. This is useful if you want to bring a series of arbitrary values to some interval. As before, note that we can directly pass the GBIF object to <code>scatter</code> to show it on a map:</p><p><img src="`+h+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">fig</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    rescale</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(precipitation</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.0</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1.0</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colormap </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :bamako</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">800</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 400</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> aspect </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Colorbar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(fig[:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> end</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm)</span></span></code></pre></div></details><p>To get a little more insights about the distribution of precipitation, we can look at the quantiles, given by the <code>quantize</code> function:</p><p><img src="`+l+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">fig</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    quantize</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(precipitation</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 5</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colormap </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :bamako</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">800</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 400</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> aspect </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Colorbar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(fig[:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> end</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm)</span></span></code></pre></div></details><p>The <code>quantile</code> function also has an overload, and so we can get the 5th and 95th percentiles of the distribution in the layer:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">quantile</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temperature</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.05</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.95</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">])</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Float64}:</span></span>
<span class="line"><span>  7.055000000000007</span></span>
<span class="line"><span> 17.0</span></span></code></pre></div>`,30)]))}const c=i(p,[["render",k]]);export{y as __pageData,c as default};
