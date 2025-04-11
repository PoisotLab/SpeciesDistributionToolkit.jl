import{_ as r,C as p,c as o,o as h,j as i,a,ag as n,G as t,w as l}from"./chunks/framework.CmO0B0Vo.js";const m=JSON.parse('{"title":"Explanations","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/explanations.md","filePath":"reference/sdemo/explanations.md","lastUpdated":null}'),d={name:"reference/sdemo/explanations.md"},k={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""};function A(u,s,y,C,D,f){const e=p("Badge");return h(),o("div",null,[s[14]||(s[14]=i("h1",{id:"explanations",tabindex:"-1"},[a("Explanations "),i("a",{class:"header-anchor",href:"#explanations","aria-label":'Permalink to "Explanations"'},"​")],-1)),s[15]||(s[15]=i("h2",{id:"Shapley-values",tabindex:"-1"},[a("Shapley values "),i("a",{class:"header-anchor",href:"#Shapley-values","aria-label":'Permalink to "Shapley values {#Shapley-values}"'},"​")],-1)),i("details",k,[i("summary",null,[s[0]||(s[0]=i("a",{id:"SDeMo.explain",href:"#SDeMo.explain"},[i("span",{class:"jlbinding"},"SDeMo.explain")],-1)),s[1]||(s[1]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[3]||(s[3]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">explain</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractSDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, j; observation </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> nothing</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, instances </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> nothing</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, samples </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, )</span></span></code></pre></div><p>Uses the MCMC approximation of Shapley values to provide explanations to specific predictions. The second argument <code>j</code> is the variable for which the explanation should be provided.</p><p>The <code>observation</code> keywords is a row in the <code>instances</code> dataset for which explanations must be provided. If <code>instances</code> is <code>nothing</code>, the explanations will be given on the training data.</p><p>All other keyword arguments are passed to <code>predict</code>.</p>',4)),t(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[2]||(s[2]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/explanations/shapley.jl#L51-L63",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[16]||(s[16]=i("h2",{id:"counterfactuals",tabindex:"-1"},[a("Counterfactuals "),i("a",{class:"header-anchor",href:"#counterfactuals","aria-label":'Permalink to "Counterfactuals"'},"​")],-1)),i("details",c,[i("summary",null,[s[4]||(s[4]=i("a",{id:"SDeMo.counterfactual",href:"#SDeMo.counterfactual"},[i("span",{class:"jlbinding"},"SDeMo.counterfactual")],-1)),s[5]||(s[5]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[7]||(s[7]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">counterfactual</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractSDM</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, x</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Vector{T}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, yhat, λ; maxiter</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">100</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, minvar</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">5e-5</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> Number</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates one counterfactual explanation given an input vector <code>x</code>, and a target rule to reach <code>yhat</code>. The learning rate is <code>λ</code>. The maximum number of iterations used in the Nelder-Mead algorithm is <code>maxiter</code>, and the variance improvement under which the model will stop is <code>minvar</code>. Other keywords are passed to <code>predict</code>.</p>',2)),t(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[6]||(s[6]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/explanations/counterfactual.jl#L104-L112",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[17]||(s[17]=i("h2",{id:"Partial-responses",tabindex:"-1"},[a("Partial responses "),i("a",{class:"header-anchor",href:"#Partial-responses","aria-label":'Permalink to "Partial responses {#Partial-responses}"'},"​")],-1)),i("details",g,[i("summary",null,[s[8]||(s[8]=i("a",{id:"SDeMo.partialresponse",href:"#SDeMo.partialresponse"},[i("span",{class:"jlbinding"},"SDeMo.partialresponse")],-1)),s[9]||(s[9]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[12]||(s[12]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">partialresponse</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, i</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, args</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; inflated</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This method returns the partial response of applying the trained model to a simulated dataset where all variables <em>except</em> <code>i</code> are set to their mean value. The <code>inflated</code> keywork, when set to <code>true</code>, will instead pick a random value within the range of the observations.</p><p>The different arguments that can follow the variable position are</p><ul><li><p>nothing, where the unique values for the <code>i</code>-th variable are used (sorted)</p></li><li><p>a number, in which point that many evenly spaced points within the range of the variable are used</p></li><li><p>an array, in which case each value of this array is evaluated</p></li></ul><p>All keyword arguments are passed to <code>predict</code>.</p>',5)),t(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[10]||(s[10]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/explanations/partialresponse.jl#L31-L47",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[13]||(s[13]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">partialresponse</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(model</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, i</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, j</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Integer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, s</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Tuple</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">50</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">50</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">); inflated</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>This method returns the partial response of applying the trained model to a simulated dataset where all variables <em>except</em> <code>i</code> and <code>j</code> are set to their mean value.</p><p>This function will return a grid corresponding to evenly spaced values of <code>i</code> and <code>j</code>, the size of which is given by the last argument <code>s</code> (defaults to 50 × 50).</p><p>All keyword arguments are passed to <code>predict</code>.</p>',4)),t(e,{type:"info",class:"source-link",text:"source"},{default:l(()=>s[11]||(s[11]=[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/b002e916df7995d2717b72cb33f78c79a380f95d/SDeMo/src/explanations/partialresponse.jl#L54-L66",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const v=r(d,[["render",A]]);export{m as __pageData,v as default};
