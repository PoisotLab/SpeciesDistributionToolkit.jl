import{_ as h,C as p,c as k,o as r,ag as n,j as i,G as t,a as e,w as l}from"./chunks/framework.DOx8QQ6_.js";const d="/SpeciesDistributionToolkit.jl/v1.5.0/assets/3818934971822464802-origin.MbM6lkRH.png",o="/SpeciesDistributionToolkit.jl/v1.5.0/assets/3818934971822464802-mask-interval.CRNPw7_c.png",F="/SpeciesDistributionToolkit.jl/v1.5.0/assets/3818934971822464802-mask-layer.CBD7JdWm.png",S=JSON.parse('{"title":"... mask a layer?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/mask-layer.md","filePath":"howto/mask-layer.md","lastUpdated":null}'),g={name:"howto/mask-layer.md"},y={class:"jldocstring custom-block"},B={class:"jldocstring custom-block"},c={class:"jldocstring custom-block"},m={class:"jldocstring custom-block"};function u(b,s,D,v,f,E){const a=p("Badge");return r(),k("div",null,[s[22]||(s[22]=n(`<h1 id="...-mask-a-layer?" tabindex="-1">... mask a layer? <a class="header-anchor" href="#...-mask-a-layer?" aria-label="Permalink to &quot;... mask a layer? {#...-mask-a-layer?}&quot;">​</a></h1><p>The process of <em>masking</em> refers to turning cells on a layer&#39;s grid to <em>off</em>, which will result in them being excluded from the analysis/display.</p><p>There are two ways to mask a layer – using the <code>nodata!</code> approach, and using the <code>mask!</code> approach. We use <code>nodata!</code> when working from a single layer, and <code>mask!</code> when using data stored in a second layer. Note that both approaches have a non-mutating version (<code>nodata</code> and <code>mask</code>, that return a modified copy of their layer).</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Dates</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Statistics</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> CairoMakie</span></span></code></pre></div><p>We will illustrate both approaches using the CHELSA2 temperature data for the month of September.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">spatial_extent </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> (left </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 8.412</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> bottom </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 41.325</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> right </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 9.662</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> top </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 43.060</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">temp2 </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        RasterData</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(CHELSA2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> AverageTemperature)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        month </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Month</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">9</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    )</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 31559 UInt16 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p><img src="`+d+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> colormap</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:navia</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> axis</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">aspect</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())) </span><span style="--shiki-light:#C2C3C5;--shiki-dark:#6B737C;"># hide</span></span></code></pre></div></details><h2 id="Using-nodata!" tabindex="-1">Using <code>nodata!</code> <a class="header-anchor" href="#Using-nodata!" aria-label="Permalink to &quot;Using `nodata!` {#Using-nodata!}&quot;">​</a></h2><p>When using <code>nodata!</code>, we can either indicate a value to remove from the layer, or pass a function. For example, we can mask the layer to remove all cells where the temperature is in the upper and lower 5%:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">m</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> M </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> Statistics</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">quantile</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">values</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> [</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">0.05</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 0.95</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">])</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nodata</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> v </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">-&gt;</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> !</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(m </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> v </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> M))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 28449 UInt16 cells</span></span>\n<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p><img src="'+o+`" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nodata</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> v </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">-&gt;</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;"> !</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(m </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> v </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> M))</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> colormap</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:navia</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> axis</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">aspect</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())) </span><span style="--shiki-light:#C2C3C5;--shiki-dark:#6B737C;"># hide</span></span></code></pre></div></details><p>The function given as the second argument must return <code>true</code> for a point that will be excluded from the layer. In other words, this behaves as the <em>opposite</em> of <code>filter!</code>.</p><h2 id="Using-mask!" tabindex="-1">Using <code>mask!</code> <a class="header-anchor" href="#Using-mask!" aria-label="Permalink to &quot;Using \`mask!\` {#Using-mask!}&quot;">​</a></h2><p>When using <code>mask!</code>, the first layer will be modified so that only the cells that are also valued in the second layer are used. For example, we can use the fact that the CHELSA1 layers do not have values outside of land, to mask the CHELSA2 data:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">temp1 </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">        RasterData</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(CHELSA1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> AverageTemperature)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        month </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> Month</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">9</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">        spatial_extent</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">    )</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14432 Int16 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> temp1)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 209 × 151 layer with 14432 UInt16 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p><img src="`+F+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(temp2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> temp1)</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> colormap</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:navia</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> axis</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">aspect</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DataAspect</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">())) </span><span style="--shiki-light:#C2C3C5;--shiki-dark:#6B737C;"># hide</span></span></code></pre></div></details><h2 id="Related-documentation" tabindex="-1">Related documentation <a class="header-anchor" href="#Related-documentation" aria-label="Permalink to &quot;Related documentation {#Related-documentation}&quot;">​</a></h2>',25)),i("details",y,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SimpleSDMLayers.nodata!-howto-mask-layer",href:"#SimpleSDMLayers.nodata!-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.nodata!")],-1)),s[1]||(s[1]=e()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[4]||(s[4]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nodata!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer{T}</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> nodata</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> {T}</span></span></code></pre></div><p>Changes the value of the layer representing no data. This modifies the layer passed as its first argument.</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[2]||(s[2]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/types.jl#L62-L67",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[5]||(s[5]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nodata!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer{T}</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> f)</span></span></code></pre></div><p>Removes the data matching a function</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[3]||(s[3]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/types.jl#L83-L87",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),i("details",B,[i("summary",null,[s[6]||(s[6]=i("a",{id:"SimpleSDMLayers.nodata-howto-mask-layer",href:"#SimpleSDMLayers.nodata-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.nodata")],-1)),s[7]||(s[7]=e()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[9]||(s[9]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nodata</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> args</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Makes a copy and calls <code>nodata!</code> on it</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[8]||(s[8]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/types.jl#L108-L112",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),i("details",c,[i("summary",null,[s[10]||(s[10]=i("a",{id:"SimpleSDMLayers.mask!-howto-mask-layer",href:"#SimpleSDMLayers.mask!-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask!")],-1)),s[11]||(s[11]=e()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[14]||(s[14]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> template</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Updates the positions in the first layer to be those that have a value in the second layer.</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[12]||(s[12]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/mask.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[15]||(s[15]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">SimpleSDMLayers</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> multipolygon</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Turns off all the cells outside the polygon (or within holes in the polygon). This modifies the object.</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[13]||(s[13]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/src/polygons/polygons.jl#L116-L120",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),i("details",m,[i("summary",null,[s[16]||(s[16]=i("a",{id:"SimpleSDMLayers.mask-howto-mask-layer",href:"#SimpleSDMLayers.mask-howto-mask-layer"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.mask")],-1)),s[17]||(s[17]=e()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[20]||(s[20]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(layer</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> template</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns a copy of the first layer masked according to the second layer. See also <code>mask!</code>.</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[18]||(s[18]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/mask.jl#L16-L20",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[21]||(s[21]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">SimpleSDMLayers</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mask</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(occ</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> multipolygon</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">GeoJSON.MultiPolygon</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> {T </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> AsbtractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>Returns a copy of the occurrences that are within the polygon.</p>',2)),t(a,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[19]||(s[19]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/src/polygons/polygons.jl#L144-L148",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[23]||(s[23]=i("h2",{id:"A-note-about-how-this-works",tabindex:"-1"},[e("A note about how this works "),i("a",{class:"header-anchor",href:"#A-note-about-how-this-works","aria-label":'Permalink to "A note about how this works {#A-note-about-how-this-works}"'},"​")],-1)),s[24]||(s[24]=i("p",null,[e("The "),i("code",null,"SDMLayer"),e(" type stores a "),i("code",null,"BitMatrix"),e(" (in the "),i("code",null,"indices"),e(" field) that tracks which cells in the raster are visible. This costs a little more memory, but allows to rapidly turn pixels on and off.")],-1))])}const _=h(g,[["render",u]]);export{S as __pageData,_ as default};
