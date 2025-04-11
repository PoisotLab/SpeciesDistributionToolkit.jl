import{_ as t,c as a,a2 as i,o as s}from"./chunks/framework.DF-HKlxZ.js";const f=JSON.parse('{"title":"SimpleSDMDatasets","description":"","frontmatter":{},"headers":[],"relativePath":"reference/datasets/index.md","filePath":"reference/datasets/index.md","lastUpdated":null}'),o={name:"reference/datasets/index.md"};function r(n,e,d,l,h,p){return s(),a("div",null,e[0]||(e[0]=[i('<h1 id="simplesdmdatasets" tabindex="-1">SimpleSDMDatasets <a class="header-anchor" href="#simplesdmdatasets" aria-label="Permalink to &quot;SimpleSDMDatasets&quot;">​</a></h1><p>The purpose of this package is to get raster datasets for use in biogeography work, retrieve them from online locations, and store them in a central location to avoid data duplication. Datasets are downloaded <em>upon request</em>, and only the required files are downloaded.</p><p>The package is built around two &quot;pillars&quot;:</p><ol><li><p>An <em>interface</em> based on traits, which specifies where the data live (remotely and locally), what the shape of the data is, and which keyword arguments are usable to query the data.</p></li><li><p>A <em>type system</em> to identify which datasets are accessible through various providers, and which future scenarios are available.</p></li></ol><p>The combination of the interface and the type system means that adding a new dataset is relatively straightforward, and in particular that there is no need to write dataset-specific code to download the files (beyond specifying where the data live).</p><p>The purpose of the documentation is to (i) provide a high-level overview of how to get data from a user point of view, (ii) list the datasets that are accessible for users through the package alongside their most important features and (iii) give a comprehensive overview of the way the interface works, to facilitate the addition of new data sources.</p>',6)]))}const m=t(o,[["render",r]]);export{f as __pageData,m as default};
