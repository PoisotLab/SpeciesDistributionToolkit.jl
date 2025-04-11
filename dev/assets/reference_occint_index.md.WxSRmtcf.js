import{_ as l,C as o,c,o as p,ag as a,j as s,G as i,a as n,w as r}from"./chunks/framework.5VWB6o6B.js";const S=JSON.parse('{"title":"An interface for occurrence data","description":"","frontmatter":{},"headers":[],"relativePath":"reference/occint/index.md","filePath":"reference/occint/index.md","lastUpdated":null}'),d={name:"reference/occint/index.md"},h={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},T={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""};function j(v,e,C,O,A,D){const t=o("Badge");return p(),c("div",null,[e[68]||(e[68]=a('<h1 id="An-interface-for-occurrence-data" tabindex="-1">An interface for occurrence data <a class="header-anchor" href="#An-interface-for-occurrence-data" aria-label="Permalink to &quot;An interface for occurrence data {#An-interface-for-occurrence-data}&quot;">​</a></h1><p>The <code>OccurrencesInterface</code> package provides a <em>lightweight</em> representation of species occurrence data. It is meant to be implemented by other packages that want to be interoperable with the <code>SpeciesDistributionToolkit</code> package, which uses this interface for functions like plotting, masking, and value extraction from occurrence data.</p><h2 id="Types-that-other-packages-should-use" tabindex="-1">Types that other packages should use <a class="header-anchor" href="#Types-that-other-packages-should-use" aria-label="Permalink to &quot;Types that other packages should use {#Types-that-other-packages-should-use}&quot;">​</a></h2><p>The interface relies on two abstract types:</p>',4)),s("details",h,[s("summary",null,[e[0]||(e[0]=s("a",{id:"OccurrencesInterface.AbstractOccurrence",href:"#OccurrencesInterface.AbstractOccurrence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.AbstractOccurrence")],-1)),e[1]||(e[1]=n()),i(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[3]||(e[3]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AbstractOccurrence</span></span></code></pre></div><p>Other types describing a single observation should be sub-types of this. Occurrences are always defined as a single observation of a single species.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[2]||(e[2]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/types.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",u,[s("summary",null,[e[4]||(e[4]=s("a",{id:"OccurrencesInterface.AbstractOccurrenceCollection",href:"#OccurrencesInterface.AbstractOccurrenceCollection"},[s("span",{class:"jlbinding"},"OccurrencesInterface.AbstractOccurrenceCollection")],-1)),e[5]||(e[5]=n()),i(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[7]||(e[7]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">AbstractOccurrenceCollection</span></span></code></pre></div><p>Other types describing multiple observations can be sub-types of this. Occurrences collections are a way to collect multiple observations of arbitrarily many species.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[6]||(e[6]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/types.jl#L8-L12",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[69]||(e[69]=s("h2",{id:"Concrete-types-shipping-with-the-package",tabindex:"-1"},[n("Concrete types shipping with the package "),s("a",{class:"header-anchor",href:"#Concrete-types-shipping-with-the-package","aria-label":'Permalink to "Concrete types shipping with the package {#Concrete-types-shipping-with-the-package}"'},"​")],-1)),e[70]||(e[70]=s("p",null,"In order to wrap user-provided data, regardless of its type, the package offers two concrete types:",-1)),s("details",k,[s("summary",null,[e[8]||(e[8]=s("a",{id:"OccurrencesInterface.Occurrence",href:"#OccurrencesInterface.Occurrence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.Occurrence")],-1)),e[9]||(e[9]=n()),i(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Occurrence</span></span></code></pre></div><p>This is a sub-type of <code>AbstractOccurrence</code>, with the following types:</p><ul><li><p><code>what</code> - species name, defaults to <code>&quot;&quot;</code></p></li><li><p><code>presence</code> - a boolean to mark the presence of the species, defaults to <code>true</code></p></li><li><p><code>where</code> - a tuple giving the location as longitude,latitude in WGS84, or <code>missing</code>, defaults to <code>missing</code></p></li><li><p><code>when</code> - a <code>DateTime</code> giving the date of observation, or <code>missing</code>, defaults to <code>missing</code></p></li></ul><p>When the interface is properly implemented for any type that is a sub-type of <code>AbstractOccurrence</code>, there is an <code>Occurrence</code> object can be created directly with <em>e.g.</em> <code>Occurrence(observation)</code>. There is, similarly, an automatically implemented <code>convert</code> method.</p>',4)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[10]||(e[10]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/types.jl#L15-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",f,[s("summary",null,[e[12]||(e[12]=s("a",{id:"OccurrencesInterface.Occurrences",href:"#OccurrencesInterface.Occurrences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.Occurrences")],-1)),e[13]||(e[13]=n()),i(t,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[15]||(e[15]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">Occurrences</span></span></code></pre></div><p>This is a sub-type of <code>AbstractOccurrenceCollection</code>. No default value.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[14]||(e[14]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/types.jl#L40-L44",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[71]||(e[71]=s("h2",{id:"The-interface",tabindex:"-1"},[n("The interface "),s("a",{class:"header-anchor",href:"#The-interface","aria-label":'Permalink to "The interface {#The-interface}"'},"​")],-1)),e[72]||(e[72]=s("p",null,[n("In order to implement the interface, packages "),s("em",null,"must"),n(" implement the following methods for their type that is a subtype of "),s("code",null,"AbstractOccurrence"),n(" or "),s("code",null,"AbstractOccurrenceCollection"),n(". None of these methods are optional. Most of these can be implemented as one-liners.")],-1)),s("details",b,[s("summary",null,[e[16]||(e[16]=s("a",{id:"OccurrencesInterface.elements",href:"#OccurrencesInterface.elements"},[s("span",{class:"jlbinding"},"OccurrencesInterface.elements")],-1)),e[17]||(e[17]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[19]||(e[19]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">elements</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> {T</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>Returns the elements contained in an abstract collection of occurrences – this must be something that can be iterated. The default value, when unimplemented, is <code>nothing</code>.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[18]||(e[18]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L1-L5",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",g,[s("summary",null,[e[20]||(e[20]=s("a",{id:"OccurrencesInterface.entity",href:"#OccurrencesInterface.entity"},[s("span",{class:"jlbinding"},"OccurrencesInterface.entity")],-1)),e[21]||(e[21]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[26]||(e[26]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">entity</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(o</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Occurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the entity (species name) for an occurrence event.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[22]||(e[22]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L10-L14",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[27]||(e[27]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">entity</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>entity</code> operation. Unless overloaded, this returns <code>nothing</code>.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[23]||(e[23]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L56-L60",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[28]||(e[28]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">entity</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>entity</code> operation. Unless overloaded, this returns an array of <code>entity</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[24]||(e[24]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L63-L67",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[29]||(e[29]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">entity</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Vector{AbstractOccurrence}</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any vector of occurrence type for the <code>entity</code> operation. Unless overloaded, this returns an array of <code>entity</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[25]||(e[25]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L70-L74",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",F,[s("summary",null,[e[30]||(e[30]=s("a",{id:"OccurrencesInterface.place",href:"#OccurrencesInterface.place"},[s("span",{class:"jlbinding"},"OccurrencesInterface.place")],-1)),e[31]||(e[31]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[36]||(e[36]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">place</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(o</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Occurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the place of the occurrence event, either as a tuple of float in the longitude, latitude format, or as <code>missing</code>. The CRS is assumed to be WGS84 with no option to change it. This follows the GeoJSON specification.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[32]||(e[32]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L22-L26",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[37]||(e[37]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">place</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>place</code> operation. Unless overloaded, this returns <code>nothing</code>.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[33]||(e[33]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L56-L60",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[38]||(e[38]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">place</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>place</code> operation. Unless overloaded, this returns an array of <code>place</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[34]||(e[34]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L63-L67",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[39]||(e[39]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">place</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Vector{AbstractOccurrence}</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any vector of occurrence type for the <code>place</code> operation. Unless overloaded, this returns an array of <code>place</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[35]||(e[35]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L70-L74",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",y,[s("summary",null,[e[40]||(e[40]=s("a",{id:"OccurrencesInterface.date",href:"#OccurrencesInterface.date"},[s("span",{class:"jlbinding"},"OccurrencesInterface.date")],-1)),e[41]||(e[41]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[46]||(e[46]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">date</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(o</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Occurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns the date (technically a <code>DateTime</code> object) documenting the time of occurrence event. Can be <code>missing</code> if not known.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[42]||(e[42]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L40-L44",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[47]||(e[47]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">date</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>date</code> operation. Unless overloaded, this returns <code>nothing</code>.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[43]||(e[43]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L56-L60",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[48]||(e[48]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">date</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>date</code> operation. Unless overloaded, this returns an array of <code>date</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[44]||(e[44]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L63-L67",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[49]||(e[49]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">date</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Vector{AbstractOccurrence}</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any vector of occurrence type for the <code>date</code> operation. Unless overloaded, this returns an array of <code>date</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[45]||(e[45]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L70-L74",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",m,[s("summary",null,[e[50]||(e[50]=s("a",{id:"OccurrencesInterface.presence",href:"#OccurrencesInterface.presence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.presence")],-1)),e[51]||(e[51]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[56]||(e[56]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">presence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(o</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Occurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Returns a <code>Bool</code> for the occurrence status, where <code>true</code> is the presence of the entity and <code>false</code> is the (pseudo)absence.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[52]||(e[52]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L47-L51",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[57]||(e[57]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">presence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>presence</code> operation. Unless overloaded, this returns <code>nothing</code>.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[53]||(e[53]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L56-L60",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[58]||(e[58]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">presence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>presence</code> operation. Unless overloaded, this returns an array of <code>presence</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[54]||(e[54]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L63-L67",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1}),e[59]||(e[59]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">presence</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">Vector{AbstractOccurrence}</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">)</span></span></code></pre></div><p>Default method for any vector of occurrence type for the <code>presence</code> operation. Unless overloaded, this returns an array of <code>presence</code> on all <code>elements</code> of the argument.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[55]||(e[55]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L70-L74",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[73]||(e[73]=s("h2",{id:"Additional-methods",tabindex:"-1"},[n("Additional methods "),s("a",{class:"header-anchor",href:"#Additional-methods","aria-label":'Permalink to "Additional methods {#Additional-methods}"'},"​")],-1)),s("details",T,[s("summary",null,[e[60]||(e[60]=s("a",{id:"OccurrencesInterface.presences",href:"#OccurrencesInterface.presences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.presences")],-1)),e[61]||(e[61]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[63]||(e[63]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">presences</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(c</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> {T</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>Returns an <code>Occurrences</code> where only the occurrences in the initial collection for which <code>presence</code> evaluates to <code>true</code> are kept.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[62]||(e[62]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L79-L83",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),s("details",_,[s("summary",null,[e[64]||(e[64]=s("a",{id:"OccurrencesInterface.absences",href:"#OccurrencesInterface.absences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.absences")],-1)),e[65]||(e[65]=n()),i(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[67]||(e[67]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes min-light min-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">absences</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">(c</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">) </span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;"> {T</span><span style="--shiki-light:#D32F2F;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#1976D2;--shiki-dark:#79B8FF;">AbstractOccurrenceCollection</span><span style="--shiki-light:#24292EFF;--shiki-dark:#B392F0;">}</span></span></code></pre></div><p>Returns an <code>Occurrences</code> where only the occurrences in the initial collection for which <code>presence</code> evaluates to <code>false</code> are kept.</p>',2)),i(t,{type:"info",class:"source-link",text:"source"},{default:r(()=>e[66]||(e[66]=[s("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/ea714674fef978af9c60244c7de48f720eaa073b/OccurrencesInterface/src/interface.jl#L86-L90",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})]),e[74]||(e[74]=s("h2",{id:"The-Tables.jl-interface",tabindex:"-1"},[n("The "),s("code",null,"Tables.jl"),n(" interface "),s("a",{class:"header-anchor",href:"#The-Tables.jl-interface","aria-label":'Permalink to "The `Tables.jl` interface {#The-Tables.jl-interface}"'},"​")],-1)),e[75]||(e[75]=s("p",null,[n("The "),s("code",null,"Occurrences"),n(" type is a data source for the "),s("code",null,"Tables.jl"),n(" interface.")],-1))])}const B=l(d,[["render",j]]);export{S as __pageData,B as default};
