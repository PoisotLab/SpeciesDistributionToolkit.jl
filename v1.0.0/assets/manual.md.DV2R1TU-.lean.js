import{_ as a,c as t,a2 as s,o as i}from"./chunks/framework.D9BeJ9z8.js";const h=JSON.parse('{"title":"Manual","description":"","frontmatter":{},"headers":[],"relativePath":"manual.md","filePath":"manual.md","lastUpdated":null}'),l={name:"manual.md"};function o(r,e,n,c,p,d){return i(),t("div",null,e[0]||(e[0]=[s(`<h1 id="manual" tabindex="-1">Manual <a class="header-anchor" href="#manual" aria-label="Permalink to &quot;Manual&quot;">​</a></h1><p><code>SpeciesDistributionToolkit.jl</code> is a collection of packages for species distribution modeling and biodiversity research, for the <a href="https://julialang.org/" target="_blank" rel="noreferrer">Julia</a> programming language.</p><div class="info custom-block"><p class="custom-block-title">Not just for research!</p><p>This package is now used in pipelines in <a href="https://boninabox.geobon.org/index" target="_blank" rel="noreferrer">BON in a Box</a>, <a href="https://geobon.org/" target="_blank" rel="noreferrer">GEOBON</a>&#39;s project to automate the calculation and representation of the post-2020 <a href="https://www.cbd.int/gbf" target="_blank" rel="noreferrer">GBF indicators</a>.</p></div><h2 id="Contents-of-the-package" tabindex="-1">Contents of the package <a class="header-anchor" href="#Contents-of-the-package" aria-label="Permalink to &quot;Contents of the package {#Contents-of-the-package}&quot;">​</a></h2><p>The package offers a series of methods to acces data required to build species distribution models, including:</p><ul><li><p>a wrapper around the <a href="https://www.gbif.org/" target="_blank" rel="noreferrer">GBIF</a> occurrences API to access occurrence data</p></li><li><p>a wrapper around the <a href="https://www.phylopic.org/" target="_blank" rel="noreferrer">Phylopic</a> images API</p></li><li><p>ways to generate fake occurrences with statistical properties similar to actual occurrences</p></li><li><p>ways to generate pseudo-absences based on a series of heuristics</p></li><li><p>a simple way to represent layers as mutable objectcs</p></li><li><p>utility functions for <em>teaching</em> species distribution models</p></li><li><p>a way to collect historic and future climate and land-use data to feed into the models, pre-loaded with datasets like CHELSA, WorldClim, EarthEnv, PaleoClim, etc</p></li><li><p>an interface to <a href="https://docs.makie.org/stable/" target="_blank" rel="noreferrer">Makie</a> for plotting and data visualisation</p></li></ul><details class="details custom-block"><summary>Installation</summary><p>The only package you need to install is <code>SpeciesDistributionToolkit</code> itself, which can be done using</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">import</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Pkg</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Pkg</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">add</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;SpeciesDistributionToolkit&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span></span></code></pre></div><p>This will automatically install all the sub-packages.</p></details><h2 id="Contents-of-the-manual" tabindex="-1">Contents of the manual <a class="header-anchor" href="#Contents-of-the-manual" aria-label="Permalink to &quot;Contents of the manual {#Contents-of-the-manual}&quot;">​</a></h2><p>This manual is split into two sections: tutorials, which are medium to long examples of using the full functionality of the package; and how-tos, which are shorter (and denser) summaries of how to achieve a specific task.</p><h2 id="Current-component-packages" tabindex="-1">Current component packages <a class="header-anchor" href="#Current-component-packages" aria-label="Permalink to &quot;Current component packages {#Current-component-packages}&quot;">​</a></h2><p>The packages <em>do</em> work independently, but they are <em>designed</em> to work together. In particular, when installing <code>SpeciesDistributionToolkit</code>, you get access to all the functions and types exported by the component packages. This is the <em>recommended</em> way to interact with the packages.</p><details class="details custom-block"><summary>Access to GBIF data</summary><p><code>GBIF.jl</code> is a wrapper around the GBIF API, to retrieve taxa and occurrence datasets, and perform filtering on these occurrence data based on flags.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=GBIF-*&amp;style=flat-square&amp;label=GBIF.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square" alt="Lifecycle:Stable"></details><details class="details custom-block"><summary>Handling occurrence data</summary><p><code>OccurrencesInterface.jl</code> is a <em>lightweight</em>, <em>general purpose</em> interface that allows other types to be used with the Species Distribution Toolkit package.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=OccurrencesInterface-*&amp;style=flat-square&amp;label=OccurrencesInterface.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square" alt="Lifecycle:Stable"></details><details class="details custom-block"><summary>Downloading and managing environmental data</summary><p><code>SimpleSDMDatasets.jl</code> is an efficient and transparent, interface-based way to download and store environmental raster data for consumption by other packages.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMDatasets-*&amp;style=flat-square&amp;label=SimpleSDMDatasets.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square" alt="Lifecycle:Stable"></details><details class="details custom-block"><summary>Manipulating raster</summary><p><code>SimpleSDMLayers.jl</code> offers a series of types and common operations on raster data.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SimpleSDMLayers-*&amp;style=flat-square&amp;label=SimpleSDMLayers.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square" alt="Lifecycle:Maturing"></details><details class="details custom-block"><summary>Simulating occurrence data</summary><p><code>Fauxcurrences.jl</code> is a package to simulate realistic species occurrence data from a known series of occurrences, with additional statistical constraints.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Fauxcurrences-*&amp;style=flat-square&amp;label=Fauxcurrences.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square" alt="Lifecycle:Maturing"></details><details class="details custom-block"><summary>Access to the Phylopic library</summary><p><code>Phylopic.jl</code> is a wrapper around the Phylopic API.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=Phylopic-*&amp;style=flat-square&amp;label=Phylopic.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Stable-97ca00?style=flat-square" alt="Lifecycle:Stable"></details><details class="details custom-block"><summary>Tools for workshops and education</summary><p><code>SDeMo.jl</code> is a series of very simple SDMs and utility functions for education, with some tools for interpretable machine learning.</p><img src="https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=SDeMo-*&amp;style=flat-square&amp;label=SDeMo.jl" alt="GitHub Release"><img src="https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square" alt="Lifecycle:Maturing"></details>`,18)]))}const m=a(l,[["render",o]]);export{h as __pageData,m as default};
