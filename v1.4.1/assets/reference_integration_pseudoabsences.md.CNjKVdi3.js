import{_ as l,C as r,c as p,o as d,j as e,a as t,ag as n,G as a,w as o}from"./chunks/framework.DfgxSEAC.js";const v=JSON.parse('{"title":"Pseudo absences generation","description":"","frontmatter":{},"headers":[],"relativePath":"reference/integration/pseudoabsences.md","filePath":"reference/integration/pseudoabsences.md","lastUpdated":null}'),k={name:"reference/integration/pseudoabsences.md"},h={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""};function A(f,s,m,C,T,D){const i=r("Badge");return d(),p("div",null,[s[30]||(s[30]=e("h1",{id:"Pseudo-absences-generation",tabindex:"-1"},[t("Pseudo absences generation "),e("a",{class:"header-anchor",href:"#Pseudo-absences-generation","aria-label":'Permalink to "Pseudo absences generation {#Pseudo-absences-generation}"'},"​")],-1)),s[31]||(s[31]=e("h2",{id:"Supported-algorithms",tabindex:"-1"},[t("Supported algorithms "),e("a",{class:"header-anchor",href:"#Supported-algorithms","aria-label":'Permalink to "Supported algorithms {#Supported-algorithms}"'},"​")],-1)),e("details",h,[e("summary",null,[s[0]||(s[0]=e("a",{id:"SpeciesDistributionToolkit.PseudoAbsenceGenerator",href:"#SpeciesDistributionToolkit.PseudoAbsenceGenerator"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.PseudoAbsenceGenerator")],-1)),s[1]||(s[1]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[3]||(s[3]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">PseudoAbsenceGenerator</span></span></code></pre></div><p>Abstract type to which all of the pseudo-absences generator types belong. Note that the pseudo-absence types are <em>singleton</em> types, and the arguments are passed when generating the pseudo-absence mask.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[2]||(s[2]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L1-L7",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",c,[e("summary",null,[s[4]||(s[4]=e("a",{id:"SpeciesDistributionToolkit.WithinRadius",href:"#SpeciesDistributionToolkit.WithinRadius"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.WithinRadius")],-1)),s[5]||(s[5]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[7]||(s[7]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">WithinRadius</span></span></code></pre></div><p>Generates pseudo-absences within a set radius (in kilometers) around each occurrence</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[6]||(s[6]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L10-L15",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",u,[e("summary",null,[s[8]||(s[8]=e("a",{id:"SpeciesDistributionToolkit.SurfaceRangeEnvelope",href:"#SpeciesDistributionToolkit.SurfaceRangeEnvelope"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.SurfaceRangeEnvelope")],-1)),s[9]||(s[9]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[11]||(s[11]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SurfaceRangeEnvelope</span></span></code></pre></div><p>Generates pseudo-absences at random within the geographic range covered by actual occurrences</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[10]||(s[10]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L19-L24",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e("details",b,[e("summary",null,[s[12]||(s[12]=e("a",{id:"SpeciesDistributionToolkit.RandomSelection",href:"#SpeciesDistributionToolkit.RandomSelection"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.RandomSelection")],-1)),s[13]||(s[13]=t()),a(i,{type:"info",class:"jlObjectType jlType",text:"Type"})]),s[15]||(s[15]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RandomSelection</span></span></code></pre></div><p>Generates pseudo-absences at random within the layer</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[14]||(s[14]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L28-L32",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[32]||(s[32]=e("h2",{id:"Generation-of-a-pseudo-absence-mask",tabindex:"-1"},[t("Generation of a pseudo-absence mask "),e("a",{class:"header-anchor",href:"#Generation-of-a-pseudo-absence-mask","aria-label":'Permalink to "Generation of a pseudo-absence mask {#Generation-of-a-pseudo-absence-mask}"'},"​")],-1)),s[33]||(s[33]=e("p",null,[t("The above algorithms are used in conjunction with "),e("code",null,"pseudoabsencemask"),t(" to generate a Boolean layer that contains all pixels in which a background point can be. They do "),e("em",null,"not"),t(" generate background points directly, in order to allow more flexible workflows based on clipping Boolean masks, for example.")],-1)),e("details",g,[e("summary",null,[s[16]||(s[16]=e("a",{id:"SpeciesDistributionToolkit.pseudoabsencemask",href:"#SpeciesDistributionToolkit.pseudoabsencemask"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.pseudoabsencemask")],-1)),s[17]||(s[17]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[22]||(s[22]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">pseudoabsencemask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Type{RandomSelection}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, presences</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates a mask for pseudo-absences using the random selection method. Candidate cells for the pseudo-absence mask are (i) within the bounding box of the <em>layer</em> (use <code>SurfaceRangeEnvelope</code> to use the presences bounding box), and (ii) valued in the layer.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[18]||(s[18]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L49-L56",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[23]||(s[23]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">pseudoabsencemask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">( </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Type{SurfaceRangeEnvelope}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, presences</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates a mask from which pseudo-absences can be drawn, by picking cells that are (i) within the bounding box of occurrences, (ii) valued in the layer, and (iii) not already occupied by an occurrence</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[19]||(s[19]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L62-L68",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[24]||(s[24]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">pseudoabsencemask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Type{DistanceToEvent}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, presence</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; f</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">minimum) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> SimpleSDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates a mask for pseudo-absences using the distance to event method. Candidate cells are weighted according to their distance to a known observation, with far away places being more likely. Depending on the distribution of distances, it may be a very good idea to flatten this layer using <code>log</code> or an exponent. The <code>f</code> function is used to determine which distance is reported (minimum by default, can also be mean or median).</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[20]||(s[20]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L87-L96",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),s[25]||(s[25]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">pseudoabsencemask</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Type{DistanceToEvent}</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, presence</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; distance</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Number</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">100.0</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> SimpleSDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates a mask for pseudo-absences where pseudo-absences can be within a <code>distance</code> (in kilometers) of the original observation. Internally, this uses <code>DistanceToEvent</code>.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[21]||(s[21]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L136-L142",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s[34]||(s[34]=e("h2",{id:"Sampling-of-background-points",tabindex:"-1"},[t("Sampling of background points "),e("a",{class:"header-anchor",href:"#Sampling-of-background-points","aria-label":'Permalink to "Sampling of background points {#Sampling-of-background-points}"'},"​")],-1)),e("details",y,[e("summary",null,[s[26]||(s[26]=e("a",{id:"SpeciesDistributionToolkit.backgroundpoints",href:"#SpeciesDistributionToolkit.backgroundpoints"},[e("span",{class:"jlbinding"},"SpeciesDistributionToolkit.backgroundpoints")],-1)),s[27]||(s[27]=t()),a(i,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[29]||(s[29]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">backgroundpoints</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(layer</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, n</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Int</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; replace</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;"> SimpleSDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Generates background points based on a layer that gives either the location of possible points (<code>Bool</code>) or the weight of each cell in the final sample (<code>Number</code>). Note that the default value is to draw without replacement, but this can be changed using <code>replace=true</code>. The additional keywors arguments are passed to <code>StatsBase.sample</code>, which is used internally.</p>',2)),a(i,{type:"info",class:"source-link",text:"source"},{default:o(()=>s[28]||(s[28]=[e("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/a260be6e69933ef7379a3554aaf2e9418e1aa8e5/src/pseudoabsences.jl#L158-L166",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const _=l(k,[["render",A]]);export{v as __pageData,_ as default};
