import{_ as o,c as a,o as t,ag as r}from"./chunks/framework.DJWGqVem.js";const g=JSON.parse('{"title":"Changelog","description":"","frontmatter":{},"headers":[],"relativePath":"reference/changelog/SpeciesDistributionToolkit.md","filePath":"reference/changelog/SpeciesDistributionToolkit.md","lastUpdated":null}'),i={name:"reference/changelog/SpeciesDistributionToolkit.md"};function d(n,e,l,s,c,h){return t(),a("div",null,e[0]||(e[0]=[r('<h1 id="changelog" tabindex="-1">Changelog <a class="header-anchor" href="#changelog" aria-label="Permalink to &quot;Changelog&quot;">​</a></h1><p>All notable changes to this project will be documented in this file.</p><p>The format is based on <a href="https://keepachangelog.com/en/1.1.0/" target="_blank" rel="noreferrer">Keep a Changelog</a>, and this project adheres to <a href="https://semver.org/spec/v2.0.0.html" target="_blank" rel="noreferrer">Semantic Versioning</a>.</p><h2 id="v1.5.1" tabindex="-1"><code>v1.5.1</code> <a class="header-anchor" href="#v1.5.1" aria-label="Permalink to &quot;`v1.5.1` {#v1.5.1}&quot;">​</a></h2><ul><li><p><strong>removed</strong> the support for <code>SimpleSDMLayers</code> plotting (now handled in the package) [#422]</p></li><li><p><strong>removed</strong> the support for <code>OccurrencesInterface</code> plotting (now handled in the package) [#422]</p></li></ul><h2 id="v1.5.0" tabindex="-1"><code>v1.5.0</code> <a class="header-anchor" href="#v1.5.0" aria-label="Permalink to &quot;`v1.5.0` {#v1.5.0}&quot;">​</a></h2><ul><li><strong>replaced</strong> the pseudo absences data by the <code>PseudoAbsences</code> package [#411]</li></ul><h2 id="v1.4.3" tabindex="-1"><code>v1.4.3</code> <a class="header-anchor" href="#v1.4.3" aria-label="Permalink to &quot;`v1.4.3` {#v1.4.3}&quot;">​</a></h2><ul><li><p><strong>improved</strong> the performance of polygon masking with threading</p></li><li><p><strong>added</strong> a <code>mask</code> method for layers and polygons (in addition to <code>mask!</code> and similar to <code>trim</code>)</p></li><li><p><strong>fixed</strong> the <code>simplify</code>/<code>simplify!</code> functions to ensure that the first and last points are the same</p></li></ul><h2 id="v1.4.2" tabindex="-1"><code>v1.4.2</code> <a class="header-anchor" href="#v1.4.2" aria-label="Permalink to &quot;`v1.4.2` {#v1.4.2}&quot;">​</a></h2><ul><li><p><strong>added</strong> an <code>openstreetmap</code> method (not exported) to get various GeoJSON limits from plan-text queries</p></li><li><p><strong>added</strong> a <code>simplify</code> and <code>simplify!</code> method to remove some complexity from OSM polygons</p></li><li><p><strong>fixed</strong> the vignettes so they don&#39;t use GADM</p></li></ul><h2 id="v1.4.1" tabindex="-1"><code>v1.4.1</code> <a class="header-anchor" href="#v1.4.1" aria-label="Permalink to &quot;`v1.4.1` {#v1.4.1}&quot;">​</a></h2><ul><li><p><strong>fixed</strong> a bug where GeoJSON GADM files were not readable by <code>ZipFiles</code></p></li><li><p><strong>added</strong> a dependency on <code>ZipArchives</code></p></li><li><p><strong>removed</strong> a dependency on <code>ZipFile</code></p></li></ul><h2 id="v1.4.0" tabindex="-1"><code>v1.4.0</code> <a class="header-anchor" href="#v1.4.0" aria-label="Permalink to &quot;`v1.4.0` {#v1.4.0}&quot;">​</a></h2><ul><li><strong>added</strong> (preliminary) support for STAC via an extension</li></ul><h2 id="v1.3.2" tabindex="-1"><code>v1.3.2</code> <a class="header-anchor" href="#v1.3.2" aria-label="Permalink to &quot;`v1.3.2` {#v1.3.2}&quot;">​</a></h2><ul><li><p><strong>added</strong> a method for <code>boundingbox</code> on a vector of abstract occurrences</p></li><li><p><strong>added</strong> methods for <code>latitude</code> and <code>longitude</code> on a vector of abstract occurrences</p></li></ul><h2 id="v1.3.1" tabindex="-1"><code>v1.3.1</code> <a class="header-anchor" href="#v1.3.1" aria-label="Permalink to &quot;`v1.3.1` {#v1.3.1}&quot;">​</a></h2><ul><li><p><strong>added</strong> support for nightly in github actions</p></li><li><p><strong>improved</strong> the performance of pseudo-absence distance to event by making it threaded</p></li></ul><h2 id="v1.3.0" tabindex="-1"><code>v1.3.0</code> <a class="header-anchor" href="#v1.3.0" aria-label="Permalink to &quot;`v1.3.0` {#v1.3.0}&quot;">​</a></h2><ul><li><p><strong>changed</strong> Julia requirement to LTS</p></li><li><p><strong>changed</strong> the github actions to work on LTS and latest release</p></li><li><p><strong>added</strong> support for <code>SpatialBoundaries</code> wombling through an extension</p></li><li><p><strong>added</strong> <code>SpatialBoundaries</code> version 0.2 <em>(WEAKDEP)</em></p></li><li><p><strong>added</strong> tutorials for spatial boundaries and virtual species</p></li><li><p><strong>improved</strong> the CI time by preventing a run of the full test suite when testing SDT</p></li></ul><h2 id="v1.2.4" tabindex="-1"><code>v1.2.4</code> <a class="header-anchor" href="#v1.2.4" aria-label="Permalink to &quot;`v1.2.4` {#v1.2.4}&quot;">​</a></h2><ul><li><strong>improved</strong> the performance of measuring distances from observed presence data</li></ul><h2 id="v1.2.3" tabindex="-1"><code>v1.2.3</code> <a class="header-anchor" href="#v1.2.3" aria-label="Permalink to &quot;`v1.2.3` {#v1.2.3}&quot;">​</a></h2><ul><li><strong>changed</strong> the compat entry of <code>MakieCore</code> from <code>0.8</code> to <code>0.8, 0.9</code></li></ul><h2 id="v1.2.2" tabindex="-1"><code>v1.2.2</code> <a class="header-anchor" href="#v1.2.2" aria-label="Permalink to &quot;`v1.2.2` {#v1.2.2}&quot;">​</a></h2><ul><li><strong>fixed</strong> dispatch of masking a vector of layers using polygons to work on any</li></ul><p><code>Vector{&lt;:SDMLayer}</code></p><h2 id="v1.2.1" tabindex="-1"><code>v1.2.1</code> <a class="header-anchor" href="#v1.2.1" aria-label="Permalink to &quot;`v1.2.1` {#v1.2.1}&quot;">​</a></h2><ul><li><strong>improved</strong> the performance of masking a vector of layers using polygons</li></ul><h2 id="v1.2.0" tabindex="-1"><code>v1.2.0</code> <a class="header-anchor" href="#v1.2.0" aria-label="Permalink to &quot;`v1.2.0` {#v1.2.0}&quot;">​</a></h2><ul><li><strong>added</strong> <code>SimpleSDMDatasets</code> version 1</li></ul><h2 id="v1.1.1" tabindex="-1"><code>v1.1.1</code> <a class="header-anchor" href="#v1.1.1" aria-label="Permalink to &quot;`v1.1.1` {#v1.1.1}&quot;">​</a></h2><ul><li><strong>fixed</strong> issues with the download of some GADM files</li></ul><h2 id="v1.1.0" tabindex="-1"><code>v1.1.0</code> <a class="header-anchor" href="#v1.1.0" aria-label="Permalink to &quot;`v1.1.0` {#v1.1.0}&quot;">​</a></h2><ul><li><strong>added</strong> <code>boundingbox</code> method to get the left, right, bottom, top coordinates of an object in WGS84</li></ul><h2 id="v1.0.0" tabindex="-1"><code>v1.0.0</code> <a class="header-anchor" href="#v1.0.0" aria-label="Permalink to &quot;`v1.0.0` {#v1.0.0}&quot;">​</a></h2><ul><li><p><strong>added</strong> <code>OccurrencesInterface</code> version 1</p></li><li><p><strong>added</strong> <code>Fauxcurrences</code> version 1</p></li><li><p><strong>added</strong> <code>GBIF</code> version 1</p></li><li><p><strong>added</strong> <code>SDeMo</code> version 1</p></li></ul>',38)]))}const u=o(i,[["render",d]]);export{g as __pageData,u as default};
