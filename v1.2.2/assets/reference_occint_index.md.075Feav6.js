import{_ as r,C as c,c as o,o as l,ag as i,j as s,a as t,G as n}from"./chunks/framework.RaFiNGy7.js";const S=JSON.parse('{"title":"An interface for occurrence data","description":"","frontmatter":{},"headers":[],"relativePath":"reference/occint/index.md","filePath":"reference/occint/index.md","lastUpdated":null}'),p={name:"reference/occint/index.md"},d={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""};function v(T,e,j,D,_,O){const a=c("Badge");return l(),o("div",null,[e[33]||(e[33]=i('<h1 id="An-interface-for-occurrence-data" tabindex="-1">An interface for occurrence data <a class="header-anchor" href="#An-interface-for-occurrence-data" aria-label="Permalink to &quot;An interface for occurrence data {#An-interface-for-occurrence-data}&quot;">​</a></h1><p>The <code>OccurrencesInterface</code> package provides a <em>lightweight</em> representation of species occurrence data. It is meant to be implemented by other packages that want to be interoperable with the <code>SpeciesDistributionToolkit</code> package, which uses this interface for functions like plotting, masking, and value extraction from occurrence data.</p><h2 id="Types-that-other-packages-should-use" tabindex="-1">Types that other packages should use <a class="header-anchor" href="#Types-that-other-packages-should-use" aria-label="Permalink to &quot;Types that other packages should use {#Types-that-other-packages-should-use}&quot;">​</a></h2><p>The interface relies on two abstract types:</p>',4)),s("details",d,[s("summary",null,[e[0]||(e[0]=s("a",{id:"OccurrencesInterface.AbstractOccurrence",href:"#OccurrencesInterface.AbstractOccurrence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.AbstractOccurrence")],-1)),e[1]||(e[1]=t()),n(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[2]||(e[2]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AbstractOccurrence</span></span></code></pre></div><p>Other types describing a single observation should be sub-types of this. Occurrences are always defined as a single observation of a single species.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/types.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",h,[s("summary",null,[e[3]||(e[3]=s("a",{id:"OccurrencesInterface.AbstractOccurrenceCollection",href:"#OccurrencesInterface.AbstractOccurrenceCollection"},[s("span",{class:"jlbinding"},"OccurrencesInterface.AbstractOccurrenceCollection")],-1)),e[4]||(e[4]=t()),n(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[5]||(e[5]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">AbstractOccurrenceCollection</span></span></code></pre></div><p>Other types describing multiple observations can be sub-types of this. Occurrences collections are a way to collect multiple observations of arbitrarily many species.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/types.jl#L8-L12" target="_blank" rel="noreferrer">source</a></p>',3))]),e[34]||(e[34]=s("h2",{id:"Concrete-types-shipping-with-the-package",tabindex:"-1"},[t("Concrete types shipping with the package "),s("a",{class:"header-anchor",href:"#Concrete-types-shipping-with-the-package","aria-label":'Permalink to "Concrete types shipping with the package {#Concrete-types-shipping-with-the-package}"'},"​")],-1)),e[35]||(e[35]=s("p",null,"In order to wrap user-provided data, regardless of its type, the package offers two concrete types:",-1)),s("details",u,[s("summary",null,[e[6]||(e[6]=s("a",{id:"OccurrencesInterface.Occurrence",href:"#OccurrencesInterface.Occurrence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.Occurrence")],-1)),e[7]||(e[7]=t()),n(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[8]||(e[8]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Occurrence</span></span></code></pre></div><p>This is a sub-type of <code>AbstractOccurrence</code>, with the following types:</p><ul><li><p><code>what</code> - species name, defaults to <code>&quot;&quot;</code></p></li><li><p><code>presence</code> - a boolean to mark the presence of the species, defaults to <code>true</code></p></li><li><p><code>where</code> - a tuple giving the location as longitude,latitude in WGS84, or <code>missing</code>, defaults to <code>missing</code></p></li><li><p><code>when</code> - a <code>DateTime</code> giving the date of observation, or <code>missing</code>, defaults to <code>missing</code></p></li></ul><p>When the interface is properly implemented for any type that is a sub-type of <code>AbstractOccurrence</code>, there is an <code>Occurrence</code> object can be created directly with <em>e.g.</em> <code>Occurrence(observation)</code>. There is, similarly, an automatically implemented <code>convert</code> method.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/types.jl#L15-L26" target="_blank" rel="noreferrer">source</a></p>',5))]),s("details",k,[s("summary",null,[e[9]||(e[9]=s("a",{id:"OccurrencesInterface.Occurrences",href:"#OccurrencesInterface.Occurrences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.Occurrences")],-1)),e[10]||(e[10]=t()),n(a,{type:"info",class:"jlObjectType jlType",text:"Type"})]),e[11]||(e[11]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Occurrences</span></span></code></pre></div><p>This is a sub-type of <code>AbstractOccurrenceCollection</code>. No default value.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/types.jl#L40-L44" target="_blank" rel="noreferrer">source</a></p>',3))]),e[36]||(e[36]=s("h2",{id:"The-interface",tabindex:"-1"},[t("The interface "),s("a",{class:"header-anchor",href:"#The-interface","aria-label":'Permalink to "The interface {#The-interface}"'},"​")],-1)),e[37]||(e[37]=s("p",null,[t("In order to implement the interface, packages "),s("em",null,"must"),t(" implement the following methods for their type that is a subtype of "),s("code",null,"AbstractOccurrence"),t(" or "),s("code",null,"AbstractOccurrenceCollection"),t(". None of these methods are optional. Most of these can be implemented as one-liners.")],-1)),s("details",f,[s("summary",null,[e[12]||(e[12]=s("a",{id:"OccurrencesInterface.elements",href:"#OccurrencesInterface.elements"},[s("span",{class:"jlbinding"},"OccurrencesInterface.elements")],-1)),e[13]||(e[13]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[14]||(e[14]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">elements</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Returns the elements contained in an abstract collection of occurrences – this must be something that can be iterated. The default value, when unimplemented, is <code>nothing</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",b,[s("summary",null,[e[15]||(e[15]=s("a",{id:"OccurrencesInterface.entity",href:"#OccurrencesInterface.entity"},[s("span",{class:"jlbinding"},"OccurrencesInterface.entity")],-1)),e[16]||(e[16]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[17]||(e[17]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">entity</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(o</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Occurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the entity (species name) for an occurrence event.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L9-L13" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">entity</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>entity</code> operation. Unless overloaded, this returns <code>nothing</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L55-L59" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">entity</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>entity</code> operation. Unless overloaded, this returns an array of <code>entity</code> on all <code>elements</code> of the argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L62-L66" target="_blank" rel="noreferrer">source</a></p>',9))]),s("details",g,[s("summary",null,[e[18]||(e[18]=s("a",{id:"OccurrencesInterface.place",href:"#OccurrencesInterface.place"},[s("span",{class:"jlbinding"},"OccurrencesInterface.place")],-1)),e[19]||(e[19]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[20]||(e[20]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">place</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(o</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Occurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the place of the occurrence event, either as a tuple of float in the longitude, latitude format, or as <code>missing</code>. The CRS is assumed to be WGS84 with no option to change it. This follows the GeoJSON specification.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L21-L25" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">place</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>place</code> operation. Unless overloaded, this returns <code>nothing</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L55-L59" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">place</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>place</code> operation. Unless overloaded, this returns an array of <code>place</code> on all <code>elements</code> of the argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L62-L66" target="_blank" rel="noreferrer">source</a></p>',9))]),s("details",y,[s("summary",null,[e[21]||(e[21]=s("a",{id:"OccurrencesInterface.date",href:"#OccurrencesInterface.date"},[s("span",{class:"jlbinding"},"OccurrencesInterface.date")],-1)),e[22]||(e[22]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[23]||(e[23]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">date</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(o</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Occurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the date (technically a <code>DateTime</code> object) documenting the time of occurrence event. Can be <code>missing</code> if not known.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L39-L43" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">date</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>date</code> operation. Unless overloaded, this returns <code>nothing</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L55-L59" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">date</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>date</code> operation. Unless overloaded, this returns an array of <code>date</code> on all <code>elements</code> of the argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L62-L66" target="_blank" rel="noreferrer">source</a></p>',9))]),s("details",A,[s("summary",null,[e[24]||(e[24]=s("a",{id:"OccurrencesInterface.presence",href:"#OccurrencesInterface.presence"},[s("span",{class:"jlbinding"},"OccurrencesInterface.presence")],-1)),e[25]||(e[25]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[26]||(e[26]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">presence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(o</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Occurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a <code>Bool</code> for the occurrence status, where <code>true</code> is the presence of the entity and <code>false</code> is the (pseudo)absence.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L46-L50" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">presence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence type for the <code>presence</code> operation. Unless overloaded, this returns <code>nothing</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L55-L59" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">presence</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Default method for any abstract occurrence collection type for the <code>presence</code> operation. Unless overloaded, this returns an array of <code>presence</code> on all <code>elements</code> of the argument.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L62-L66" target="_blank" rel="noreferrer">source</a></p>',9))]),e[38]||(e[38]=s("h2",{id:"Additional-methods",tabindex:"-1"},[t("Additional methods "),s("a",{class:"header-anchor",href:"#Additional-methods","aria-label":'Permalink to "Additional methods {#Additional-methods}"'},"​")],-1)),s("details",C,[s("summary",null,[e[27]||(e[27]=s("a",{id:"OccurrencesInterface.presences",href:"#OccurrencesInterface.presences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.presences")],-1)),e[28]||(e[28]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[29]||(e[29]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">presences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(c</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Returns an <code>Occurrences</code> where only the occurrences in the initial collection for which <code>presence</code> evaluates to <code>true</code> are kept.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L71-L75" target="_blank" rel="noreferrer">source</a></p>',3))]),s("details",m,[s("summary",null,[e[30]||(e[30]=s("a",{id:"OccurrencesInterface.absences",href:"#OccurrencesInterface.absences"},[s("span",{class:"jlbinding"},"OccurrencesInterface.absences")],-1)),e[31]||(e[31]=t()),n(a,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),e[32]||(e[32]=i('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">absences</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(c</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">T</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">where</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> {T</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&lt;:</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractOccurrenceCollection</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">}</span></span></code></pre></div><p>Returns an <code>Occurrences</code> where only the occurrences in the initial collection for which <code>presence</code> evaluates to <code>false</code> are kept.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/OccurrencesInterface/src/interface.jl#L78-L82" target="_blank" rel="noreferrer">source</a></p>',3))]),e[39]||(e[39]=s("h2",{id:"The-Tables.jl-interface",tabindex:"-1"},[t("The "),s("code",null,"Tables.jl"),t(" interface "),s("a",{class:"header-anchor",href:"#The-Tables.jl-interface","aria-label":'Permalink to "The `Tables.jl` interface {#The-Tables.jl-interface}"'},"​")],-1)),e[40]||(e[40]=s("p",null,[t("The "),s("code",null,"Occurrences"),t(" type is a data source for the "),s("code",null,"Tables.jl"),t(" interface.")],-1))])}const B=r(p,[["render",v]]);export{S as __pageData,B as default};
