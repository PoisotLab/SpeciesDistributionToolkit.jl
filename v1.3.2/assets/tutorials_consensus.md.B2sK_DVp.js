import{_ as a,c as i,o as n,ag as e}from"./chunks/framework.DfWWDbyc.js";const t="/SpeciesDistributionToolkit.jl/v1.3.2/assets/13336180168783402446-consensus-heatmap.COQF8lLM.png",c=JSON.parse('{"title":"Creating a landcover consensus map","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/consensus.md","filePath":"tutorials/consensus.md","lastUpdated":null}'),l={name:"tutorials/consensus.md"};function p(h,s,k,r,o,d){return n(),i("div",null,s[0]||(s[0]=[e(`<h1 id="Creating-a-landcover-consensus-map" tabindex="-1">Creating a landcover consensus map <a class="header-anchor" href="#Creating-a-landcover-consensus-map" aria-label="Permalink to &quot;Creating a landcover consensus map {#Creating-a-landcover-consensus-map}&quot;">​</a></h1><p>In this vignette, we will look at the different landcover classes in Corsica. This is an opportunity to see how we can edit, mask, and aggregate data for processing.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 8.412</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 41.325</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 9.662</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 43.060</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(left = 8.412, bottom = 41.325, right = 9.662, top = 43.06)</span></span></code></pre></div><p>Defining a bounding box is important because, although we can clip any layer, the package will only <em>read</em> what is required. For large data (like landcover data), this is a significant improvement in memory footprint.</p><p>We now define our data provider, composed of a data source (<code>EarthEnv</code>) and a dataset (<code>LandCover</code>).</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">dataprovider </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(EarthEnv, LandCover)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>RasterData{EarthEnv, LandCover}(EarthEnv, LandCover)</span></span></code></pre></div><p>It is good practice to check which layers are provided:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">landcover_types </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> layers</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>12-element Vector{String}:</span></span>
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
<span class="line"><span> &quot;Open Water&quot;</span></span></code></pre></div><p>For more information, you can also refer to the URL of the original dataset:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">url</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>&quot;https://www.earthenv.org/landcover&quot;</span></span></code></pre></div><p>We can download all the layers using a list comprehension. Note that the name (<code>stack</code>) is a little misleading, as the packages have no concept of what a stack of raster is.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">stack </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(dataprovider; layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> layer, full </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> landcover_types</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">];</span></span></code></pre></div><p>We know that the last layer (<code>&quot;Open Water&quot;</code>) is a little less interesting, so we can create a mask for the pixels that are less than 100% open water.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">open_water_idx </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> findfirst</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">isequal</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Open Water&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">), landcover_types)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">open_water_mask </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> nodata</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(stack[open_water_idx], </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">100.0f0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14262 UInt8 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>We can now mask all of the rasters in the stack, to remove the open water pixels:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> i </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> eachindex</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(stack)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(stack[i], open_water_mask)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><p>At this point, we are ready to get the most important land use category for each pixel, using the <code>mosaic</code> function:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">consensus </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> mosaic</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(argmax, stack)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14262 Int64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>In order to represent the output, we will define a color palette corresponding to the different categories in our data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">landcover_colors </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#117733&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#668822&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#99BB55&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#55aa22&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#ddcc66&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#aaddcc&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#44aa88&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#88bbaa&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#bb0011&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    :aqua,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#FFEE88&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">    colorant</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;#5566AA&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">];</span></span></code></pre></div><p>We can now create our plot:</p><p><img src="`+t+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fig </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Figure</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(; size </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">900</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1000</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">panel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Axis</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    fig[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">];</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    xlabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Easting&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    ylabel </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;Northing&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    aspect </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    panel,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    consensus;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    colormap </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> landcover_colors,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">Legend</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    fig[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">],</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    [</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">PolyElement</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(; color </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> landcover_colors[i]) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> i </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> eachindex</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(landcover_colors)],</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    landcover_types;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    orientation </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :horizontal,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    nbanks </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 4</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div></details>`,30)]))}const g=a(l,[["render",p]]);export{c as __pageData,g as default};
