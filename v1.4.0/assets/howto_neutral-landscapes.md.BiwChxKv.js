import{_ as a,c as e,o as i,ag as t}from"./chunks/framework.CmO0B0Vo.js";const n="/SpeciesDistributionToolkit.jl/v1.4.0/assets/1848582047269476166-diamondsquare.C07UD0xZ.png",u=JSON.parse('{"title":"Creating neutral landscapes","description":"","frontmatter":{},"headers":[],"relativePath":"howto/neutral-landscapes.md","filePath":"howto/neutral-landscapes.md","lastUpdated":null}'),l={name:"howto/neutral-landscapes.md"};function p(r,s,o,d,h,c){return i(),e("div",null,s[0]||(s[0]=[t(`<h1 id="Creating-neutral-landscapes" tabindex="-1">Creating neutral landscapes <a class="header-anchor" href="#Creating-neutral-landscapes" aria-label="Permalink to &quot;Creating neutral landscapes {#Creating-neutral-landscapes}&quot;">​</a></h1><p>The purpose of this vignette is to demonstrate how we can use the <code>NeutralLandscapes</code> package to generate random spatial structures.</p><p>This functionality is supported through an extension, which is only active when the <code>NeutralLandscapes</code> package is loaded.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-highlighted vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> CairoMakie</span></span>
<span class="line highlighted"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> NeutralLandscapes </span></span></code></pre></div><p>This is simply achieved through an overload of the <code>SDMLayer</code> constructor, taking a neutral landscape maker, and a size:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">L </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DiamondSquare</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(), (</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>🗺️  A 100 × 100 layer with 10000 Float64 cells</span></span>
<span class="line"><span>   Projection: +proj=longlat +datum=WGS84 +no_defs</span></span></code></pre></div><p><img src="`+n+'" alt=""></p><details class="details custom-block"><summary>Code for the figure</summary><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">heatmap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(L)</span></span></code></pre></div></details><p>If we have a layer already, it can be used in place of the size argument, in which case the mask of the layer is also preserved. This is useful to rapidly fill layers with the same structure with random data.</p><p>Finally, the <code>SDMLayer</code> constructor, when used this way, accepts keyword arguments like the <code>crs</code> of the layer, as well as its <code>x</code> and <code>y</code> fields.</p>',11)]))}const g=a(l,[["render",p]]);export{u as __pageData,g as default};
