import{_ as o,C as r,c as p,o as d,j as s,a as t,ag as l,G as a,w as n}from"./chunks/framework.5VWB6o6B.js";const V=JSON.parse('{"title":"Features selection and importance","description":"","frontmatter":{},"headers":[],"relativePath":"reference/sdemo/features.md","filePath":"reference/sdemo/features.md","lastUpdated":null}'),h={name:"reference/sdemo/features.md"},c={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""};function v(B,e,S,T,_,j){const i=r("Badge");return d(),p("div",null,[e[40]||(e[40]=s("h1",{id:"Features-selection-and-importance",tabindex:"-1"},[t("Features selection and importance "),s("a",{class:"header-anchor",href:"#Features-selection-and-importance","aria-label":'Permalink to "Features selection and importance {#Features-selection-and-importance}"'},"​")],-1)),e[41]||(e[41]=s("h2",{id:"Feature-selection",tabindex:"-1"},[t("Feature selection "),s("a",{class:"header-anchor",href:"#Feature-selection","aria-label":'Permalink to "Feature selection {#Feature-selection}"'},"​")],-1)),s("details",c,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SDeMo.VariableSelectionStrategy",href:"#SDeMo.VariableSelectionStrategy"},[s("span",{class:"jlbinding"},"SDeMo.VariableSelectionStrategy")],-1)),e[1]||(e[1]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">VariableSelectionStrategy</span></span></code></pre></div><p>This is an abstract type to which all variable selection types belong. The variable selection methods should define a method for <code>variables!</code>, whose first argument is a model, and the second argument is a selection strategy. The third and fourth positional arguments are, respectively, a list of variables to be included, and the folds to use for cross-validation. They can be omitted and would default to no default variables, and k-fold cross-validation.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[2]||(e[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L1-L10",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",k,[s("summary",null,[e[4]||(e[4]=s("a",{id:"SDeMo.ForwardSelection",href:"#SDeMo.ForwardSelection"},[s("span",{class:"jlbinding"},"SDeMo.ForwardSelection")],-1)),e[5]||(e[5]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[7]||(e[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">ForwardSelection</span></span></code></pre></div><p>Variables are included one at a time until the performance of the models stops improving.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[6]||(e[6]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L13-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",u,[s("summary",null,[e[8]||(e[8]=s("a",{id:"SDeMo.BackwardSelection",href:"#SDeMo.BackwardSelection"},[s("span",{class:"jlbinding"},"SDeMo.BackwardSelection")],-1)),e[9]||(e[9]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">ForwardSelection</span></span></code></pre></div><p>Variables are removed one at a time until the performance of the models stops improving.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[10]||(e[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L21-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",b,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SDeMo.AllVariables",href:"#SDeMo.AllVariables"},[s("span",{class:"jlbinding"},"SDeMo.AllVariables")],-1)),e[13]||(e[13]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[15]||(e[15]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AllVariables</span></span></code></pre></div><p>All variables in the training dataset are used. Note that this also crossvalidates and trains the model.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[14]||(e[14]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L29-L34",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",f,[s("summary",null,[e[16]||(e[16]=s("a",{id:"SDeMo.VarianceInflationFactor",href:"#SDeMo.VarianceInflationFactor"},[s("span",{class:"jlbinding"},"SDeMo.VarianceInflationFactor")],-1)),e[17]||(e[17]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[19]||(e[19]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">VarianceInflationFactor{N}</span></span></code></pre></div><p>Removes variables one at a time until the largest VIF is lower than <code>N</code> (a floating point number), or the performancde of the model stops increasing. Note that the resulting set of variables may have a largest VIF larger than the threshold. See <code>StrictVarianceInflationFactor</code> for an alternative.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[18]||(e[18]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L37-L44",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",F,[s("summary",null,[e[20]||(e[20]=s("a",{id:"SDeMo.StrictVarianceInflationFactor",href:"#SDeMo.StrictVarianceInflationFactor"},[s("span",{class:"jlbinding"},"SDeMo.StrictVarianceInflationFactor")],-1)),e[21]||(e[21]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[23]||(e[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">StrictVarianceInflationFactor{N}</span></span></code></pre></div><p>Removes variables one at a time until the largest VIF is lower than <code>N</code> (a floating point number). By contrast with <code>VarianceInflationFactor</code>, this approach to variable selection will <em>not</em> cross-validate the model, and might result in a model that is far worse than any other variable selection technique.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[22]||(e[22]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/varsel.jl#L47-L54",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[42]||(e[42]=s("h2",{id:"Feature-importance",tabindex:"-1"},[t("Feature importance "),s("a",{class:"header-anchor",href:"#Feature-importance","aria-label":'Permalink to "Feature importance {#Feature-importance}"'},"​")],-1)),s("details",g,[s("summary",null,[e[24]||(e[24]=s("a",{id:"SDeMo.variableimportance",href:"#SDeMo.variableimportance"},[s("span",{class:"jlbinding"},"SDeMo.variableimportance")],-1)),e[25]||(e[25]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[28]||(e[28]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">variableimportance</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(model</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> folds</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> variable</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> reps</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#1976D2;--shiki-dark:#F8F8F8;">10</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> optimality</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">mcc</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the importance of one variable in the model. The <code>samples</code> keyword fixes the number of bootstraps to run (defaults to <code>10</code>, which is not enough!).</p><p>The keywords are passed to <code>ConfusionMatrix</code>.</p>',3)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[26]||(e[26]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/importance.jl#L2-L9",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[29]||(e[29]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">variableimportance</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(model</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> folds</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the importance of all variables in the model. The keywords are passed to <code>variableimportance</code>.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[27]||(e[27]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/importance.jl#L31-L36",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[43]||(e[43]=s("h2",{id:"Variance-Inflation-Factor",tabindex:"-1"},[t("Variance Inflation Factor "),s("a",{class:"header-anchor",href:"#Variance-Inflation-Factor","aria-label":'Permalink to "Variance Inflation Factor {#Variance-Inflation-Factor}"'},"​")],-1)),s("details",m,[s("summary",null,[e[30]||(e[30]=s("a",{id:"SDeMo.stepwisevif!",href:"#SDeMo.stepwisevif!"},[s("span",{class:"jlbinding"},"SDeMo.stepwisevif!")],-1)),e[31]||(e[31]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[33]||(e[33]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">stepwisevif!</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(model</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">SDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> limit</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> tr</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">;</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">kwargs</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">...</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Drops the variables with the largest variance inflation from the model, until all VIFs are under the threshold. The last positional argument (defaults to <code>:</code>) is the indices to use for the VIF calculation. All keyword arguments are passed to <code>train!</code>.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[32]||(e[32]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/vif.jl#L18-L22",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",y,[s("summary",null,[e[34]||(e[34]=s("a",{id:"SDeMo.vif",href:"#SDeMo.vif"},[s("span",{class:"jlbinding"},"SDeMo.vif")],-1)),e[35]||(e[35]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[38]||(e[38]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">vif</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Matrix</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the variance inflation factor for each variable in a matrix, as the diagonal of the inverse of the correlation matrix between predictors.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[36]||(e[36]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/vif.jl#L3-L7",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[39]||(e[39]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">vif</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractSDM</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> tr</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">:)</span></span></code></pre></div><p>Returns the VIF for the variables used in a SDM, optionally restricting to some training instances (defaults to <code>:</code> for all points). The VIF is calculated on the de-meaned predictors.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:n(()=>e[37]||(e[37]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/SDeMo/src/variables/vif.jl#L10-L14",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const C=o(h,[["render",v]]);export{V as __pageData,C as default};
