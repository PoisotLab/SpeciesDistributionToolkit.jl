import{_ as r,C as p,c as n,o as d,ag as l,j as s,G as a,a as i,w as o}from"./chunks/framework.DfgxSEAC.js";const X=JSON.parse('{"title":"Type system for datasets","description":"","frontmatter":{},"headers":[],"relativePath":"reference/datasets/types.md","filePath":"reference/datasets/types.md","lastUpdated":null}'),u={name:"reference/datasets/types.md"},m={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},S={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},M={class:"jldocstring custom-block",open:""},P={class:"jldocstring custom-block",open:""},L={class:"jldocstring custom-block",open:""},x={class:"jldocstring custom-block",open:""},R={class:"jldocstring custom-block",open:""},V={class:"jldocstring custom-block",open:""},I={class:"jldocstring custom-block",open:""},E={class:"jldocstring custom-block",open:""},N={class:"jldocstring custom-block",open:""},w={class:"jldocstring custom-block",open:""},O={class:"jldocstring custom-block",open:""},B={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""};function H(W,e,q,$,z,G){const t=p("Badge");return d(),n("div",null,[e[116]||(e[116]=l('<h1 id="Type-system-for-datasets" tabindex="-1">Type system for datasets <a class="header-anchor" href="#Type-system-for-datasets" aria-label="Permalink to &quot;Type system for datasets {#Type-system-for-datasets}&quot;">​</a></h1><p>Note that all datasets <strong>must</strong> be a direct subtype of <code>RasterDataset</code>, all providers <strong>must</strong> be a direct subtype of <code>RasterProvider</code>, all scenarios <strong>must</strong> be a direct subtype of <code>FutureScenario</code>, and all models <strong>must</strong> be a direct subtype of <code>FutureModel</code>. If you need to aggregate multiple models within a type (<em>e.g.</em> <code>CMIP6Scenarios</code>), use a <code>Union</code> type. The reason for this convention is that in interactive mode, <code>subtype</code> will let users pick the data combination they want.</p><h2 id="Type-system-overview" tabindex="-1">Type system overview <a class="header-anchor" href="#Type-system-overview" aria-label="Permalink to &quot;Type system overview {#Type-system-overview}&quot;">​</a></h2>',3)),s("details",m,[s("summary",null,[e[0]||(e[0]=s("a",{id:"SimpleSDMDatasets.RasterData",href:"#SimpleSDMDatasets.RasterData"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterData")],-1)),e[1]||(e[1]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterData{P </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> RasterProvider</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, D </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> RasterDataset</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>The <code>RasterData</code> type is the main user-facing type for <code>SimpleSDMDatasets</code>. Specifically, this is a <em>singleton</em> parametric type, where the two parameters are the type of the <code>RasterProvider</code> and the <code>RasterDataset</code>. Note that the inner constructor calls the <code>provides</code> method on the provider/dataset pair to check that this combination exists.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[2]||(e[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/specifiers.jl#L1-L9",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",b,[s("summary",null,[e[4]||(e[4]=s("a",{id:"SimpleSDMDatasets.RasterDataset",href:"#SimpleSDMDatasets.RasterDataset"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDataset")],-1)),e[5]||(e[5]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[7]||(e[7]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterDataset</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as being a dataset. Datasets are given by <code>RasterProvider</code>s, and the same dataset can have multiple providers.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[6]||(e[6]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",c,[s("summary",null,[e[8]||(e[8]=s("a",{id:"SimpleSDMDatasets.RasterProvider",href:"#SimpleSDMDatasets.RasterProvider"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterProvider")],-1)),e[9]||(e[9]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterProvider</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as a provider of <code>RasterDataset</code>s. For example, WorldClim2 and CHELSA2 are <code>RasterProvider</code>s.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[10]||(e[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L1-L6",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[117]||(e[117]=s("h2",{id:"List-of-datasets",tabindex:"-1"},[i("List of datasets "),s("a",{class:"header-anchor",href:"#List-of-datasets","aria-label":'Permalink to "List of datasets {#List-of-datasets}"'},"​")],-1)),s("details",y,[s("summary",null,[e[12]||(e[12]=s("a",{id:"SimpleSDMDatasets.BioClim",href:"#SimpleSDMDatasets.BioClim"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.BioClim")],-1)),e[13]||(e[13]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[15]||(e[15]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">BioClim</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[14]||(e[14]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L9-L11",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",S,[s("summary",null,[e[16]||(e[16]=s("a",{id:"SimpleSDMDatasets.Elevation",href:"#SimpleSDMDatasets.Elevation"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.Elevation")],-1)),e[17]||(e[17]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[19]||(e[19]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Elevation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[18]||(e[18]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L14-L16",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",f,[s("summary",null,[e[20]||(e[20]=s("a",{id:"SimpleSDMDatasets.MinimumTemperature",href:"#SimpleSDMDatasets.MinimumTemperature"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.MinimumTemperature")],-1)),e[21]||(e[21]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[23]||(e[23]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">MinimumTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[22]||(e[22]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L19-L21",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",D,[s("summary",null,[e[24]||(e[24]=s("a",{id:"SimpleSDMDatasets.MaximumTemperature",href:"#SimpleSDMDatasets.MaximumTemperature"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.MaximumTemperature")],-1)),e[25]||(e[25]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[27]||(e[27]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">MaximumTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[26]||(e[26]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L24-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",T,[s("summary",null,[e[28]||(e[28]=s("a",{id:"SimpleSDMDatasets.AverageTemperature",href:"#SimpleSDMDatasets.AverageTemperature"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.AverageTemperature")],-1)),e[29]||(e[29]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[31]||(e[31]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AverageTemperature</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[30]||(e[30]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L29-L31",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",k,[s("summary",null,[e[32]||(e[32]=s("a",{id:"SimpleSDMDatasets.Precipitation",href:"#SimpleSDMDatasets.Precipitation"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.Precipitation")],-1)),e[33]||(e[33]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[35]||(e[35]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Precipitation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[34]||(e[34]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L34-L36",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",g,[s("summary",null,[e[36]||(e[36]=s("a",{id:"SimpleSDMDatasets.SolarRadiation",href:"#SimpleSDMDatasets.SolarRadiation"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.SolarRadiation")],-1)),e[37]||(e[37]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[39]||(e[39]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SolarRadiation</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[38]||(e[38]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L39-L41",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",h,[s("summary",null,[e[40]||(e[40]=s("a",{id:"SimpleSDMDatasets.WindSpeed",href:"#SimpleSDMDatasets.WindSpeed"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.WindSpeed")],-1)),e[41]||(e[41]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[43]||(e[43]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">WindSpeed</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[42]||(e[42]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L44-L46",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",v,[s("summary",null,[e[44]||(e[44]=s("a",{id:"SimpleSDMDatasets.WaterVaporPressure",href:"#SimpleSDMDatasets.WaterVaporPressure"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.WaterVaporPressure")],-1)),e[45]||(e[45]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[47]||(e[47]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">WaterVaporPressure</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[46]||(e[46]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L49-L51",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",j,[s("summary",null,[e[48]||(e[48]=s("a",{id:"SimpleSDMDatasets.LandCover",href:"#SimpleSDMDatasets.LandCover"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.LandCover")],-1)),e[49]||(e[49]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[51]||(e[51]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">LandCover</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[50]||(e[50]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L54-L56",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",_,[s("summary",null,[e[52]||(e[52]=s("a",{id:"SimpleSDMDatasets.HabitatHeterogeneity",href:"#SimpleSDMDatasets.HabitatHeterogeneity"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.HabitatHeterogeneity")],-1)),e[53]||(e[53]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[55]||(e[55]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">HabitatHeterogeneity</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[54]||(e[54]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L59-L61",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",C,[s("summary",null,[e[56]||(e[56]=s("a",{id:"SimpleSDMDatasets.Topography",href:"#SimpleSDMDatasets.Topography"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.Topography")],-1)),e[57]||(e[57]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[59]||(e[59]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Topography</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[58]||(e[58]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L64-L66",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",A,[s("summary",null,[e[60]||(e[60]=s("a",{id:"SimpleSDMDatasets.BirdRichness",href:"#SimpleSDMDatasets.BirdRichness"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.BirdRichness")],-1)),e[61]||(e[61]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[63]||(e[63]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">BirdRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[62]||(e[62]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L74-L76",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",M,[s("summary",null,[e[64]||(e[64]=s("a",{id:"SimpleSDMDatasets.MammalRichness",href:"#SimpleSDMDatasets.MammalRichness"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.MammalRichness")],-1)),e[65]||(e[65]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[67]||(e[67]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">MammalRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[66]||(e[66]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L69-L71",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",P,[s("summary",null,[e[68]||(e[68]=s("a",{id:"SimpleSDMDatasets.AmphibianRichness",href:"#SimpleSDMDatasets.AmphibianRichness"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.AmphibianRichness")],-1)),e[69]||(e[69]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[71]||(e[71]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AmphibianRichness</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[70]||(e[70]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/datasets.jl#L79-L81",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[118]||(e[118]=s("h2",{id:"List-of-providers",tabindex:"-1"},[i("List of providers "),s("a",{class:"header-anchor",href:"#List-of-providers","aria-label":'Permalink to "List of providers {#List-of-providers}"'},"​")],-1)),s("details",L,[s("summary",null,[e[72]||(e[72]=s("a",{id:"SimpleSDMDatasets.WorldClim2",href:"#SimpleSDMDatasets.WorldClim2"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.WorldClim2")],-1)),e[73]||(e[73]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[75]||(e[75]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">WorldClim2</span></span></code></pre></div><p>This provider offers access to the version 2 of the WorldClim data, accessible from <code>http://www.worldclim.com/version2</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[74]||(e[74]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L9-L13",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",x,[s("summary",null,[e[76]||(e[76]=s("a",{id:"SimpleSDMDatasets.EarthEnv",href:"#SimpleSDMDatasets.EarthEnv"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.EarthEnv")],-1)),e[77]||(e[77]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[79]||(e[79]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">EarthEnv</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[78]||(e[78]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L16-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",R,[s("summary",null,[e[80]||(e[80]=s("a",{id:"SimpleSDMDatasets.CHELSA1",href:"#SimpleSDMDatasets.CHELSA1"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA1")],-1)),e[81]||(e[81]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[83]||(e[83]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">CHELSA1</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[82]||(e[82]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L21-L23",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",V,[s("summary",null,[e[84]||(e[84]=s("a",{id:"SimpleSDMDatasets.CHELSA2",href:"#SimpleSDMDatasets.CHELSA2"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.CHELSA2")],-1)),e[85]||(e[85]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[87]||(e[87]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">CHELSA2</span></span></code></pre></div>',1)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[86]||(e[86]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L26-L28",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",I,[s("summary",null,[e[88]||(e[88]=s("a",{id:"SimpleSDMDatasets.BiodiversityMapping",href:"#SimpleSDMDatasets.BiodiversityMapping"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.BiodiversityMapping")],-1)),e[89]||(e[89]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[91]||(e[91]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">BiodiversityMapping</span></span></code></pre></div><p>Global biodiveristy data from <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a> - see this website for citation information</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[90]||(e[90]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L31-L35",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",E,[s("summary",null,[e[92]||(e[92]=s("a",{id:"SimpleSDMDatasets.PaleoClim",href:"#SimpleSDMDatasets.PaleoClim"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.PaleoClim")],-1)),e[93]||(e[93]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[95]||(e[95]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">PaleoClim</span></span></code></pre></div><p>Paleoclimate data from <a href="http://www.paleoclim.org/" target="_blank" rel="noreferrer">http://www.paleoclim.org/</a> - see this website for citation information</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[94]||(e[94]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/providers.jl#L38-L42",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[119]||(e[119]=s("h2",{id:"List-of-projections",tabindex:"-1"},[i("List of projections "),s("a",{class:"header-anchor",href:"#List-of-projections","aria-label":'Permalink to "List of projections {#List-of-projections}"'},"​")],-1)),s("details",N,[s("summary",null,[e[96]||(e[96]=s("a",{id:"SimpleSDMDatasets.Projection",href:"#SimpleSDMDatasets.Projection"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.Projection")],-1)),e[97]||(e[97]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[99]||(e[99]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Future{S </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> FutureScenario</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, M </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> FutureModel</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>This type is similar to <code>RasterData</code> but describes a combination of a scenario and a model. Note that <em>unlike</em> <code>RasterData</code>, there is no type check in the inner constructor; instead, the way to check that a provider/dataset/scenario/model combination exists is to overload the <code>provides</code> method for a dataset and future.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[98]||(e[98]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/specifiers.jl#L21-L29",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",w,[s("summary",null,[e[100]||(e[100]=s("a",{id:"SimpleSDMDatasets.CMIP5Scenario",href:"#SimpleSDMDatasets.CMIP5Scenario"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.CMIP5Scenario")],-1)),e[101]||(e[101]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[103]||(e[103]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">CMIP5Scenario</span></span></code></pre></div><p>These scenarios are part of CMIP5. They can be <code>RCP26</code> to <code>RCP85</code> (with <code>RCPXX</code> the scenario).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[102]||(e[102]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/futures.jl#L110-L114",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[120]||(e[120]=s("h2",{id:"List-of-enumerated-types",tabindex:"-1"},[i("List of enumerated types "),s("a",{class:"header-anchor",href:"#List-of-enumerated-types","aria-label":'Permalink to "List of enumerated types {#List-of-enumerated-types}"'},"​")],-1)),s("details",O,[s("summary",null,[e[104]||(e[104]=s("a",{id:"SimpleSDMDatasets.RasterDownloadType",href:"#SimpleSDMDatasets.RasterDownloadType"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterDownloadType")],-1)),e[105]||(e[105]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[107]||(e[107]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterDownloadType</span></span></code></pre></div><p>This enum stores the possible types of downloaded files. They are listed with <code>instances(RasterDownloadType)</code>, and are currently limited to <code>_file</code> (a file, can be read directly) and <code>_zip</code> (an archive, must be unzipped).</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[106]||(e[106]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/enums.jl#L1-L7",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",B,[s("summary",null,[e[108]||(e[108]=s("a",{id:"SimpleSDMDatasets.RasterFileType",href:"#SimpleSDMDatasets.RasterFileType"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterFileType")],-1)),e[109]||(e[109]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[111]||(e[111]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterFileType</span></span></code></pre></div><p>This enum stores the possible types of returned files. They are listed with <code>instances(RasterFileType)</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[110]||(e[110]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/enums.jl#L13-L18",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",F,[s("summary",null,[e[112]||(e[112]=s("a",{id:"SimpleSDMDatasets.RasterCRS",href:"#SimpleSDMDatasets.RasterCRS"},[s("span",{class:"jlbinding"},"SimpleSDMDatasets.RasterCRS")],-1)),e[113]||(e[113]=i()),a(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[115]||(e[115]=l('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterCRS</span></span></code></pre></div><p>This enum stores the possible coordinate representation system of returned files. They are listed with <code>instances(RasterProjection)</code>.</p>',2)),a(t,{type:"info",class:"source-link",text:"source"},{default:o(()=>e[114]||(e[114]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/SimpleSDMDatasets/src/types/enums.jl#L25-L29",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const J=r(u,[["render",H]]);export{X as __pageData,J as default};
