import{_ as o,C as r,c as p,o as d,j as e,a,ag as n,G as t,w as l}from"./chunks/framework.CmO0B0Vo.js";const T=JSON.parse('{"title":"Ensembles","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/ensembles.md","filePath":"reference/sdemo/ensembles.md","lastUpdated":null}'),b={name:"reference/sdemo/ensembles.md"},k={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function f(m,s,A,y,D,C){const i=r("Badge");return d(),p("div",null,[s[22]||(s[22]=e("h1",{id:"ensembles",tabindex:"-1"},[a("Ensembles "),e("a",{class:"header-anchor",href:"#ensembles","aria-label":'Permalink to "Ensembles"'},"​")],-1)),s[23]||(s[23]=e("h2",{id:"bagging",tabindex:"-1"},[a("Bagging "),e("a",{class:"header-anchor",href:"#bagging","aria-label":'Permalink to "Bagging"'},"​")],-1)),e("details",k,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SDeMo.Bagging",href:"#SDeMo.Bagging"},[e("span",{class:"jlbinding"},"SDeMo.Bagging")],-1)),s[1]||(s[1]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[3]||(s[3]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Bagging</span></span></code></pre></div>',1)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/ensembles/bagging.jl#L25-L27",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",g,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SDeMo.outofbag",href:"#SDeMo.outofbag"},[e("span",{class:"jlbinding"},"SDeMo.outofbag")],-1)),s[5]||(s[5]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[7]||(s[7]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">outofbag</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(ensemble</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bagging</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This method returns the confusion matrix associated to the out of bag error, wherein the succes in predicting instance <em>i</em> is calculated on the basis of all models that have not been trained on <em>i</em>. The consensus of the different models is a simple majority rule.</p><p>The additional keywords arguments are passed to <code>predict</code>.</p>',3)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/ensembles/bagging.jl#L53-L62",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",h,[e("summary",null,[s[8]||(s[8]=e("a",{id:"SDeMo.bootstrap",href:"#SDeMo.bootstrap"},[e("span",{class:"jlbinding"},"SDeMo.bootstrap")],-1)),s[9]||(s[9]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[12]||(s[12]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">bootstrap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(y, X; n </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 50</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div>',1)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[10]||(s[10]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/ensembles/bagging.jl#L1-L3",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[13]||(s[13]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">bootstrap</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(sdm</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">SDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div>',1)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[11]||(s[11]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/ensembles/bagging.jl#L18-L20",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",u,[e("summary",null,[s[14]||(s[14]=e("a",{id:"SDeMo.iqr",href:"#SDeMo.iqr"},[e("span",{class:"jlbinding"},"SDeMo.iqr")],-1)),s[15]||(s[15]=a()),t(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[17]||(s[17]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">iqr</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(x, m</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.25</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, M</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">0.75</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the inter-quantile range, by default between 25% and 75% of observations.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[16]||(s[16]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/utilities/varia.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[24]||(s[24]=e("h2",{id:"Heterogeneous-ensembles",tabindex:"-1"},[a("Heterogeneous ensembles "),e("a",{class:"header-anchor",href:"#Heterogeneous-ensembles","aria-label":'Permalink to "Heterogeneous ensembles {#Heterogeneous-ensembles}"'},"​")],-1)),e("details",c,[e("summary",null,[s[18]||(s[18]=e("a",{id:"SDeMo.Ensemble",href:"#SDeMo.Ensemble"},[e("span",{class:"jlbinding"},"SDeMo.Ensemble")],-1)),s[19]||(s[19]=a()),t(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[21]||(s[21]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Ensemble</span></span></code></pre></div><p>An heterogeneous ensemble model is defined as a vector of <code>SDM</code>s.</p>',2)),t(i,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[20]||(s[20]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/ensembles/ensemble.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const j=o(b,[["render",f]]);export{T as __pageData,j as default};
