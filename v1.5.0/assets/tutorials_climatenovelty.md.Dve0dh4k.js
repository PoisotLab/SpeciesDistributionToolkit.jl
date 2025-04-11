import{_ as i,c as a,o as n,ag as t}from"./chunks/framework.DOx8QQ6_.js";const e="/SpeciesDistributionToolkit.jl/v1.5.0/assets/3760121269360958022-histogram.Bl9UpOhA.png",l="/SpeciesDistributionToolkit.jl/v1.5.0/assets/3760121269360958022-novelty.B-2B8VG0.png",g=JSON.parse('{"title":"Calculating climate novelty","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/climatenovelty.md","filePath":"tutorials/climatenovelty.md","lastUpdated":null}'),h={name:"tutorials/climatenovelty.md"};function p(k,s,F,d,r,o){return n(),a("div",null,s[0]||(s[0]=[t(`<h1 id="Calculating-climate-novelty" tabindex="-1">Calculating climate novelty <a class="header-anchor" href="#Calculating-climate-novelty" aria-label="Permalink to &quot;Calculating climate novelty {#Calculating-climate-novelty}&quot;">​</a></h1><p>In this tutorial, we will download historical and projected future climate data, measure the climate novelty for each pixel, and provide a map showing this climate novelty.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> CairoMakie</span></span></code></pre></div><p>Accessing future data involves the <code>Dates</code> standard library, to make an explicit reference to years in the dataset.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">import</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Dates</span></span></code></pre></div><h2 id="Accessing-historical-climate-data" tabindex="-1">Accessing historical climate data <a class="header-anchor" href="#Accessing-historical-climate-data" aria-label="Permalink to &quot;Accessing historical climate data {#Accessing-historical-climate-data}&quot;">​</a></h2><p>In order to only load a reasonable amount of data, we will specify a bounding box for the area we are interested in (or, in this case, get the boundingbox from the GeoJSON polygon):</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">POL </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">openstreetmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;">&quot;Laurentides&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">spatial_extent </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">boundingbox</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(POL)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>(left = -76.14926147460938, right = -73.73014831542969, bottom = 45.44989776611328, top = 47.76457595825195)</span></span></code></pre></div><p>Note that the bounding box is given in WGS84. Although layers can use any projection, we follow the GeoJSON specification and use WGS84 for point data. This includes species occurrence, and all polygons.</p><div class="tip custom-block"><p class="custom-block-title">Finding bounding boxes</p><p>The <a href="http://bboxfinder.com/" target="_blank" rel="noreferrer">bboxfinder</a> website is a really nice tool to rapidly draw and get the coordinates for a bounding box.</p></div><p>We will get the <a href="/SpeciesDistributionToolkit.jl/v1.5.0/datasets/CHELSA2/">BioClim data from CHELSA v2</a>. CHELSA v2 offers access to the 19 original bioclim variable, and their projection under a variety of CMIP5 models/scenarios. These are pretty large data, and so this operation may take a while in terms of download/read time. The first time you run this command will download the data, and the next calls will read them from disk.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">dataprovider </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> RasterData</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(CHELSA2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> BioClim)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{CHELSA2, BioClim}(CHELSA2, BioClim)</span></span></code></pre></div><p>We can search the layer that correspond to annual precipitation and annual mean temperature in the list of provided layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">layers_code </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> findall</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    v </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">-&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> contains</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(v</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Annual Mean Temperature&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">|</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> contains</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(v</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Annual Precipitation&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    layerdescriptions</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{String}:</span></span>
<span class="line"><span> &quot;BIO12&quot;</span></span>
<span class="line"><span> &quot;BIO1&quot;</span></span></code></pre></div><p>The first step is quite simply to grab the reference state for the annual precipitation, by specifying the layer and the spatial extent:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">historical </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> l</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">for</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> l </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layers_code]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(historical</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> POL)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{SDMLayer{UInt16}}:</span></span>
<span class="line"><span> 🗺️  A 278 × 291 layer (38158 UInt16 cells)</span></span>
<span class="line"><span> 🗺️  A 278 × 291 layer (38158 UInt16 cells)</span></span></code></pre></div><p>Although we specificed a bounding box, the entire layer has been downloaded, so if we want to use it in another area, it will simply be read from the disk, which will be much faster.</p><p>We can have a little look at this dataset by checking the density of the values for the first layer (we can pass a layer to a Makie function directly):</p><p><img src="`+e+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">f</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> plt </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> hist</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    historical[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> color </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (:grey</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.5</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">800</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 300</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> xlabel </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> layerdescriptions</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider)[layers_code[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]])</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    bins </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 100</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ylims!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> low </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hideydecorations!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ax)</span></span></code></pre></div></details><h2 id="Accessing-future-climate-data" tabindex="-1">Accessing future climate data <a class="header-anchor" href="#Accessing-future-climate-data" aria-label="Permalink to &quot;Accessing future climate data {#Accessing-future-climate-data}&quot;">​</a></h2><p>In the next step, we will download the projected climate data under RCP85. This requires setting up a projection object, which is composed of a scenario and a model. This information is used by the package to verify that this combination exists within the dataset we are working with.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">projection </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Projection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(SSP370</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> GFDL_ESM4)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>Projection{SSP370, GFDL_ESM4}(SSP370, GFDL_ESM4)</span></span></code></pre></div><p>Future data are available for different years, so we will take a look at what years are available:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">available_timeperiods </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SimpleSDMDatasets</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">timespans</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> projection)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>3-element Vector{Pair{Year, Year}}:</span></span>
<span class="line"><span> Year(2011) =&gt; Year(2040)</span></span>
<span class="line"><span> Year(2041) =&gt; Year(2070)</span></span>
<span class="line"><span> Year(2071) =&gt; Year(2100)</span></span></code></pre></div><div class="tip custom-block"><p class="custom-block-title">Available scenarios and models</p><p>This website has a full description of each dataset, accessible from the top-level menu, which will list the scenarios, layers, models, etc., for each dataset.</p></div><p>If we do not specify an argument, the data retrieved will be the ones for the closest timespan. Getting the projected temperature is the <em>same</em> call as before, except we now pass additional arguments – the projection and the timespan.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">projected </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        dataprovider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line highlighted"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        projection</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        layer </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> l</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line highlighted"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        timespan </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> last</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(available_timeperiods)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    ) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">for</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> l </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> layers_code</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(projected</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> POL)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{SDMLayer{UInt16}}:</span></span>
<span class="line"><span> 🗺️  A 278 × 291 layer (38158 UInt16 cells)</span></span>
<span class="line"><span> 🗺️  A 278 × 291 layer (38158 UInt16 cells)</span></span></code></pre></div><h2 id="Re-scaling-the-variables" tabindex="-1">Re-scaling the variables <a class="header-anchor" href="#Re-scaling-the-variables" aria-label="Permalink to &quot;Re-scaling the variables {#Re-scaling-the-variables}&quot;">​</a></h2><p>In order to compare the variables, we will first re-scale them so that they have mean zero and unit variance. More accurately, because we want to <em>compare</em> the historical and projected data, we will use the mean and standard deviation of the historical data as the baseline:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">μ </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> mean</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">.(historical)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">σ </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> std</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">.(historical)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Float64}:</span></span>
<span class="line"><span> 948.131636662742</span></span>
<span class="line"><span>  11.134484440960707</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">cr_historical </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (historical </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.-</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> μ) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">./</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> σ</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">cr_projected </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (projected </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.-</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> μ) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">./</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> σ</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span></code></pre></div><p>Note that these operations are applied to <code>historical</code> and <code>projected</code>, which are both vectors of layers. This is because we can broadcast operations on layers as if they were regular Julia arrays.</p><h2 id="Measuring-climate-novelty" tabindex="-1">Measuring climate novelty <a class="header-anchor" href="#Measuring-climate-novelty" aria-label="Permalink to &quot;Measuring climate novelty {#Measuring-climate-novelty}&quot;">​</a></h2><p>We will use a simple measure of climate novelty, which is defined as the smallest Euclidean distance between a cell in the raster and all the possible cells in the future raster.</p><p>To have a way to store the results, we will start by making a copy of one of the input rasters:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Δclim </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> similar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(cr_historical[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">])</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 278 × 291 layer with 38158 Float64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>And then, we can loop over the positions to find the minimum distance. To speed up the calculation, we will store the values of the projected layers in their own objects first:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">vals </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> values</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">.(cr_projected)</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">for</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> position </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">in</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> keys</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(cr_historical[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">])</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    dtemp </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (cr_historical[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">][position] </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.-</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> vals[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.^</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 2.0</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    dprec </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (cr_historical[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">2</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">][position] </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.-</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> vals[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">2</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.^</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 2.0</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    Δclim[position] </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> minimum</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">sqrt</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">.(dtemp </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.+</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> dprec))</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">end</span></span></code></pre></div><p>Because we have stored the information about the smallest possible distance directly inside the raster, we can plot it. Large values on this map indicate that this area will experience more novel climatic conditions under the scenario/model we have specified.</p><p><img src="`+l+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">fig</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> hm </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    Δclim</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    colormap </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :tempo</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    figure </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> size </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">800</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 400</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    axis </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> aspect </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">lines!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ax</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> POL</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> color</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:black)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hidespines!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ax)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hidedecorations!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(ax)</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Colorbar</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    fig[</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 1</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    hm</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    label </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;"> &quot;Climatic novelty&quot;</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    alignmode </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Inside</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">()</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    width </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Relative</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.4</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    valign </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :bottom</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    halign </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> :left</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    tellheight </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    tellwidth </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    vertical </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div></details>`,53)]))}const B=i(h,[["render",p]]);export{g as __pageData,B as default};
