import{_ as e,c as a,o as i,ag as r}from"./chunks/framework.CVdKYWal.js";const p=JSON.parse('{"title":"PaleoClim","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/PaleoClim.md","filePath":"datasets/PaleoClim.md","lastUpdated":null}'),l={name:"datasets/PaleoClim.md"};function o(d,t,s,n,c,g){return i(),a("div",null,t[0]||(t[0]=[r(`<h1 id="paleoclim" tabindex="-1">PaleoClim <a class="header-anchor" href="#paleoclim" aria-label="Permalink to &quot;PaleoClim&quot;">​</a></h1><p>PaleoClim provides high-resolution paleoclimate data for use in biological modeling and GIS. The data were generated based in part on <a href="https://chelsa-climate.org/last-glacial-maximum-climate/" target="_blank" rel="noreferrer">CHELSA</a> data.</p><details class="details custom-block"><summary>Citation</summary><p>Brown, Hill, Dolan, Carnaval, Haywood. PaleoClim, high spatial resolution paleoclimate surfaces for global land areas. Scientific Data. 5:18025 (2018).</p></details><p>For more information about this provider: <a href="http://www.paleoclim.org/" target="_blank" rel="noreferrer">http://www.paleoclim.org/</a></p><h2 id="bioclim" tabindex="-1">BioClim <a class="header-anchor" href="#bioclim" aria-label="Permalink to &quot;BioClim&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(PaleoClim, BioClim))  </span></span></code></pre></div><p>The BioClim variables are derived from monthly data about precipitation and temperature, and convey information about annual variation, as well as extreme values for specific quarters. These variables are usually thought to represent limiting environmental conditions.</p><p>For more information about this dataset: <a href="http://www.paleoclim.org/" target="_blank" rel="noreferrer">http://www.paleoclim.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>BIO8</code></td><td style="text-align:right;">Mean Temperature of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO14</code></td><td style="text-align:right;">Precipitation of Driest Month</td></tr><tr><td style="text-align:right;"><code>BIO16</code></td><td style="text-align:right;">Precipitation of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO18</code></td><td style="text-align:right;">Precipitation of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO19</code></td><td style="text-align:right;">Precipitation of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO10</code></td><td style="text-align:right;">Mean Temperature of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO12</code></td><td style="text-align:right;">Annual Precipitation</td></tr><tr><td style="text-align:right;"><code>BIO13</code></td><td style="text-align:right;">Precipitation of Wettest Month</td></tr><tr><td style="text-align:right;"><code>BIO2</code></td><td style="text-align:right;">Mean Diurnal Range (Mean of monthly (max temp - min temp))</td></tr><tr><td style="text-align:right;"><code>BIO11</code></td><td style="text-align:right;">Mean Temperature of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO6</code></td><td style="text-align:right;">Min Temperature of Coldest Month</td></tr><tr><td style="text-align:right;"><code>BIO4</code></td><td style="text-align:right;">Temperature Seasonality (standard deviation ×100)</td></tr><tr><td style="text-align:right;"><code>BIO17</code></td><td style="text-align:right;">Precipitation of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO7</code></td><td style="text-align:right;">Temperature Annual Range (BIO5-BIO6)</td></tr><tr><td style="text-align:right;"><code>BIO1</code></td><td style="text-align:right;">Annual Mean Temperature</td></tr><tr><td style="text-align:right;"><code>BIO5</code></td><td style="text-align:right;">Max Temperature of Warmest Month</td></tr><tr><td style="text-align:right;"><code>BIO9</code></td><td style="text-align:right;">Mean Temperature of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO3</code></td><td style="text-align:right;">Isothermality (BIO2/BIO7) (×100)</td></tr><tr><td style="text-align:right;"><code>BIO15</code></td><td style="text-align:right;">Precipitation Seasonality (Coefficient of Variation)</td></tr></tbody></table></details><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>timeperiod</code></summary><p>Pleistocene: late-Holocene, Meghalayan (4.2-0.3 ka), - <code>LH</code></p><p>Pleistocene: mid-Holocene, Northgrippian (8.326-4.2 ka) - <code>MH</code></p><p>Pleistocene: early-Holocene, Greenlandian (11.7-8.326 ka) - <code>EH</code></p><p>Pleistocene: Younger Dryas Stadial (12.9-11.7 ka) - <code>YDS</code></p><p>Pleistocene: Bølling-Allerød ( 14.7-12.9 ka) - <code>BA</code></p><p>Pleistocene: Heinrich Stadial 1 (17.0-14.7 ka) - <code>HS1</code></p><p>Pleistocene: Last Interglacial (ca. 130 ka) - <code>LIG</code></p></details>`,11)]))}const m=e(l,[["render",o]]);export{p as __pageData,m as default};
