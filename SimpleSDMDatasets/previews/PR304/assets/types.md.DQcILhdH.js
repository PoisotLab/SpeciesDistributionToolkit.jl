import{_ as o,c as p,a2 as a,j as e,a as t,G as l,B as n,o as r}from"./chunks/framework.Cg-3chSZ.js";const X=JSON.parse('{"title":"Type system for datasets","description":"","frontmatter":{},"headers":[],"relativePath":"types.md","filePath":"types.md","lastUpdated":null}'),d={name:"types.md"},b={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},E={class:"jldocstring custom-block",open:""},M={class:"jldocstring custom-block",open:""},L={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},x={class:"jldocstring custom-block",open:""},P={class:"jldocstring custom-block",open:""},R={class:"jldocstring custom-block",open:""},w={class:"jldocstring custom-block",open:""},O={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},B={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},H={class:"jldocstring custom-block",open:""},W={class:"jldocstring custom-block",open:""},N={class:"jldocstring custom-block",open:""};function V(I,s,q,$,z,G){const i=n("Badge");return r(),p("div",null,[s[87]||(s[87]=a('<h1 id="Type-system-for-datasets" tabindex="-1">Type system for datasets <a class="header-anchor" href="#Type-system-for-datasets" aria-label="Permalink to &quot;Type system for datasets {#Type-system-for-datasets}&quot;">​</a></h1><p>Note that all datasets <strong>must</strong> be a direct subtype of <code>RasterDataset</code>, all providers <strong>must</strong> be a direct subtype of <code>RasterProvider</code>, all scenarios <strong>must</strong> be a direct subtype of <code>FutureScenario</code>, and all models <strong>must</strong> be a direct subtype of <code>FutureModel</code>. If you need to aggregate multiple models within a type (<em>e.g.</em> <code>CMIP6Scenarios</code>), use a <code>Union</code> type. The reason for this convention is that in interactive mode, <code>subtype</code> will let users pick the data combination they want.</p><h2 id="Type-system-overview" tabindex="-1">Type system overview <a class="header-anchor" href="#Type-system-overview" aria-label="Permalink to &quot;Type system overview {#Type-system-overview}&quot;">​</a></h2>',3)),e("details",b,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SimpleSDMDatasets.RasterData",href:"#SimpleSDMDatasets.RasterData"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterData")],-1)),s[1]||(s[1]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[2]||(s[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterData{P </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> RasterProvider</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, D </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> RasterDataset</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>The <code>RasterData</code> type is the main user-facing type for <code>SimpleSDMDatasets</code>. Specifically, this is a <em>singleton</em> parametric type, where the two parameters are the type of the <code>RasterProvider</code> and the <code>RasterDataset</code>. Note that the inner constructor calls the <code>provides</code> method on the provider/dataset pair to check that this combination exists.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/specifiers.jl#L1-L9" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",c,[e("summary",null,[s[3]||(s[3]=e("a",{id:"SimpleSDMDatasets.RasterDataset",href:"#SimpleSDMDatasets.RasterDataset"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDataset")],-1)),s[4]||(s[4]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[5]||(s[5]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterDataset</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as being a dataset. Datasets are given by <code>RasterProvider</code>s, and the same dataset can have multiple providers.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",u,[e("summary",null,[s[6]||(s[6]=e("a",{id:"SimpleSDMDatasets.RasterProvider",href:"#SimpleSDMDatasets.RasterProvider"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterProvider")],-1)),s[7]||(s[7]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[8]||(s[8]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterProvider</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as a provider of <code>RasterDataset</code>s. For example, WorldClim2 and CHELSA2 are <code>RasterProvider</code>s.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))]),s[88]||(s[88]=e("h2",{id:"List-of-datasets",tabindex:"-1"},[t("List of datasets "),e("a",{class:"header-anchor",href:"#List-of-datasets","aria-label":'Permalink to "List of datasets {#List-of-datasets}"'},"​")],-1)),e("details",m,[e("summary",null,[s[9]||(s[9]=e("a",{id:"SimpleSDMDatasets.BioClim",href:"#SimpleSDMDatasets.BioClim"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BioClim")],-1)),s[10]||(s[10]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[11]||(s[11]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">BioClim</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L9-L11" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",h,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SimpleSDMDatasets.Elevation",href:"#SimpleSDMDatasets.Elevation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Elevation")],-1)),s[13]||(s[13]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[14]||(s[14]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Elevation</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L14-L16" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",g,[e("summary",null,[s[15]||(s[15]=e("a",{id:"SimpleSDMDatasets.MinimumTemperature",href:"#SimpleSDMDatasets.MinimumTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MinimumTemperature")],-1)),s[16]||(s[16]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[17]||(s[17]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">MinimumTemperature</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L19-L21" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",y,[e("summary",null,[s[18]||(s[18]=e("a",{id:"SimpleSDMDatasets.MaximumTemperature",href:"#SimpleSDMDatasets.MaximumTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MaximumTemperature")],-1)),s[19]||(s[19]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[20]||(s[20]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">MaximumTemperature</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L24-L26" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",k,[e("summary",null,[s[21]||(s[21]=e("a",{id:"SimpleSDMDatasets.AverageTemperature",href:"#SimpleSDMDatasets.AverageTemperature"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.AverageTemperature")],-1)),s[22]||(s[22]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[23]||(s[23]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">AverageTemperature</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L29-L31" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",S,[e("summary",null,[s[24]||(s[24]=e("a",{id:"SimpleSDMDatasets.Precipitation",href:"#SimpleSDMDatasets.Precipitation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Precipitation")],-1)),s[25]||(s[25]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[26]||(s[26]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Precipitation</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L34-L36" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",D,[e("summary",null,[s[27]||(s[27]=e("a",{id:"SimpleSDMDatasets.SolarRadiation",href:"#SimpleSDMDatasets.SolarRadiation"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.SolarRadiation")],-1)),s[28]||(s[28]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[29]||(s[29]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">SolarRadiation</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L39-L41" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",j,[e("summary",null,[s[30]||(s[30]=e("a",{id:"SimpleSDMDatasets.WindSpeed",href:"#SimpleSDMDatasets.WindSpeed"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WindSpeed")],-1)),s[31]||(s[31]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[32]||(s[32]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">WindSpeed</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L44-L46" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",f,[e("summary",null,[s[33]||(s[33]=e("a",{id:"SimpleSDMDatasets.WaterVaporPressure",href:"#SimpleSDMDatasets.WaterVaporPressure"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WaterVaporPressure")],-1)),s[34]||(s[34]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[35]||(s[35]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">WaterVaporPressure</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L49-L51" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",v,[e("summary",null,[s[36]||(s[36]=e("a",{id:"SimpleSDMDatasets.LandCover",href:"#SimpleSDMDatasets.LandCover"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.LandCover")],-1)),s[37]||(s[37]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[38]||(s[38]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">LandCover</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L54-L56" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",T,[e("summary",null,[s[39]||(s[39]=e("a",{id:"SimpleSDMDatasets.HabitatHeterogeneity",href:"#SimpleSDMDatasets.HabitatHeterogeneity"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.HabitatHeterogeneity")],-1)),s[40]||(s[40]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[41]||(s[41]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">HabitatHeterogeneity</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L59-L61" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",E,[e("summary",null,[s[42]||(s[42]=e("a",{id:"SimpleSDMDatasets.Topography",href:"#SimpleSDMDatasets.Topography"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Topography")],-1)),s[43]||(s[43]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[44]||(s[44]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Topography</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L64-L66" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",M,[e("summary",null,[s[45]||(s[45]=e("a",{id:"SimpleSDMDatasets.BirdRichness",href:"#SimpleSDMDatasets.BirdRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BirdRichness")],-1)),s[46]||(s[46]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[47]||(s[47]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">BirdRichness</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L74-L76" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",L,[e("summary",null,[s[48]||(s[48]=e("a",{id:"SimpleSDMDatasets.MammalRichness",href:"#SimpleSDMDatasets.MammalRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.MammalRichness")],-1)),s[49]||(s[49]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[50]||(s[50]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">MammalRichness</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L69-L71" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",C,[e("summary",null,[s[51]||(s[51]=e("a",{id:"SimpleSDMDatasets.AmphibianRichness",href:"#SimpleSDMDatasets.AmphibianRichness"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.AmphibianRichness")],-1)),s[52]||(s[52]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[53]||(s[53]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">AmphibianRichness</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/datasets.jl#L79-L81" target="_blank" rel="noreferrer">source</a></p>',2))]),s[89]||(s[89]=e("h2",{id:"List-of-providers",tabindex:"-1"},[t("List of providers "),e("a",{class:"header-anchor",href:"#List-of-providers","aria-label":'Permalink to "List of providers {#List-of-providers}"'},"​")],-1)),e("details",x,[e("summary",null,[s[54]||(s[54]=e("a",{id:"SimpleSDMDatasets.WorldClim2",href:"#SimpleSDMDatasets.WorldClim2"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.WorldClim2")],-1)),s[55]||(s[55]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[56]||(s[56]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">WorldClim2</span></span></code></pre></div><p>This provider offers access to the version 2 of the WorldClim data, accessible from <code>http://www.worldclim.com/version2</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L9-L13" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",P,[e("summary",null,[s[57]||(s[57]=e("a",{id:"SimpleSDMDatasets.EarthEnv",href:"#SimpleSDMDatasets.EarthEnv"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.EarthEnv")],-1)),s[58]||(s[58]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[59]||(s[59]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">EarthEnv</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L16-L18" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",R,[e("summary",null,[s[60]||(s[60]=e("a",{id:"SimpleSDMDatasets.CHELSA1",href:"#SimpleSDMDatasets.CHELSA1"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA1")],-1)),s[61]||(s[61]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[62]||(s[62]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">CHELSA1</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L21-L23" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",w,[e("summary",null,[s[63]||(s[63]=e("a",{id:"SimpleSDMDatasets.CHELSA2",href:"#SimpleSDMDatasets.CHELSA2"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA2")],-1)),s[64]||(s[64]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[65]||(s[65]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">CHELSA2</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L26-L28" target="_blank" rel="noreferrer">source</a></p>',2))]),e("details",O,[e("summary",null,[s[66]||(s[66]=e("a",{id:"SimpleSDMDatasets.BiodiversityMapping",href:"#SimpleSDMDatasets.BiodiversityMapping"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.BiodiversityMapping")],-1)),s[67]||(s[67]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[68]||(s[68]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">BiodiversityMapping</span></span></code></pre></div><p>Global biodiveristy data from <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a> - see this website for citation information</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L31-L35" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",F,[e("summary",null,[s[69]||(s[69]=e("a",{id:"SimpleSDMDatasets.PaleoClim",href:"#SimpleSDMDatasets.PaleoClim"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.PaleoClim")],-1)),s[70]||(s[70]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[71]||(s[71]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">PaleoClim</span></span></code></pre></div><p>Paleoclimate data from <a href="http://www.paleoclim.org/" target="_blank" rel="noreferrer">http://www.paleoclim.org/</a> - see this website for citation information</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/providers.jl#L38-L42" target="_blank" rel="noreferrer">source</a></p>',3))]),s[90]||(s[90]=e("h2",{id:"List-of-projections",tabindex:"-1"},[t("List of projections "),e("a",{class:"header-anchor",href:"#List-of-projections","aria-label":'Permalink to "List of projections {#List-of-projections}"'},"​")],-1)),e("details",B,[e("summary",null,[s[72]||(s[72]=e("a",{id:"SimpleSDMDatasets.Projection",href:"#SimpleSDMDatasets.Projection"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.Projection")],-1)),s[73]||(s[73]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[74]||(s[74]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Future{S </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> FutureScenario</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, M </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> FutureModel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This type is similar to <code>RasterData</code> but describes a combination of a scenario and a model. Note that <em>unlike</em> <code>RasterData</code>, there is no type check in the inner constructor; instead, the way to check that a provider/dataset/scenario/model combination exists is to overload the <code>provides</code> method for a dataset and future.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/specifiers.jl#L21-L29" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",A,[e("summary",null,[s[75]||(s[75]=e("a",{id:"SimpleSDMDatasets.CMIP5Scenario",href:"#SimpleSDMDatasets.CMIP5Scenario"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.CMIP5Scenario")],-1)),s[76]||(s[76]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[77]||(s[77]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">CMIP5Scenario</span></span></code></pre></div><p>These scenarios are part of CMIP5. They can be <code>RCP26</code> to <code>RCP85</code> (with <code>RCPXX</code> the scenario).</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/futures.jl#L110-L114" target="_blank" rel="noreferrer">source</a></p>',3))]),s[91]||(s[91]=e("h2",{id:"List-of-enumerated-types",tabindex:"-1"},[t("List of enumerated types "),e("a",{class:"header-anchor",href:"#List-of-enumerated-types","aria-label":'Permalink to "List of enumerated types {#List-of-enumerated-types}"'},"​")],-1)),e("details",H,[e("summary",null,[s[78]||(s[78]=e("a",{id:"SimpleSDMDatasets.RasterDownloadType",href:"#SimpleSDMDatasets.RasterDownloadType"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDownloadType")],-1)),s[79]||(s[79]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[80]||(s[80]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterDownloadType</span></span></code></pre></div><p>This enum stores the possible types of downloaded files. They are listed with <code>instances(RasterDownloadType)</code>, and are currently limited to <code>_file</code> (a file, can be read directly) and <code>_zip</code> (an archive, must be unzipped).</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/enums.jl#L1-L7" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",W,[e("summary",null,[s[81]||(s[81]=e("a",{id:"SimpleSDMDatasets.RasterFileType",href:"#SimpleSDMDatasets.RasterFileType"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterFileType")],-1)),s[82]||(s[82]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[83]||(s[83]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterFileType</span></span></code></pre></div><p>This enum stores the possible types of returned files. They are listed with <code>instances(RasterFileType)</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/enums.jl#L13-L18" target="_blank" rel="noreferrer">source</a></p>',3))]),e("details",N,[e("summary",null,[s[84]||(s[84]=e("a",{id:"SimpleSDMDatasets.RasterCRS",href:"#SimpleSDMDatasets.RasterCRS"},[e("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterCRS")],-1)),s[85]||(s[85]=t()),l(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[86]||(s[86]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">RasterCRS</span></span></code></pre></div><p>This enum stores the possible coordinate representation system of returned files. They are listed with <code>instances(RasterProjection)</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/SimpleSDMDatasets/src/types/enums.jl#L25-L29" target="_blank" rel="noreferrer">source</a></p>',3))])])}const J=o(d,[["render",V]]);export{X as __pageData,J as default};