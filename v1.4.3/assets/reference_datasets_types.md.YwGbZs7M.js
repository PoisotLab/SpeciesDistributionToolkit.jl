import{_ as n,C as p,c as r,o as d,ag as l,j as e,G as a,a as i,w as o}from"./chunks/framework.CPZFeiPD.js";const X=JSON.parse('{"title":"Type system for datasets","description":"","frontmatter":{},"headers":[],"relativePath":"reference/datasets/types.md","filePath":"reference/datasets/types.md","lastUpdated":null}'),m={name:"reference/datasets/types.md"},b={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},M={class:"jldocstring custom-block",open:""},P={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},L={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},x={class:"jldocstring custom-block",open:""},R={class:"jldocstring custom-block",open:""},E={class:"jldocstring custom-block",open:""},V={class:"jldocstring custom-block",open:""},I={class:"jldocstring custom-block",open:""},B={class:"jldocstring custom-block",open:""},N={class:"jldocstring custom-block",open:""},w={class:"jldocstring custom-block",open:""},O={class:"jldocstring custom-block",open:""};function H(W,s,q,$,z,G){const t=p("Badge");return d(),r("div",null,[s[116]||(s[116]=l('<h1 id="Type-system-for-datasets" tabindex="-1">Type system for datasets <a class="header-anchor" href="#Type-system-for-datasets" aria-label="Permalink to &quot;Type system for datasets {#Type-system-for-datasets}&quot;">​</a></h1><p>Note that all datasets <strong>must</strong> be a direct subtype of <code>RasterDataset</code>, all providers <strong>must</strong> be a direct subtype of <code>RasterProvider</code>, all scenarios <strong>must</strong> be a direct subtype of <code>FutureScenario</code>, and all models <strong>must</strong> be a direct subtype of <code>FutureModel</code>. If you need to aggregate multiple models within a type (<em>e.g.</em> <code>CMIP6Scenarios</code>), use a <code>Union</code> type. The reason for this convention is that in interactive mode, <code>subtype</code> will let users pick the data combination they want.</p><h2 id="Type-system-overview" tabindex="-1">Type system overview <a class="header-anchor" href="#Type-system-overview" aria-label="Permalink to &quot;Type system overview {#Type-system-overview}&quot;">​</a></h2>',3)),e("details",b,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SimpleSDMDatasets.RasterData",href:"#SimpleSDMDatasets.RasterData"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterData")],-1)),s[1]||(s[1]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[3]||(s[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterData{P </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> RasterProvider</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> D </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> RasterDataset</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>The <code>RasterData</code> type is the main user-facing type for <code>SimpleSDMDatasets</code>. Specifically, this is a <em>singleton</em> parametric type, where the two parameters are the type of the <code>RasterProvider</code> and the <code>RasterDataset</code>. Note that the inner constructor calls the <code>provides</code> method on the provider/dataset pair to check that this combination exists.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/specifiers.jl#L1-L9",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",u,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SimpleSDMDatasets.RasterDataset",href:"#SimpleSDMDatasets.RasterDataset"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDataset")],-1)),s[5]||(s[5]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[7]||(s[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterDataset</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as being a dataset. Datasets are given by <code>RasterProvider</code>s, and the same dataset can have multiple providers.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",c,[e("summary",null,[s[8]||(s[8]=e("a",{id:"SimpleSDMDatasets.RasterProvider",href:"#SimpleSDMDatasets.RasterProvider"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterProvider")],-1)),s[9]||(s[9]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[11]||(s[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterProvider</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as a provider of <code>RasterDataset</code>s. For example, WorldClim2 and CHELSA2 are <code>RasterProvider</code>s.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[10]||(s[10]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[117]||(s[117]=e("h2",{id:"List-of-datasets",tabindex:"-1"},[i("List of datasets "),e("a",{class:"header-anchor",href:"#List-of-datasets","aria-label":'Permalink to "List of datasets {#List-of-datasets}"'},"​")],-1)),e("details",y,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SimpleSDMDatasets.BioClim",href:"#SimpleSDMDatasets.BioClim"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BioClim")],-1)),s[13]||(s[13]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[15]||(s[15]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">BioClim</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[14]||(s[14]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L9-L11",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",S,[e("summary",null,[s[16]||(s[16]=e("a",{id:"SimpleSDMDatasets.Elevation",href:"#SimpleSDMDatasets.Elevation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Elevation")],-1)),s[17]||(s[17]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[19]||(s[19]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Elevation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[18]||(s[18]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L14-L16",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",T,[e("summary",null,[s[20]||(s[20]=e("a",{id:"SimpleSDMDatasets.MinimumTemperature",href:"#SimpleSDMDatasets.MinimumTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MinimumTemperature")],-1)),s[21]||(s[21]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[23]||(s[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">MinimumTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[22]||(s[22]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L19-L21",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",k,[e("summary",null,[s[24]||(s[24]=e("a",{id:"SimpleSDMDatasets.MaximumTemperature",href:"#SimpleSDMDatasets.MaximumTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MaximumTemperature")],-1)),s[25]||(s[25]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[27]||(s[27]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">MaximumTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[26]||(s[26]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L24-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",D,[e("summary",null,[s[28]||(s[28]=e("a",{id:"SimpleSDMDatasets.AverageTemperature",href:"#SimpleSDMDatasets.AverageTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.AverageTemperature")],-1)),s[29]||(s[29]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[31]||(s[31]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AverageTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[30]||(s[30]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L29-L31",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",g,[e("summary",null,[s[32]||(s[32]=e("a",{id:"SimpleSDMDatasets.Precipitation",href:"#SimpleSDMDatasets.Precipitation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Precipitation")],-1)),s[33]||(s[33]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[35]||(s[35]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Precipitation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[34]||(s[34]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L34-L36",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",h,[e("summary",null,[s[36]||(s[36]=e("a",{id:"SimpleSDMDatasets.SolarRadiation",href:"#SimpleSDMDatasets.SolarRadiation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.SolarRadiation")],-1)),s[37]||(s[37]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[39]||(s[39]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">SolarRadiation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[38]||(s[38]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L39-L41",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",f,[e("summary",null,[s[40]||(s[40]=e("a",{id:"SimpleSDMDatasets.WindSpeed",href:"#SimpleSDMDatasets.WindSpeed"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WindSpeed")],-1)),s[41]||(s[41]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[43]||(s[43]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">WindSpeed</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[42]||(s[42]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L44-L46",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",j,[e("summary",null,[s[44]||(s[44]=e("a",{id:"SimpleSDMDatasets.WaterVaporPressure",href:"#SimpleSDMDatasets.WaterVaporPressure"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WaterVaporPressure")],-1)),s[45]||(s[45]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[47]||(s[47]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">WaterVaporPressure</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[46]||(s[46]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L49-L51",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",_,[e("summary",null,[s[48]||(s[48]=e("a",{id:"SimpleSDMDatasets.LandCover",href:"#SimpleSDMDatasets.LandCover"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.LandCover")],-1)),s[49]||(s[49]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[51]||(s[51]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">LandCover</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[50]||(s[50]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L54-L56",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",v,[e("summary",null,[s[52]||(s[52]=e("a",{id:"SimpleSDMDatasets.HabitatHeterogeneity",href:"#SimpleSDMDatasets.HabitatHeterogeneity"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.HabitatHeterogeneity")],-1)),s[53]||(s[53]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[55]||(s[55]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">HabitatHeterogeneity</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[54]||(s[54]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L59-L61",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",C,[e("summary",null,[s[56]||(s[56]=e("a",{id:"SimpleSDMDatasets.Topography",href:"#SimpleSDMDatasets.Topography"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Topography")],-1)),s[57]||(s[57]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[59]||(s[59]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Topography</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[58]||(s[58]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L64-L66",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",M,[e("summary",null,[s[60]||(s[60]=e("a",{id:"SimpleSDMDatasets.BirdRichness",href:"#SimpleSDMDatasets.BirdRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BirdRichness")],-1)),s[61]||(s[61]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[63]||(s[63]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">BirdRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[62]||(s[62]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L74-L76",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",P,[e("summary",null,[s[64]||(s[64]=e("a",{id:"SimpleSDMDatasets.MammalRichness",href:"#SimpleSDMDatasets.MammalRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MammalRichness")],-1)),s[65]||(s[65]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[67]||(s[67]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">MammalRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[66]||(s[66]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L69-L71",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",F,[e("summary",null,[s[68]||(s[68]=e("a",{id:"SimpleSDMDatasets.AmphibianRichness",href:"#SimpleSDMDatasets.AmphibianRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.AmphibianRichness")],-1)),s[69]||(s[69]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[71]||(s[71]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AmphibianRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[70]||(s[70]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/datasets.jl#L79-L81",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[118]||(s[118]=e("h2",{id:"List-of-providers",tabindex:"-1"},[i("List of providers "),e("a",{class:"header-anchor",href:"#List-of-providers","aria-label":'Permalink to "List of providers {#List-of-providers}"'},"​")],-1)),e("details",L,[e("summary",null,[s[72]||(s[72]=e("a",{id:"SimpleSDMDatasets.WorldClim2",href:"#SimpleSDMDatasets.WorldClim2"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WorldClim2")],-1)),s[73]||(s[73]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[75]||(s[75]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">WorldClim2</span></span></code></pre></div><p>This provider offers access to the version 2 of the WorldClim data, accessible from <code>http://www.worldclim.com/version2</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[74]||(s[74]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L9-L13",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",A,[e("summary",null,[s[76]||(s[76]=e("a",{id:"SimpleSDMDatasets.EarthEnv",href:"#SimpleSDMDatasets.EarthEnv"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.EarthEnv")],-1)),s[77]||(s[77]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[79]||(s[79]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">EarthEnv</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[78]||(s[78]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L16-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",x,[e("summary",null,[s[80]||(s[80]=e("a",{id:"SimpleSDMDatasets.CHELSA1",href:"#SimpleSDMDatasets.CHELSA1"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA1")],-1)),s[81]||(s[81]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[83]||(s[83]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">CHELSA1</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[82]||(s[82]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L21-L23",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",R,[e("summary",null,[s[84]||(s[84]=e("a",{id:"SimpleSDMDatasets.CHELSA2",href:"#SimpleSDMDatasets.CHELSA2"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA2")],-1)),s[85]||(s[85]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[87]||(s[87]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">CHELSA2</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[86]||(s[86]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L26-L28",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",E,[e("summary",null,[s[88]||(s[88]=e("a",{id:"SimpleSDMDatasets.BiodiversityMapping",href:"#SimpleSDMDatasets.BiodiversityMapping"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BiodiversityMapping")],-1)),s[89]||(s[89]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[91]||(s[91]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">BiodiversityMapping</span></span></code></pre></div><p>Global biodiveristy data from <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a> - see this website for citation information</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[90]||(s[90]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L31-L35",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",V,[e("summary",null,[s[92]||(s[92]=e("a",{id:"SimpleSDMDatasets.PaleoClim",href:"#SimpleSDMDatasets.PaleoClim"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.PaleoClim")],-1)),s[93]||(s[93]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[95]||(s[95]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">PaleoClim</span></span></code></pre></div><p>Paleoclimate data from <a href="http://www.paleoclim.org/" target="_blank" rel="noreferrer">http://www.paleoclim.org/</a> - see this website for citation information</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[94]||(s[94]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/providers.jl#L38-L42",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[119]||(s[119]=e("h2",{id:"List-of-projections",tabindex:"-1"},[i("List of projections "),e("a",{class:"header-anchor",href:"#List-of-projections","aria-label":'Permalink to "List of projections {#List-of-projections}"'},"​")],-1)),e("details",I,[e("summary",null,[s[96]||(s[96]=e("a",{id:"SimpleSDMDatasets.Projection",href:"#SimpleSDMDatasets.Projection"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Projection")],-1)),s[97]||(s[97]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[99]||(s[99]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Future{S </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> FutureScenario</span><span style="--shiki-light:#212121;--shiki-dark:#BBBBBB;">,</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> M </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;"> FutureModel</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>This type is similar to <code>RasterData</code> but describes a combination of a scenario and a model. Note that <em>unlike</em> <code>RasterData</code>, there is no type check in the inner constructor; instead, the way to check that a provider/dataset/scenario/model combination exists is to overload the <code>provides</code> method for a dataset and future.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[98]||(s[98]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/specifiers.jl#L21-L29",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",B,[e("summary",null,[s[100]||(s[100]=e("a",{id:"SimpleSDMDatasets.CMIP5Scenario",href:"#SimpleSDMDatasets.CMIP5Scenario"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CMIP5Scenario")],-1)),s[101]||(s[101]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[103]||(s[103]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">CMIP5Scenario</span></span></code></pre></div><p>These scenarios are part of CMIP5. They can be <code>RCP26</code> to <code>RCP85</code> (with <code>RCPXX</code> the scenario).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[102]||(s[102]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/futures.jl#L110-L114",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[120]||(s[120]=e("h2",{id:"List-of-enumerated-types",tabindex:"-1"},[i("List of enumerated types "),e("a",{class:"header-anchor",href:"#List-of-enumerated-types","aria-label":'Permalink to "List of enumerated types {#List-of-enumerated-types}"'},"​")],-1)),e("details",N,[e("summary",null,[s[104]||(s[104]=e("a",{id:"SimpleSDMDatasets.RasterDownloadType",href:"#SimpleSDMDatasets.RasterDownloadType"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDownloadType")],-1)),s[105]||(s[105]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[107]||(s[107]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterDownloadType</span></span></code></pre></div><p>This enum stores the possible types of downloaded files. They are listed with <code>instances(RasterDownloadType)</code>, and are currently limited to <code>_file</code> (a file, can be read directly) and <code>_zip</code> (an archive, must be unzipped).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[106]||(s[106]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/enums.jl#L1-L7",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",w,[e("summary",null,[s[108]||(s[108]=e("a",{id:"SimpleSDMDatasets.RasterFileType",href:"#SimpleSDMDatasets.RasterFileType"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterFileType")],-1)),s[109]||(s[109]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[111]||(s[111]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterFileType</span></span></code></pre></div><p>This enum stores the possible types of returned files. They are listed with <code>instances(RasterFileType)</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[110]||(s[110]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/enums.jl#L13-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",O,[e("summary",null,[s[112]||(s[112]=e("a",{id:"SimpleSDMDatasets.RasterCRS",href:"#SimpleSDMDatasets.RasterCRS"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterCRS")],-1)),s[113]||(s[113]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[115]||(s[115]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">RasterCRS</span></span></code></pre></div><p>This enum stores the possible coordinate representation system of returned files. They are listed with <code>instances(RasterProjection)</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[114]||(s[114]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/1eece9a7a89aa7a7661688b64955556184ebf8b3/SimpleSDMDatasets/src/types/enums.jl#L25-L29",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const J=n(m,[["render",H]]);export{X as __pageData,J as default};
