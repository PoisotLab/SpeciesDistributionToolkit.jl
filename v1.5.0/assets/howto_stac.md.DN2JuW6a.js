import{_ as i,c as a,o as t,ag as e}from"./chunks/framework.DOx8QQ6_.js";const n="/SpeciesDistributionToolkit.jl/v1.5.0/assets/7525094332034215464-ghmts.CqY_aSqK.png",g=JSON.parse('{"title":"Getting data from a STAC catalogue","description":"","frontmatter":{},"headers":[],"relativePath":"howto/stac.md","filePath":"howto/stac.md","lastUpdated":null}'),h={name:"howto/stac.md"};function l(p,s,k,o,r,F){return t(),a("div",null,s[0]||(s[0]=[e(`<h1 id="Getting-data-from-a-STAC-catalogue" tabindex="-1">Getting data from a STAC catalogue <a class="header-anchor" href="#Getting-data-from-a-STAC-catalogue" aria-label="Permalink to &quot;Getting data from a STAC catalogue {#Getting-data-from-a-STAC-catalogue}&quot;">​</a></h1><p>The purpose of this vignette is to demonstrate how we can use the <code>STAC</code> package to get data from STAC services.</p><p>This functionality is supported through an extension, which is only active when the <code>STAC</code> package is loaded.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> CairoMakie</span></span>
<span class="line highlighted"><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> STAC </span></span></code></pre></div><p>The support is currently very bare-bones, and can return a layer when given an asset. To demonstrate, we will get the time to the nearest city (in minutes) from the BON in a Box STAC catalogue:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">biab </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> STAC</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Catalog</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;">&quot;https://stac.geobon.org/&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">access </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> biab[</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;">&quot;accessibility_to_cities&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">items[</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;">&quot;accessibility&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">assets[</span><span style="--shiki-light:#22863A;--shiki-dark:#FFAB70;">&quot;data&quot;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">]</span></span>
<span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">L </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> SDMLayer</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(access</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> left</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=-</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">76.0</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> right</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=-</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">72.0</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> bottom</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">45.1</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> top</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">47.5</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 288 × 481 layer with 136513 Int32 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p>Note that the first argument is a STAC asset, but the usual keywords arguments to crop a layer apply here. The ability to crop is important, because the STAC layers can be very, very large. Information about the resolution and extent of the assets is provided by the STAC catalogue / API.</p><p>Most public STAC instances are available through the <a href="./stacindex.org">stacindex.org</a> website.</p><p>We can visualize the resulting layer:</p><p><img src="`+n+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">heatmap</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(L</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> colormap</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:tempo)</span></span></code></pre></div></details>',12)]))}const c=i(h,[["render",l]]);export{g as __pageData,c as default};
