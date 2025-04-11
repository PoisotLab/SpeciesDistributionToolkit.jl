import{_ as e,c as a,a2 as i,o as r}from"./chunks/framework.f24Mep3v.js";const y=JSON.parse('{"title":"EarthEnv","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/EarthEnv.md","filePath":"datasets/EarthEnv.md","lastUpdated":null}'),s={name:"datasets/EarthEnv.md"};function d(o,t,n,l,h,g){return r(),a("div",null,t[0]||(t[0]=[i(`<h1 id="earthenv" tabindex="-1">EarthEnv <a class="header-anchor" href="#earthenv" aria-label="Permalink to &quot;EarthEnv&quot;">​</a></h1><p>The EarthEnv project is a collaborative project of biodiversity scientists and remote sensing experts to develop near-global standardized, 1km resolution layers for monitoring and modeling biodiversity, ecosystems, and climate. The work is supported by NCEAS, NASA, NSF, and Yale University.</p><p>For more information about this provider: <a href="https://www.earthenv.org/" target="_blank" rel="noreferrer">https://www.earthenv.org/</a></p><h2 id="habitatheterogeneity" tabindex="-1">HabitatHeterogeneity <a class="header-anchor" href="#habitatheterogeneity" aria-label="Permalink to &quot;HabitatHeterogeneity&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(EarthEnv, HabitatHeterogeneity))  </span></span></code></pre></div><p>The dataset contains 14 metrics quantifying spatial heterogeneity of global habitat at multiple resolutions based on the textural features of Enhanced Vegetation Index (EVI) imagery acquired by the Moderate Resolution Imaging Spectroradiometer (MODIS). For additional information about the metrics and the evaluations of their utility for biodiversity modeling, please see the associated journal article:</p><details class="details custom-block"><summary>Citation</summary><p>Tuanmu, M.-N. and W. Jetz. (2015) A global, remote sensing-based characterization of terrestrial habitat heterogeneity for biodiversity and ecosystem modeling. Global Ecology and Biogeography. DOI: 10.1111/geb.12365.</p></details><p>For more information about this dataset: <a href="https://www.earthenv.org/texture" target="_blank" rel="noreferrer">https://www.earthenv.org/texture</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>Variance</code></td><td style="text-align:right;">Variance</td></tr><tr><td style="text-align:right;"><code>Range</code></td><td style="text-align:right;">Range</td></tr><tr><td style="text-align:right;"><code>Simpson</code></td><td style="text-align:right;">Simpson</td></tr><tr><td style="text-align:right;"><code>Shannon</code></td><td style="text-align:right;">Shannon</td></tr><tr><td style="text-align:right;"><code>Contrast</code></td><td style="text-align:right;">Contrast</td></tr><tr><td style="text-align:right;"><code>Uniformity</code></td><td style="text-align:right;">Uniformity</td></tr><tr><td style="text-align:right;"><code>Coefficient of variation</code></td><td style="text-align:right;">Coefficient of variation</td></tr><tr><td style="text-align:right;"><code>Evenness</code></td><td style="text-align:right;">Evenness</td></tr><tr><td style="text-align:right;"><code>Standard deviation</code></td><td style="text-align:right;">Standard deviation</td></tr><tr><td style="text-align:right;"><code>Correlation</code></td><td style="text-align:right;">Correlation</td></tr><tr><td style="text-align:right;"><code>Entropy</code></td><td style="text-align:right;">Entropy</td></tr><tr><td style="text-align:right;"><code>Dissimilarity</code></td><td style="text-align:right;">Dissimilarity</td></tr><tr><td style="text-align:right;"><code>Homogeneity</code></td><td style="text-align:right;">Homogeneity</td></tr><tr><td style="text-align:right;"><code>Maximum</code></td><td style="text-align:right;">Maximum</td></tr></tbody></table></details><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>25km - <code>12.5</code></p><p>1km - <code>0.5</code></p><p>5km - <code>2.5</code></p></details><h2 id="landcover" tabindex="-1">LandCover <a class="header-anchor" href="#landcover" aria-label="Permalink to &quot;LandCover&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(EarthEnv, LandCover))  </span></span></code></pre></div><p>The dataset integrates multiple global remote sensing-derived land-cover products and provide consensus information on the prevalence of 12 land-cover classes at 1-km resolution. For additional information about the integration approach and the evaluations of the datasets, please see the associated journal article:</p><details class="details custom-block"><summary>Citation</summary><p>Tuanmu, M.-N. and W. Jetz. 2014. A global 1-km consensus land-cover product for biodiversity and ecosystem modeling. Global Ecology and Biogeography 23(9): 1031-1045.</p></details><p>For more information about this dataset: <a href="https://www.earthenv.org/landcover" target="_blank" rel="noreferrer">https://www.earthenv.org/landcover</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>Evergreen/Deciduous Needleleaf Trees</code></td><td style="text-align:right;">Evergreen/Deciduous Needleleaf Trees</td></tr><tr><td style="text-align:right;"><code>Shrubs</code></td><td style="text-align:right;">Shrubs</td></tr><tr><td style="text-align:right;"><code>Herbaceous Vegetation</code></td><td style="text-align:right;">Herbaceous Vegetation</td></tr><tr><td style="text-align:right;"><code>Deciduous Broadleaf Trees</code></td><td style="text-align:right;">Deciduous Broadleaf Trees</td></tr><tr><td style="text-align:right;"><code>Open Water</code></td><td style="text-align:right;">Open Water</td></tr><tr><td style="text-align:right;"><code>Regularly Flooded Vegetation</code></td><td style="text-align:right;">Regularly Flooded Vegetation</td></tr><tr><td style="text-align:right;"><code>Cultivated and Managed Vegetation</code></td><td style="text-align:right;">Cultivated and Managed Vegetation</td></tr><tr><td style="text-align:right;"><code>Evergreen Broadleaf Trees</code></td><td style="text-align:right;">Evergreen Broadleaf Trees</td></tr><tr><td style="text-align:right;"><code>Mixed/Other Trees</code></td><td style="text-align:right;">Mixed/Other Trees</td></tr><tr><td style="text-align:right;"><code>Urban/Built-up</code></td><td style="text-align:right;">Urban/Built-up</td></tr><tr><td style="text-align:right;"><code>Snow/Ice</code></td><td style="text-align:right;">Snow/Ice</td></tr><tr><td style="text-align:right;"><code>Barren</code></td><td style="text-align:right;">Barren</td></tr></tbody></table></details><details class="details custom-block"><summary>Keyword argument <code>full</code></summary><p>Version with GlobCover (2005-06; v2.2), MODIS land-cover product (MCD12Q1; v051), GLC2000 (global product; v1.1), and DISCover (GLCC; v2) - <code>true</code></p><p>Version without DISCover - <code>false</code></p></details>`,17)]))}const p=e(s,[["render",d]]);export{y as __pageData,p as default};
