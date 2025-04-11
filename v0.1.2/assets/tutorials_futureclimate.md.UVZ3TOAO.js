import{_ as i,c as a,a2 as e,o as t}from"./chunks/framework.G4oTIJGH.js";const n="/SpeciesDistributionToolkit.jl/v0.1.2/assets/11843617811667199464-7177860769672244951-histogram.B2Xq99w_.png",l="/SpeciesDistributionToolkit.jl/v0.1.2/assets/11843617811667199464-7177860769672244951-novelty.CT5a-0Gc.png",g=JSON.parse('{"title":"Future climate data","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/futureclimate.md","filePath":"tutorials/futureclimate.md","lastUpdated":null}'),p={name:"tutorials/futureclimate.md"};function h(k,s,r,d,o,c){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Future-climate-data" tabindex="-1">Future climate data <a class="header-anchor" href="#Future-climate-data" aria-label="Permalink to &quot;Future climate data {#Future-climate-data}&quot;">​</a></h1><p>In this tutorial, we will download historical and projected future climate data, measure the climate novelty for each pixel, and provide a map showing this climate novelty.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Dates</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><h2 id="Accessing-historical-climate-data" tabindex="-1">Accessing historical climate data <a class="header-anchor" href="#Accessing-historical-climate-data" aria-label="Permalink to &quot;Accessing historical climate data {#Accessing-historical-climate-data}&quot;">​</a></h2><p>As with other tutorials, we will define a bounding box encompassing out region of interest:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 8.412</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 41.325</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 9.662</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 43.060</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>We will get the <a href="/SpeciesDistributionToolkit.jl/v0.1.2/datasets/CHELSA1/BioClim">BioClim data from CHELSA v1</a>. CHELSA v1 offers access to the 19 original bioclim variable, and their projection under a variety of CMIP5 models/scenarios. These are pretty large data, and so this operation may take a while in terms of download/read time. The first time you run this command will download the data, and the next calls will read them from disk.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, BioClim)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{CHELSA1, BioClim}(CHELSA1, BioClim)</span></span></code></pre></div><p>We can search the layer that correspond to annual precipitation and annual mean temperature in the list of provided layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layers_code </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> findall</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">-&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> contains</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(v, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Annual Mean Temperature&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">|</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> contains</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(v, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Annual Precipitation&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    layerdescriptions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{String}:</span></span>
<span class="line"><span> &quot;BIO12&quot;</span></span>
<span class="line"><span> &quot;BIO1&quot;</span></span></code></pre></div><p>The first step is quite simply to grab the reference state for the annual precipitation, by specifying the layer and the spatial extent:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">l, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> layers_code];</span></span></code></pre></div><p>We can have a little look at this dataset by checking the density of the values for the first layer (we can pass a layer to a Makie function directly):</p><p><img src="`+n+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]; color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (:grey, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">800</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; xlabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> layerdescriptions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider)[layers_code[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]]),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    bins </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div></details><h2 id="Accessing-future-climate-data" tabindex="-1">Accessing future climate data <a class="header-anchor" href="#Accessing-future-climate-data" aria-label="Permalink to &quot;Accessing future climate data {#Accessing-future-climate-data}&quot;">​</a></h2><p>In the next step, we will download the projected climate data under RCP26. This requires setting up a projection object, which is composed of a scenario and a model. This information is used by the package to verify that this combination exists within the dataset we are working with.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">projection </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Projection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(RCP85, IPSL_CM5A_MR)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>Projection{RCP85, IPSL_CM5A_MR}(RCP85, IPSL_CM5A_MR)</span></span></code></pre></div><p>Future data are available for different years, so we will take a look at what years are available:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">available_timeperiods </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">timespans</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider, projection)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Pair{Year, Year}}:</span></span>
<span class="line"><span> Year(2041) =&gt; Year(2060)</span></span>
<span class="line"><span> Year(2061) =&gt; Year(2080)</span></span></code></pre></div><p>If we do not specify an argument, the data retrieved will be the ones for the closest timespan. Getting the projected temperature is the <em>same</em> call as before, except we now pass an additional argument – the projection.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    dataprovider,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    projection;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">l,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    timespan </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> last</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(available_timeperiods),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> layers_code];</span></span></code></pre></div><h2 id="Re-scaling-the-variables" tabindex="-1">Re-scaling the variables <a class="header-anchor" href="#Re-scaling-the-variables" aria-label="Permalink to &quot;Re-scaling the variables {#Re-scaling-the-variables}&quot;">​</a></h2><p>In order to compare the variables, we will first re-scale them so that they have mean zero and unit variance. More accurately, because we want to <em>compare</em> the historical and projected data, we will use the mean and standard deviation of the historical data as the baseline:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">μ </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> mean</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(historical)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">σ </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> std</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(historical)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Float64}:</span></span>
<span class="line"><span> 153.2707495211677</span></span>
<span class="line"><span>  31.834820620547557</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">cr_historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> μ) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> σ;</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">cr_projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> μ) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> σ;</span></span></code></pre></div><h2 id="Measuring-climate-novelty" tabindex="-1">Measuring climate novelty <a class="header-anchor" href="#Measuring-climate-novelty" aria-label="Permalink to &quot;Measuring climate novelty {#Measuring-climate-novelty}&quot;">​</a></h2><p>We will use a simple measure of climate novelty, which is defined as the smallest Euclidean distance between a cell in the raster and all the possible cells in the future raster.</p><p>To have a way to store the results, we will start by making a copy of one of the input rasters:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Δclim </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> similar</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">])</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 14432 Float64 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p>And then, we can loop over the positions to find the minimum distance:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> position </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> keys</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">])</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    dtemp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">][position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> values</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_projected[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]))</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.^</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2.0</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    dprec </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">][position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> values</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_projected[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]))</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.^</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2.0</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    Δclim[position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> minimum</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">sqrt</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(dtemp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.+</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> dprec))</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><p>Because we have stored this information directly inside the raster, we can plot it:</p><p><img src="`+l+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig, ax, hm </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    Δclim;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :lipari,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">800</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">400</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">Colorbar</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(fig[:, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">end</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> +</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">], hm)</span></span></code></pre></div></details>`,43)]))}const C=i(p,[["render",h]]);export{g as __pageData,C as default};
