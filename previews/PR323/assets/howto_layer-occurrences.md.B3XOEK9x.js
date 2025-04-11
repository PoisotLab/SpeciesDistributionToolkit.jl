import{_ as i,c as a,a2 as e,o as t}from"./chunks/framework.BBYNtJYl.js";const n="/SpeciesDistributionToolkit.jl/previews/PR323/assets/11544692846469971887-environment.CpsAKy7-.png",h="/SpeciesDistributionToolkit.jl/previews/PR323/assets/11544692846469971887-species-map.Bju0kJeZ.png",l="/SpeciesDistributionToolkit.jl/previews/PR323/assets/11544692846469971887-final-plot.CB6w5Dy1.png",y=JSON.parse('{"title":"Layers and occurrence data","description":"","frontmatter":{},"headers":[],"relativePath":"howto/layer-occurrences.md","filePath":"howto/layer-occurrences.md","lastUpdated":null}'),p={name:"howto/layer-occurrences.md"};function k(r,s,d,A,o,g){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Layers-and-occurrence-data" tabindex="-1">Layers and occurrence data <a class="header-anchor" href="#Layers-and-occurrence-data" aria-label="Permalink to &quot;Layers and occurrence data {#Layers-and-occurrence-data}&quot;">​</a></h1><p>In this vignette, we will have a look at the ways in which occurrence data (from GBIF) and layer data can interact. In order to illustrate this, we will get information about the occurrences of <em>Sitta whiteheadi</em>, a species of bird endemic to Corsica. Finally, we will rely on the <code>Phylopic</code> package to download a silhouette of a bat to illustrate the figure.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Images</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Downloads</span></span></code></pre></div><p>This sets up a bounding box for the region of interest:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 8.412</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 41.325</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 9.662</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 43.060</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>We will get our bioclimatic variable from CHELSA:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, BioClim)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{CHELSA1, BioClim}(CHELSA1, BioClim)</span></span></code></pre></div><p>The next step is to download the layers, making sure to correct the scale of the temperature (BIO1), which is multiplied by 10 in the CHELSA raw data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">temperature </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 0.1</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;BIO1&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">precipitation </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;BIO12&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 14432 Int16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p>Once we have the layer, we can grab the occurrence data from GBIF:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">species </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> taxon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Sitta whiteheadi&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">observations </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    species,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;decimalLatitude&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">bottom, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">top),</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;decimalLongitude&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">left, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">right),</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;limit&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;occurrenceStatus&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;PRESENT&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">while</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> length</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(observations) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> count</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(observations)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    occurrences!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(observations)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><p>We can now setup a figure with the correct axes, and use the <code>layer[occurrence]</code> indexing method to extract the values from the layers at the location of each occurrence.</p><p><img src="`+n+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">figure </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Figure</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">800</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">400</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">envirovars </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    Axis</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(figure[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]; xlabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Temperature (°C)&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, ylabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Precipitation (kg×m⁻²)&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(envirovars, temperature[observations], precipitation[observations], markersize</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">6</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, color</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:black)</span></span></code></pre></div></details><p>In order to also show these on the map, we will add a simple heatmap to the left of the figure, and overlay the points using <code>longitudes</code> and <code>latitudes</code> for the observations:</p><p><img src="`+h+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spmap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Axis</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(figure[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]; aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">())</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidedecorations!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(spmap)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">hidespines!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(spmap)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(spmap, temperature; colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :heat)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(spmap, observations; color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :black, markersize</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">6</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div></details><p>We can now add a silhouette of the species using Phylopic. We only want a single item here, and the search will by default be restricted to images that can be used with the least constraints. Note that we are searching using the <code>GBIFTaxon</code> object representing our species.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp_uuid </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">imagesof</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(species; items </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>&quot;Sitta carolinensis&quot; =&gt; Base.UUID(&quot;4f24cf78-48d8-42ab-9e12-18853528c73c&quot;)</span></span></code></pre></div><p>The next step is to get the url of the image – we are going to get the largest thumbnail (which is the default):</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp_thumbnail_url </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">thumbnail</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sp_uuid)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp_thumbnail_tmp </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Downloads</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">download</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sp_thumbnail_url)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp_image </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Images</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">load</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sp_thumbnail_tmp)</span></span></code></pre></div><img src="data:image/png;base64,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"><div class="tip custom-block"><p class="custom-block-title">Credit where credit is due!</p><p>The images on Phylopic are <em>all</em> created by volunteers. It is important to provide correct credit and attribution for their work. The <code>attribution</code> method will return the name of the creator and the correct license associated to this illustration:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">attribution</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sp_uuid)</span></span></code></pre></div><div class="markdown"><p>Image of <em>Sitta carolinensis</em> provided by <a href="https://creativecommons.org/publicdomain/zero/1.0/">Andy Wilson</a></p></div></div><p>We can now use this image in a scatter plot – this uses the thumbnail as a scatter symbol, so we need to plot this like any other point. Because the thumbnail returned by default is rather large, we can rescale it based on the image size:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">sp_size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Vec2f</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">reverse</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">size</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sp_image) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">./</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>2-element GeometryBasics.Vec{2, Float32} with indices SOneTo(2):</span></span>
<span class="line"><span> 64.0</span></span>
<span class="line"><span> 64.0</span></span></code></pre></div><p>Finally, we can plot everything (note that the Phylopic images have a transparent background, so we are not hiding any information!):</p><p><img src="`+l+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">scatter!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(envirovars, [</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">], [</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">700.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]; marker </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> sp_image, markersize </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> sp_size)</span></span></code></pre></div></details>',33)]))}const C=i(p,[["render",k]]);export{y as __pageData,C as default};
