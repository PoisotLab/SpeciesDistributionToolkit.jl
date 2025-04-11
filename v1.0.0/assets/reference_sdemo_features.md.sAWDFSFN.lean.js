import{_ as n,c as o,j as e,a as i,G as t,a2 as l,B as r,o as p}from"./chunks/framework.D9BeJ9z8.js";const F=JSON.parse('{"title":"Features selection and importance","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/features.md","filePath":"reference/sdemo/features.md","lastUpdated":null}'),d={name:"reference/sdemo/features.md"},h={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""};function f(y,s,A,m,v,D){const a=r("Badge");return p(),o("div",null,[s[18]||(s[18]=e("h1",{id:"Features-selection-and-importance",tabindex:"-1"},[i("Features selection and importance "),e("a",{class:"header-anchor",href:"#Features-selection-and-importance","aria-label":'Permalink to "Features selection and importance {#Features-selection-and-importance}"'},"​")],-1)),s[19]||(s[19]=e("h2",{id:"Feature-selection",tabindex:"-1"},[i("Feature selection "),e("a",{class:"header-anchor",href:"#Feature-selection","aria-label":'Permalink to "Feature selection {#Feature-selection}"'},"​")],-1)),e("details",h,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.noselection!",href:"#SDeMo.noselection!"},[e("span",{class:"jlbinding"},"SDeMo.noselection!")],-1)),s[1]||(s[1]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">noselection!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds; verbose</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the model to the state where all variables are used.</p><p>All keyword arguments are passed to <code>train!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/selection.jl#L1-L7" target="_blank" rel="noreferrer">source</a></p>',4))]),e("details",k,[e("summary",null,[s[3]||(s[3]=e("a",{id:"SDeMo.backwardselection!",href:"#SDeMo.backwardselection!"},[e("span",{class:"jlbinding"},"SDeMo.backwardselection!")],-1)),s[4]||(s[4]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">backwardselection!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds; verbose</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, optimality</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">mcc, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Removes variables one at a time until the <code>optimality</code> measure stops increasing.</p><p>All keyword arguments are passed to <code>crossvalidate!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/selection.jl#L14-L20" target="_blank" rel="noreferrer">source</a></p>',4))]),e("details",c,[e("summary",null,[s[6]||(s[6]=e("a",{id:"SDeMo.forwardselection!",href:"#SDeMo.forwardselection!"},[e("span",{class:"jlbinding"},"SDeMo.forwardselection!")],-1)),s[7]||(s[7]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[8]||(s[8]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">forwardselection!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds, pool; verbose</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, optimality</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">mcc, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Adds variables one at a time until the <code>optimality</code> measure stops increasing. The variables in <code>pool</code> are added at the start.</p><p>All keyword arguments are passed to <code>crossvalidate!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/selection.jl#L56-L63" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">forwardselection!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds; verbose</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, optimality</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">mcc, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Adds variables one at a time until the <code>optimality</code> measure stops increasing.</p><p>All keyword arguments are passed to <code>crossvalidate!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/selection.jl#L100-L106" target="_blank" rel="noreferrer">source</a></p>',8))]),s[20]||(s[20]=e("h2",{id:"Feature-importance",tabindex:"-1"},[i("Feature importance "),e("a",{class:"header-anchor",href:"#Feature-importance","aria-label":'Permalink to "Feature importance {#Feature-importance}"'},"​")],-1)),e("details",g,[e("summary",null,[s[9]||(s[9]=e("a",{id:"SDeMo.variableimportance",href:"#SDeMo.variableimportance"},[e("span",{class:"jlbinding"},"SDeMo.variableimportance")],-1)),s[10]||(s[10]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[11]||(s[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">variableimportance</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds, variable; reps</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">10</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, optimality</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">mcc, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the importance of one variable in the model. The <code>samples</code> keyword fixes the number of bootstraps to run (defaults to <code>10</code>, which is not enough!).</p><p>The keywords are passed to <code>ConfusionMatrix</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/importance.jl#L2-L9" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">variableimportance</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model, folds; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the importance of all variables in the model. The keywords are passed to <code>variableimportance</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/importance.jl#L31-L36" target="_blank" rel="noreferrer">source</a></p>',7))]),s[21]||(s[21]=e("h2",{id:"Variance-Inflation-Factor",tabindex:"-1"},[i("Variance Inflation Factor "),e("a",{class:"header-anchor",href:"#Variance-Inflation-Factor","aria-label":'Permalink to "Variance Inflation Factor {#Variance-Inflation-Factor}"'},"​")],-1)),e("details",u,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SDeMo.stepwisevif!",href:"#SDeMo.stepwisevif!"},[e("span",{class:"jlbinding"},"SDeMo.stepwisevif!")],-1)),s[13]||(s[13]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[14]||(s[14]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">stepwisevif!</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, limit, tr</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:;kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Drops the variables with the largest variance inflation from the model, until all VIFs are under the threshold. The last positional argument (defaults to <code>:</code>) is the indices to use for the VIF calculation. All keyword arguments are passed to <code>train!</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/vif.jl#L18-L22" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",b,[e("summary",null,[s[15]||(s[15]=e("a",{id:"SDeMo.vif",href:"#SDeMo.vif"},[e("span",{class:"jlbinding"},"SDeMo.vif")],-1)),s[16]||(s[16]=i()),t(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[17]||(s[17]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">vif</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Matrix</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the variance inflation factor for each variable in a matrix, as the diagonal of the inverse of the correlation matrix between predictors.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/vif.jl#L3-L7" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">vif</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractSDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, tr</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">:)</span></span></code></pre></div><p>Returns the VIF for the variables used in a SDM, optionally restricting to some training instances (defaults to <code>:</code> for all points). The VIF is calculated on the de-meaned predictors.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/33e32f6d3f05c9157e00f3e5e1d09f6256713b84/SDeMo/src/variables/vif.jl#L10-L14" target="_blank" rel="noreferrer">source</a></p>',6))])])}const j=n(d,[["render",f]]);export{F as __pageData,j as default};
