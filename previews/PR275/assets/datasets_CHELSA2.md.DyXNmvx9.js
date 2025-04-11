import{_ as t,c as a,a2 as s,o as r}from"./chunks/framework.BjRFXuln.js";const m=JSON.parse('{"title":"CHELSA2","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/CHELSA2.md","filePath":"datasets/CHELSA2.md","lastUpdated":null}'),o={name:"datasets/CHELSA2.md"};function i(d,e,n,l,c,p){return r(),a("div",null,e[0]||(e[0]=[s(`<h1 id="chelsa2" tabindex="-1">CHELSA2 <a class="header-anchor" href="#chelsa2" aria-label="Permalink to &quot;CHELSA2&quot;">​</a></h1><p>CHELSA (Climatologies at high resolution for the earth’s land surface areas) is a very high resolution (30 arc sec, ~1km) global downscaled climate data set currently hosted by the Swiss Federal Institute for Forest, Snow and Landscape Research WSL. It is built to provide free access to high resolution climate data for research and application, and is constantly updated and refined.</p><details class="details custom-block"><summary>Citations</summary><p>Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017): Climatologies at high resolution for the Earth land surface areas. Scientific Data. 4 170122.</p><p>Karger D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E, Linder, H.P., Kessler, M. (2018): Data from: Climatologies at high resolution for the earth’s land surface areas. EnviDat.</p></details><p>For more information about this provider: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><h2 id="averagetemperature" tabindex="-1">AverageTemperature <a class="header-anchor" href="#averagetemperature" aria-label="Permalink to &quot;AverageTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, AverageTemperature))  </span></span></code></pre></div><p>Average temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA2, AverageTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><h2 id="bioclim" tabindex="-1">BioClim <a class="header-anchor" href="#bioclim" aria-label="Permalink to &quot;BioClim&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, BioClim))  </span></span></code></pre></div><p>The BioClim variables are derived from monthly data about precipitation and temperature, and convey information about annual variation, as well as extreme values for specific quarters. These variables are usually thought to represent limiting environmental conditions.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>BIO8</code></td><td style="text-align:right;">Mean Temperature of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO14</code></td><td style="text-align:right;">Precipitation of Driest Month</td></tr><tr><td style="text-align:right;"><code>BIO16</code></td><td style="text-align:right;">Precipitation of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO18</code></td><td style="text-align:right;">Precipitation of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO19</code></td><td style="text-align:right;">Precipitation of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO10</code></td><td style="text-align:right;">Mean Temperature of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO12</code></td><td style="text-align:right;">Annual Precipitation</td></tr><tr><td style="text-align:right;"><code>BIO13</code></td><td style="text-align:right;">Precipitation of Wettest Month</td></tr><tr><td style="text-align:right;"><code>BIO2</code></td><td style="text-align:right;">Mean Diurnal Range (Mean of monthly (max temp - min temp))</td></tr><tr><td style="text-align:right;"><code>BIO11</code></td><td style="text-align:right;">Mean Temperature of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO6</code></td><td style="text-align:right;">Min Temperature of Coldest Month</td></tr><tr><td style="text-align:right;"><code>BIO4</code></td><td style="text-align:right;">Temperature Seasonality (standard deviation ×100)</td></tr><tr><td style="text-align:right;"><code>BIO17</code></td><td style="text-align:right;">Precipitation of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO7</code></td><td style="text-align:right;">Temperature Annual Range (BIO5-BIO6)</td></tr><tr><td style="text-align:right;"><code>BIO1</code></td><td style="text-align:right;">Annual Mean Temperature</td></tr><tr><td style="text-align:right;"><code>BIO5</code></td><td style="text-align:right;">Max Temperature of Warmest Month</td></tr><tr><td style="text-align:right;"><code>BIO9</code></td><td style="text-align:right;">Mean Temperature of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO3</code></td><td style="text-align:right;">Isothermality (BIO2/BIO7) (×100)</td></tr><tr><td style="text-align:right;"><code>BIO15</code></td><td style="text-align:right;">Precipitation Seasonality (Coefficient of Variation)</td></tr></tbody></table></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><h2 id="maximumtemperature" tabindex="-1">MaximumTemperature <a class="header-anchor" href="#maximumtemperature" aria-label="Permalink to &quot;MaximumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, MaximumTemperature))  </span></span></code></pre></div><p>Maximum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA2, MaximumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><h2 id="minimumtemperature" tabindex="-1">MinimumTemperature <a class="header-anchor" href="#minimumtemperature" aria-label="Permalink to &quot;MinimumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, MinimumTemperature))  </span></span></code></pre></div><p>Minimum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA2, MinimumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><h2 id="precipitation" tabindex="-1">Precipitation <a class="header-anchor" href="#precipitation" aria-label="Permalink to &quot;Precipitation&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, Precipitation))  </span></span></code></pre></div><p>Precipitation (rainfall) within each grid cell, usually represented as the total amount received, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA2, Precipitation})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>GFDL_ESM4</code>, <code>IPSL_CM6A_LR</code>, <code>MPI_ESM1_2_HR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2011) =&gt; Year(2040), Year(2041) =&gt; Year(2070) and Year(2071) =&gt; Year(2100)</p></details>`,44)]))}const g=t(o,[["render",i]]);export{m as __pageData,g as default};
