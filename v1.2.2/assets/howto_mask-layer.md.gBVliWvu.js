import{_ as n,C as p,c as h,o as k,ag as e,j as i,a,G as l}from"./chunks/framework.RaFiNGy7.js";const r="/SpeciesDistributionToolkit.jl/v1.2.2/assets/8507721197600457281-origin.MbM6lkRH.png",o="/SpeciesDistributionToolkit.jl/v1.2.2/assets/8507721197600457281-mask-interval.CRNPw7_c.png",d="/SpeciesDistributionToolkit.jl/v1.2.2/assets/8507721197600457281-mask-layer.CBD7JdWm.png",F=JSON.parse('{"title":"... mask a layer?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/mask-layer.md","filePath":"howto/mask-layer.md","lastUpdated":null}'),c={name:"howto/mask-layer.md"},g={class:"jldocstring custom-block"},y={class:"jldocstring custom-block"},A={class:"jldocstring custom-block"},C={class:"jldocstring custom-block"};function m(u,s,D,v,b,f){const t=p("Badge");return k(),h("div",null,[s[12]||(s[12]=e(`<h1 id="...-mask-a-layer?" tabindex="-1">... mask a layer? <a class="header-anchor" href="#...-mask-a-layer?" aria-label="Permalink to &quot;... mask a layer? {#...-mask-a-layer?}&quot;">​</a></h1><p>The process of <em>masking</em> refers to turning cells on a layer&#39;s grid to <em>off</em>, which will result in them being excluded from the analysis/display.</p><p>There are two ways to mask a layer – using the <code>nodata!</code> approach, and using the <code>mask!</code> approach. We use <code>nodata!</code> when working from a single layer, and <code>mask!</code> when using data stored in a second layer. Note that both approaches have a non-mutating version (<code>nodata</code> and <code>mask</code>, that return a modified copy of their layer).</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Dates, Statistics</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span></code></pre></div><p>We will illustrate both approaches using the CHELSA2 temperature data for the month of September.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">spatial_extent </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> (left </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 8.412</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, bottom </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 41.325</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, right </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 9.662</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, top </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 43.060</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">temp2 </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">        RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, AverageTemperature);</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        month </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Month</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">9</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    )</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 31559 UInt16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p><img src="`+r+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2, colormap</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:navia, axis</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(;aspect</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">())) </span><span style="--shiki-light:#939F91;--shiki-light-font-style:italic;--shiki-dark:#859289;--shiki-dark-font-style:italic;"># hide</span></span></code></pre></div></details><h2 id="Using-nodata!" tabindex="-1">Using <code>nodata!</code> <a class="header-anchor" href="#Using-nodata!" aria-label="Permalink to &quot;Using \`nodata!\` {#Using-nodata!}&quot;">​</a></h2><p>When using <code>nodata!</code>, we can either indicate a value to remove from the layer, or pass a function. For example, we can mask the layer to remove all cells where the temperature is in the upper and lower 5%:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">m, M </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Statistics</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">quantile</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">values</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2), [</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.05</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.95</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">])</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2, v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">-&gt;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> !</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(m </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> M))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 28449 UInt16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p><img src="`+o+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2, v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">-&gt;</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> !</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(m </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> v </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> M)), colormap</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:navia, axis</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(;aspect</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">())) </span><span style="--shiki-light:#939F91;--shiki-light-font-style:italic;--shiki-dark:#859289;--shiki-dark-font-style:italic;"># hide</span></span></code></pre></div></details><p>The function given as the second argument must return <code>true</code> for a point that will be excluded from the layer. In other words, this behaves as the <em>opposite</em> of <code>filter!</code>.</p><h2 id="Using-mask!" tabindex="-1">Using <code>mask!</code> <a class="header-anchor" href="#Using-mask!" aria-label="Permalink to &quot;Using \`mask!\` {#Using-mask!}&quot;">​</a></h2><p>When using <code>mask!</code>, the first layer will be modified so that only the cells that are also valued in the second layer are used. For example, we can use the fact that the CHELSA1 layers do not have values outside of land, to mask the CHELSA2 data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">temp1 </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">    SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span></span>
<span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">        RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, AverageTemperature);</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        month </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Month</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">9</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">        spatial_extent</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">    )</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 14432 Int16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2, temp1)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>SDM Layer with 14432 UInt16 cells</span></span>
<span class="line"><span>	Proj string: +proj=longlat +datum=WGS84 +no_defs</span></span>
<span class="line"><span>	Grid size: (209, 151)</span></span></code></pre></div><p><img src="`+d+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(temp2, temp1), colormap</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:navia, axis</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(;aspect</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataAspect</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">())) </span><span style="--shiki-light:#939F91;--shiki-light-font-style:italic;--shiki-dark:#859289;--shiki-dark-font-style:italic;"># hide</span></span></code></pre></div></details><h2 id="Related-documentation" tabindex="-1">Related documentation <a class="header-anchor" href="#Related-documentation" aria-label="Permalink to &quot;Related documentation {#Related-documentation}&quot;">​</a></h2>',25)),i("details",g,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SimpleSDMLayers.nodata!-howto-mask-layer",href:"#SimpleSDMLayers.nodata!-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.nodata!")],-1)),s[1]||(s[1]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer{T}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, nodata</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T}</span></span></code></pre></div><p>Changes the value of the layer representing no data. This modifies the layer passed as its first argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/SimpleSDMLayers/src/types.jl#L62-L67" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer{T}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, f)</span></span></code></pre></div><p>Removes the data matching a function</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/SimpleSDMLayers/src/types.jl#L83-L87" target="_blank" rel="noreferrer">source</a></p>',6))]),i("details",y,[i("summary",null,[s[3]||(s[3]=i("a",{id:"SimpleSDMLayers.nodata-howto-mask-layer",href:"#SimpleSDMLayers.nodata-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.nodata")],-1)),s[4]||(s[4]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">nodata</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, args</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Makes a copy and calls <code>nodata!</code> on it</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/SimpleSDMLayers/src/types.jl#L108-L112" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",A,[i("summary",null,[s[6]||(s[6]=i("a",{id:"SimpleSDMLayers.mask!-howto-mask-layer",href:"#SimpleSDMLayers.mask!-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask!")],-1)),s[7]||(s[7]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[8]||(s[8]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, template</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Updates the positions in the first layer to be those that have a value in the second layer.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/SimpleSDMLayers/src/mask.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, multipolygon</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Turns off all the cells outside the polygon (or within holes in the polygon). This modifies the object.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/src/polygons/polygons.jl#L89-L93" target="_blank" rel="noreferrer">source</a></p>',6))]),i("details",C,[i("summary",null,[s[9]||(s[9]=i("a",{id:"SimpleSDMLayers.mask-howto-mask-layer",href:"#SimpleSDMLayers.mask-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask")],-1)),s[10]||(s[10]=a()),l(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[11]||(s[11]=e('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, template</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a copy of the first layer masked according to the second layer. See also <code>mask!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/SimpleSDMLayers/src/mask.jl#L16-L20" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMLayers</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">mask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(occ</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, multipolygon</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> AsbtractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Returns a copy of the occurrences that are within the polygon.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/src/polygons/polygons.jl#L113-L117" target="_blank" rel="noreferrer">source</a></p>',6))]),s[13]||(s[13]=i("h2",{id:"A-note-about-how-this-works",tabindex:"-1"},[a("A note about how this works "),i("a",{class:"header-anchor",href:"#A-note-about-how-this-works","aria-label":'Permalink to "A note about how this works {#A-note-about-how-this-works}"'},"​")],-1)),s[14]||(s[14]=i("p",null,[a("The "),i("code",null,"SDMLayer"),a(" type stores a "),i("code",null,"BitMatrix"),a(" (in the "),i("code",null,"indices"),a(" field) that tracks which cells in the raster are visible. This costs a little more memory, but allows to rapidly turn pixels on and off.")],-1))])}const j=n(c,[["render",m]]);export{F as __pageData,j as default};
