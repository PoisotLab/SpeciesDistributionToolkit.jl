import{_ as e,c as s,a2 as i,o as a}from"./chunks/framework.Dcqa6ChI.js";const c=JSON.parse('{"title":"... get data from GBIF?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/get_gbif_data.md","filePath":"howto/get_gbif_data.md","lastUpdated":null}'),l={name:"howto/get_gbif_data.md"};function n(d,t,r,h,o,p){return a(),s("div",null,t[0]||(t[0]=[i(`<h1 id="...-get-data-from-GBIF?" tabindex="-1">... get data from GBIF? <a class="header-anchor" href="#...-get-data-from-GBIF?" aria-label="Permalink to &quot;... get data from GBIF? {#...-get-data-from-GBIF?}&quot;">​</a></h1><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> DataFrames</span></span></code></pre></div><h2 id="Identify-the-taxa" tabindex="-1">Identify the taxa <a class="header-anchor" href="#Identify-the-taxa" aria-label="Permalink to &quot;Identify the taxa {#Identify-the-taxa}&quot;">​</a></h2><p>The first step is to understand how GBIF represents the taxonomic information. The <code>taxon</code> function will take a string (or a GBIF taxonomic ID, but most people tend to call species by their names...) and return a representation of this taxon.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">species </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> taxon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Sitta whiteheadi&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>GBIF taxon -- Sitta whiteheadi</span></span></code></pre></div><p>An interesting property of the GBIF API is that it returns the full taxonomic information, so we can for example check the phylum of this species:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">species</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">phylum</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>&quot;Chordata&quot; =&gt; 44</span></span></code></pre></div><h2 id="Establish-search-parameters" tabindex="-1">Establish search parameters <a class="header-anchor" href="#Establish-search-parameters" aria-label="Permalink to &quot;Establish search parameters {#Establish-search-parameters}&quot;">​</a></h2><p>Now that we are fairly confident that we have the right animal, we can start setting up some search parameters. The search parameters are <em>not</em> given as keyword arguments, but as a vector of pairs (there is a reason, and it is not sufficiently important to spend a paragraph on at this point). We will limit our search to France and Italy (the species is endemic to Corsica), retrieve occurrences 300 at a time (the maximum allowed by the GBIF API), and only focus on georeferences observations. Of course, we only care about the places where the observations represent a <em>presence</em>, so we will use the &quot;occurrenceStatus&quot; flag to get these records only.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">query </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;hasCoordinate&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;country&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;FR&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;country&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;IT&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;limit&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 300</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">    &quot;occurrenceStatus&quot;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =&gt;</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;"> &quot;PRESENT&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>5-element Vector{Pair{String, Any}}:</span></span>
<span class="line"><span>    &quot;hasCoordinate&quot; =&gt; true</span></span>
<span class="line"><span>          &quot;country&quot; =&gt; &quot;FR&quot;</span></span>
<span class="line"><span>          &quot;country&quot; =&gt; &quot;IT&quot;</span></span>
<span class="line"><span>            &quot;limit&quot; =&gt; 300</span></span>
<span class="line"><span> &quot;occurrenceStatus&quot; =&gt; &quot;PRESENT&quot;</span></span></code></pre></div><h2 id="Query-occurrence-data" tabindex="-1">Query occurrence data <a class="header-anchor" href="#Query-occurrence-data" aria-label="Permalink to &quot;Query occurrence data {#Query-occurrence-data}&quot;">​</a></h2><p>We have enough information to start our search of occurrences:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">places </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> occurrences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(species, query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>GBIF records: downloaded 300 out of 4824</span></span></code></pre></div><p>This step is doing a few important things. First, it is using the taxon object to filter the results of the API query, so that we will only get observations associated to this taxon. Second, it is bundling the query parameters to the object, so that we can modify it with subsequent requests. Internally, it is also keeping track of the total number of results, in order to retrieve them sequentially. Retrieving results sequentially is useful if you want to perform some operations while you collet results, for example check that you have enough data, and stop querying the API.</p><p>We can count the total number of observations known to GBIF with <code>count</code>:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">count</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>4824</span></span></code></pre></div><p>Similarly, we can count how many we actually have with <code>length</code>:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">length</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>300</span></span></code></pre></div><p>The package is setup so that the entire array of observations is allocated when we establish contact with the API for the first time, but we can only view the results we have actually retrieved (this is, indeed, because the records are exposed to the user as a <code>view</code>).</p><p>As we know the current and total number of points, we can do a little looping to get all occurrences. Note that the GBIF streaming API has a hard limit at 200000 records, and that querying this amount of data using the streaming API is woefully inefficient. For data volumes above 10000 observations, the suggested solution is to rely on the download interface on GBIF.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">while</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> length</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> count</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places)</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    occurrences!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places)</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span></span></code></pre></div><h2 id="Get-information-on-occurrence-data" tabindex="-1">Get information on occurrence data <a class="header-anchor" href="#Get-information-on-occurrence-data" aria-label="Permalink to &quot;Get information on occurrence data {#Get-information-on-occurrence-data}&quot;">​</a></h2><p>When this is done, we can have a look at the countries in which the observations were made:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">sort</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">unique</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">([place</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">country </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> place </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> places]))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>1-element Vector{String}:</span></span>
<span class="line"><span> &quot;France&quot;</span></span></code></pre></div><p>We can also establish the time of the first and last observations:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">extrema</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">filter</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">ismissing, [place</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">date </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> place </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> places]))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>(DateTime(&quot;2019-07-04T09:56:09&quot;), DateTime(&quot;2024-09-14T10:25:10&quot;))</span></span></code></pre></div><p>The GBIF results can interact very seamlessly with the layer types, which is covered in other vignettes.</p><p>Finally, the package implements the interface to <em>Tables.jl</em>, so that we may write:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">fields_to_keep </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> [:key, :publishingCountry, :country, :latitude, :longitude, :date]</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">select</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(places), fields_to_keep)[</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">20</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,:]</span></span></code></pre></div><div><div style="float:left;"><span>20×6 DataFrame</span></div><div style="clear:both;"></div></div><div class="data-frame" style="overflow-x:scroll;"><table class="data-frame" style="margin-bottom:6px;"><thead><tr class="header"><th class="rowNumber" style="font-weight:bold;text-align:right;">Row</th><th style="text-align:left;">key</th><th style="text-align:left;">publishingCountry</th><th style="text-align:left;">country</th><th style="text-align:left;">latitude</th><th style="text-align:left;">longitude</th><th style="text-align:left;">date</th></tr><tr class="subheader headerLastRow"><th class="rowNumber" style="font-weight:bold;text-align:right;"></th><th title="Int64" style="text-align:left;">Int64</th><th title="String" style="text-align:left;">String</th><th title="String" style="text-align:left;">String</th><th title="Float64" style="text-align:left;">Float64</th><th title="Float64" style="text-align:left;">Float64</th><th title="Union{Missing, DateTime}" style="text-align:left;">DateTime?</th></tr></thead><tbody><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">1</td><td style="text-align:right;">4596933246</td><td style="text-align:left;">US</td><td style="text-align:left;">France</td><td style="text-align:right;">41.7587</td><td style="text-align:right;">9.36375</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">2</td><td style="text-align:right;">4881328036</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3044</td><td style="text-align:right;">8.9204</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">3</td><td style="text-align:right;">4885726743</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.312</td><td style="text-align:right;">8.93905</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">4</td><td style="text-align:right;">4887037892</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3203</td><td style="text-align:right;">8.94863</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">5</td><td style="text-align:right;">4888052469</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3188</td><td style="text-align:right;">8.95731</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">6</td><td style="text-align:right;">4891339312</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3</td><td style="text-align:right;">8.8999</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">7</td><td style="text-align:right;">4886590221</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.2988</td><td style="text-align:right;">8.91033</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">8</td><td style="text-align:right;">4891105014</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.2784</td><td style="text-align:right;">8.85528</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">9</td><td style="text-align:right;">4886317377</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3002</td><td style="text-align:right;">8.88372</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">10</td><td style="text-align:right;">4863745024</td><td style="text-align:left;">US</td><td style="text-align:left;">France</td><td style="text-align:right;">42.4634</td><td style="text-align:right;">8.99781</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">11</td><td style="text-align:right;">4887389305</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.2971</td><td style="text-align:right;">8.88541</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">12</td><td style="text-align:right;">4889179080</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3074</td><td style="text-align:right;">8.87747</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">13</td><td style="text-align:right;">4883409699</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3049</td><td style="text-align:right;">8.87542</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">14</td><td style="text-align:right;">4886570770</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3039</td><td style="text-align:right;">8.87544</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">15</td><td style="text-align:right;">4882259173</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.3067</td><td style="text-align:right;">8.87766</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">16</td><td style="text-align:right;">4881602139</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.2997</td><td style="text-align:right;">8.88174</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">17</td><td style="text-align:right;">4934243207</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">42.2846</td><td style="text-align:right;">8.92496</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">18</td><td style="text-align:right;">4883953719</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">41.7793</td><td style="text-align:right;">9.22399</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">19</td><td style="text-align:right;">4883713220</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">41.7793</td><td style="text-align:right;">9.22983</td><td style="font-style:italic;text-align:left;">missing</td></tr><tr><td class="rowNumber" style="font-weight:bold;text-align:right;">20</td><td style="text-align:right;">4881978951</td><td style="text-align:left;">NL</td><td style="text-align:left;">France</td><td style="text-align:right;">41.7809</td><td style="text-align:right;">9.22952</td><td style="font-style:italic;text-align:left;">missing</td></tr></tbody></table></div>`,39)]))}const y=e(l,[["render",n]]);export{c as __pageData,y as default};
