import{_ as n,C as l,c as r,o as c,j as i,ag as o,a as e,G as a,w as d}from"./chunks/framework.DOx8QQ6_.js";const F=JSON.parse('{"title":"Operations on layers","description":"","frontmatter":{},"headers":[],"relativePath":"reference/layers/operations.md","filePath":"reference/layers/operations.md","lastUpdated":null}'),p={name:"reference/layers/operations.md"},g={class:"jldocstring custom-block",open:""};function k(h,s,u,m,b,f){const t=l("Badge");return c(),r("div",null,[s[4]||(s[4]=i("h1",{id:"Operations-on-layers",tabindex:"-1"},[e("Operations on layers "),i("a",{class:"header-anchor",href:"#Operations-on-layers","aria-label":'Permalink to "Operations on layers {#Operations-on-layers}"'},"​")],-1)),s[5]||(s[5]=i("div",{class:"warning custom-block"},[i("p",{class:"custom-block-title"},"Missing docstring."),i("p",null,[e("Missing docstring for "),i("code",null,"clip"),e(". Check Documenter's build log for details.")])],-1)),i("details",g,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SimpleSDMLayers.coarsen",href:"#SimpleSDMLayers.coarsen"},[i("span",{class:"jlbinding"},"SimpleSDMLayers.coarsen")],-1)),s[1]||(s[1]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[3]||(s[3]=o('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">coarsen</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(f</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> L</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDMLayer</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> mask</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">2</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;"> 2</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">))</span></span></code></pre></div><p>Coarsens a layer by collecting a sub-grid of size <code>mask</code>, and applying the function <code>f</code> to all non-empty cells within this mask. The core constraint is that <code>f</code> must take a vector and return a single element (and the size of the mask must be compatible with the size of the layer).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:d(()=>s[2]||(s[2]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/e7dc5e72676f74ea78131e083af58d7e0f5b2561/SimpleSDMLayers/src/coarsen.jl#L1-L8",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[6]||(s[6]=o('<div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>slidingwindow</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>mask</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>rescale!</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>rescale</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>mosaic</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>tile</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>tile!</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>stitch</code>. Check Documenter&#39;s build log for details.</p></div>',8))])}const B=n(p,[["render",k]]);export{F as __pageData,B as default};
