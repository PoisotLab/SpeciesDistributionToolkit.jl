import{_ as i,c as a,a2 as e,o as t}from"./chunks/framework.D9BeJ9z8.js";const n="/SpeciesDistributionToolkit.jl/v1.0.0/assets/3707380816797451939-histogram.lI1XJZ7T.png",l="/SpeciesDistributionToolkit.jl/v1.0.0/assets/3707380816797451939-novelty.fTuvdvX6.png",g=JSON.parse('{"title":"Calculating climate novelty","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/climatenovelty.md","filePath":"tutorials/climatenovelty.md","lastUpdated":null}'),p={name:"tutorials/climatenovelty.md"};function h(k,s,r,d,o,c){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Calculating-climate-novelty" tabindex="-1">Calculating climate novelty <a class="header-anchor" href="#Calculating-climate-novelty" aria-label="Permalink to &quot;Calculating climate novelty {#Calculating-climate-novelty}&quot;">​</a></h1><p>In this tutorial, we will download historical and projected future climate data, measure the climate novelty for each pixel, and provide a map showing this climate novelty.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><p>Accessing future data involves the <code>Dates</code> standard library, to make an explicit reference to years in the dataset.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Dates</span></span></code></pre></div><h2 id="Accessing-historical-climate-data" tabindex="-1">Accessing historical climate data <a class="header-anchor" href="#Accessing-historical-climate-data" aria-label="Permalink to &quot;Accessing historical climate data {#Accessing-historical-climate-data}&quot;">​</a></h2><p>In order to only load a reasonable amount of data, we will specify a bounding box for the area we are interested in:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 23.42</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 34.75</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 26.41</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 35.74</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 23.42, bottom = 34.75, right = 26.41, top = 35.74)</span></span></code></pre></div><p>Note that the bounding box is given in WGS84. Although layers can use any projection, we follow the GeoJSON specification and use WGS84 for point data. This includes species occurrence, and all polygons.</p><div class="tip custom-block"><p class="custom-block-title">Finding bounding boxes</p><p>The <a href="http://bboxfinder.com/" target="_blank" rel="noreferrer">bboxfinder</a> website is a really nice tool to rapidly draw and get the coordinates for a bounding box.</p></div><p>We will get the <a href="/SpeciesDistributionToolkit.jl/v1.0.0/datasets/CHELSA1/">BioClim data from CHELSA v1</a>. CHELSA v1 offers access to the 19 original bioclim variable, and their projection under a variety of CMIP5 models/scenarios. These are pretty large data, and so this operation may take a while in terms of download/read time. The first time you run this command will download the data, and the next calls will read them from disk.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, BioClim)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{CHELSA1, BioClim}(CHELSA1, BioClim)</span></span></code></pre></div><p>We can search the layer that correspond to annual precipitation and annual mean temperature in the list of provided layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layers_code </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> findall</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">-&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> contains</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(v, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Annual Mean Temperature&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">|</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> contains</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(v, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Annual Precipitation&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    layerdescriptions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{String}:</span></span>
<span class="line"><span> &quot;BIO12&quot;</span></span>
<span class="line"><span> &quot;BIO1&quot;</span></span></code></pre></div><p>The first step is quite simply to grab the reference state for the annual precipitation, by specifying the layer and the spatial extent:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> layers_code];</span></span></code></pre></div><p>Although we specificed a bounding box, the entire layer has been downloaded, so if we want to use it in another area, it will simply be read from the disk, which will be much faster.</p><p>We can have a little look at this dataset by checking the density of the values for the first layer (we can pass a layer to a Makie function directly):</p><p><img src="`+n+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">f, ax, plt </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> hist</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]; color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (:grey, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">800</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; xlabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> layerdescriptions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider)[layers_code[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]]),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    bins </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">ylims!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax; low </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hideydecorations!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ax)</span></span></code></pre></div></details><h2 id="Accessing-future-climate-data" tabindex="-1">Accessing future climate data <a class="header-anchor" href="#Accessing-future-climate-data" aria-label="Permalink to &quot;Accessing future climate data {#Accessing-future-climate-data}&quot;">​</a></h2><p>In the next step, we will download the projected climate data under RCP85. This requires setting up a projection object, which is composed of a scenario and a model. This information is used by the package to verify that this combination exists within the dataset we are working with.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">projection </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Projection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(RCP85, IPSL_CM5A_MR)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>Projection{RCP85, IPSL_CM5A_MR}(RCP85, IPSL_CM5A_MR)</span></span></code></pre></div><p>Future data are available for different years, so we will take a look at what years are available:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">available_timeperiods </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">timespans</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider, projection)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Pair{Year, Year}}:</span></span>
<span class="line"><span> Year(2041) =&gt; Year(2060)</span></span>
<span class="line"><span> Year(2061) =&gt; Year(2080)</span></span></code></pre></div><div class="tip custom-block"><p class="custom-block-title">Available scenarios and models</p><p>This website has a full description of each dataset, accessible from the top-level menu, which will list the scenarios, layers, models, etc., for each dataset.</p></div><p>If we do not specify an argument, the data retrieved will be the ones for the closest timespan. Getting the projected temperature is the <em>same</em> call as before, except we now pass an additional argument – the projection.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        dataprovider,</span></span>
<span class="line highlighted"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        projection; </span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        timespan </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> last</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(available_timeperiods),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    ) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> l </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> layers_code</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">];</span></span></code></pre></div><h2 id="Re-scaling-the-variables" tabindex="-1">Re-scaling the variables <a class="header-anchor" href="#Re-scaling-the-variables" aria-label="Permalink to &quot;Re-scaling the variables {#Re-scaling-the-variables}&quot;">​</a></h2><p>In order to compare the variables, we will first re-scale them so that they have mean zero and unit variance. More accurately, because we want to <em>compare</em> the historical and projected data, we will use the mean and standard deviation of the historical data as the baseline:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">μ </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> mean</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(historical)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">σ </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> std</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(historical)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element Vector{Float64}:</span></span>
<span class="line"><span> 135.6347881772658</span></span>
<span class="line"><span>  26.893110881710868</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">cr_historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (historical </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> μ) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> σ;</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">cr_projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (projected </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> μ) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> σ;</span></span></code></pre></div><p>Note that these operations are applied to <code>historical</code> and <code>projected</code>, which are both vectors of layers. This is because we can broadcast operations on layers as if they were regular Julia arrays.</p><h2 id="Measuring-climate-novelty" tabindex="-1">Measuring climate novelty <a class="header-anchor" href="#Measuring-climate-novelty" aria-label="Permalink to &quot;Measuring climate novelty {#Measuring-climate-novelty}&quot;">​</a></h2><p>We will use a simple measure of climate novelty, which is defined as the smallest Euclidean distance between a cell in the raster and all the possible cells in the future raster.</p><p>To have a way to store the results, we will start by making a copy of one of the input rasters:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Δclim </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> similar</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">])</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 12834 Float64 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (119, 360)</span></span></code></pre></div><p>And then, we can loop over the positions to find the minimum distance. To speed up the calculation, we will store the values of the projected layers in their own objects first:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">vals </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> values</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(cr_projected)</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> position </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> keys</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">])</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    dtemp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">][position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> vals[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.^</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 2.0</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    dprec </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (cr_historical[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">][position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.-</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> vals[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.^</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 2.0</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    Δclim[position] </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> minimum</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">sqrt</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">.(dtemp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.+</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> dprec))</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><p>Because we have stored the information about the smallest possible distance directly inside the raster, we can plot it. Large values on this map indicate that this area will experience more novel climatic conditions under the scenario/model we have specified.</p><p><img src="`+l+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig, ax, hm </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    Δclim;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :lipari,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">800</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">400</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    axis </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">Colorbar</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(fig[:, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">end</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> +</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">], hm)</span></span></code></pre></div></details>`,51)]))}const y=i(p,[["render",h]]);export{g as __pageData,y as default};
