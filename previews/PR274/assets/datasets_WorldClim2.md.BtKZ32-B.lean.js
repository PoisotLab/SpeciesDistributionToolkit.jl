import{_ as a,c as o,a2 as t,o as d}from"./chunks/framework.Dcqa6ChI.js";const m=JSON.parse('{"title":"WorldClim2","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/WorldClim2.md","filePath":"datasets/WorldClim2.md","lastUpdated":null}'),s={name:"datasets/WorldClim2.md"};function c(r,e,i,n,l,_){return d(),o("div",null,e[0]||(e[0]=[t(`<h1 id="worldclim2" tabindex="-1">WorldClim2 <a class="header-anchor" href="#worldclim2" aria-label="Permalink to &quot;WorldClim2&quot;">​</a></h1><p>WorldClim is a database of high spatial resolution global weather and climate data. These data can be used for mapping and spatial modeling. The data are provided for use in research and related activities.</p><details class="details custom-block"><summary>Citation</summary><p>Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.</p></details><p>For more information about this provider:</p><h2 id="averagetemperature" tabindex="-1">AverageTemperature <a class="header-anchor" href="#averagetemperature" aria-label="Permalink to &quot;AverageTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, AverageTemperature))  </span></span></code></pre></div><p>Average temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, AverageTemperature})</code>.</p></details><h2 id="bioclim" tabindex="-1">BioClim <a class="header-anchor" href="#bioclim" aria-label="Permalink to &quot;BioClim&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, BioClim))  </span></span></code></pre></div><p>The BioClim variables are derived from monthly data about precipitation and temperature, and convey information about annual variation, as well as extreme values for specific quarters. These variables are usually thought to represent limiting environmental conditions.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>BIO8</code></td><td style="text-align:right;">Mean Temperature of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO14</code></td><td style="text-align:right;">Precipitation of Driest Month</td></tr><tr><td style="text-align:right;"><code>BIO16</code></td><td style="text-align:right;">Precipitation of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO18</code></td><td style="text-align:right;">Precipitation of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO19</code></td><td style="text-align:right;">Precipitation of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO10</code></td><td style="text-align:right;">Mean Temperature of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO12</code></td><td style="text-align:right;">Annual Precipitation</td></tr><tr><td style="text-align:right;"><code>BIO13</code></td><td style="text-align:right;">Precipitation of Wettest Month</td></tr><tr><td style="text-align:right;"><code>BIO2</code></td><td style="text-align:right;">Mean Diurnal Range (Mean of monthly (max temp - min temp))</td></tr><tr><td style="text-align:right;"><code>BIO11</code></td><td style="text-align:right;">Mean Temperature of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO6</code></td><td style="text-align:right;">Min Temperature of Coldest Month</td></tr><tr><td style="text-align:right;"><code>BIO4</code></td><td style="text-align:right;">Temperature Seasonality (standard deviation ×100)</td></tr><tr><td style="text-align:right;"><code>BIO17</code></td><td style="text-align:right;">Precipitation of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO7</code></td><td style="text-align:right;">Temperature Annual Range (BIO5-BIO6)</td></tr><tr><td style="text-align:right;"><code>BIO1</code></td><td style="text-align:right;">Annual Mean Temperature</td></tr><tr><td style="text-align:right;"><code>BIO5</code></td><td style="text-align:right;">Max Temperature of Warmest Month</td></tr><tr><td style="text-align:right;"><code>BIO9</code></td><td style="text-align:right;">Mean Temperature of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO3</code></td><td style="text-align:right;">Isothermality (BIO2/BIO7) (×100)</td></tr><tr><td style="text-align:right;"><code>BIO15</code></td><td style="text-align:right;">Precipitation Seasonality (Coefficient of Variation)</td></tr></tbody></table></details><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP245</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><h2 id="elevation" tabindex="-1">Elevation <a class="header-anchor" href="#elevation" aria-label="Permalink to &quot;Elevation&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, Elevation))  </span></span></code></pre></div><p>Information about elevation, that usually comes from a DEM.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><h2 id="maximumtemperature" tabindex="-1">MaximumTemperature <a class="header-anchor" href="#maximumtemperature" aria-label="Permalink to &quot;MaximumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, MaximumTemperature))  </span></span></code></pre></div><p>Maximum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, MaximumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP245</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><h2 id="minimumtemperature" tabindex="-1">MinimumTemperature <a class="header-anchor" href="#minimumtemperature" aria-label="Permalink to &quot;MinimumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, MinimumTemperature))  </span></span></code></pre></div><p>Minimum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, MinimumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP245</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><h2 id="precipitation" tabindex="-1">Precipitation <a class="header-anchor" href="#precipitation" aria-label="Permalink to &quot;Precipitation&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, Precipitation))  </span></span></code></pre></div><p>Precipitation (rainfall) within each grid cell, usually represented as the total amount received, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, Precipitation})</code>.</p></details><details class="details custom-block"><summary>Projections for SSP126</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP245</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP370</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>GFDL_ESM4</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><details class="details custom-block"><summary>Projections for SSP585</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS_CM2</code>, <code>ACCESS_ESM1_5</code>, <code>BCC_CSM2_MR</code>, <code>CMCC_ESM2</code>, <code>CNRM_CM6_1</code>, <code>CNRM_CM6_1_HR</code>, <code>CNRM_ESM2_1</code>, <code>CanESM5</code>, <code>CanESM5_CanOE</code>, <code>EC_Earth3_Veg</code>, <code>EC_Earth3_Veg_LR</code>, <code>FIO_ESM_2_0</code>, <code>GISS_E2_1_G</code>, <code>GISS_E2_1_H</code>, <code>HadGEM3_GC31_LL</code>, <code>INM_CM4_8</code>, <code>INM_CM5_0</code>, <code>IPSL_CM6A_LR</code>, <code>MIROC6</code>, <code>MIROC_ES2L</code>, <code>MPI_ESM1_2_HR</code>, <code>MPI_ESM1_2_LR</code>, <code>MRI_ESM2_0</code> and <code>UKESM1_0_LL</code></p><p><strong>Timespans</strong>: Year(2021) =&gt; Year(2040), Year(2041) =&gt; Year(2060), Year(2061) =&gt; Year(2080) and Year(2081) =&gt; Year(2100)</p></details><h2 id="solarradiation" tabindex="-1">SolarRadiation <a class="header-anchor" href="#solarradiation" aria-label="Permalink to &quot;SolarRadiation&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, SolarRadiation))  </span></span></code></pre></div><p>WorldClim is a database of high spatial resolution global weather and climate data. These data can be used for mapping and spatial modeling. The data are provided for use in research and related activities.</p><details class="details custom-block"><summary>Citation</summary><p>Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.</p></details><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, SolarRadiation})</code>.</p></details><h2 id="watervaporpressure" tabindex="-1">WaterVaporPressure <a class="header-anchor" href="#watervaporpressure" aria-label="Permalink to &quot;WaterVaporPressure&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, WaterVaporPressure))  </span></span></code></pre></div><p>WorldClim is a database of high spatial resolution global weather and climate data. These data can be used for mapping and spatial modeling. The data are provided for use in research and related activities.</p><details class="details custom-block"><summary>Citation</summary><p>Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.</p></details><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, WaterVaporPressure})</code>.</p></details><h2 id="windspeed" tabindex="-1">WindSpeed <a class="header-anchor" href="#windspeed" aria-label="Permalink to &quot;WindSpeed&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, WindSpeed))  </span></span></code></pre></div><p>WorldClim is a database of high spatial resolution global weather and climate data. These data can be used for mapping and spatial modeling. The data are provided for use in research and related activities.</p><details class="details custom-block"><summary>Citation</summary><p>Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.</p></details><p>For more information about this dataset: <a href="https://www.worldclim.org/data/index.html" target="_blank" rel="noreferrer">https://www.worldclim.org/data/index.html</a></p><details class="details custom-block"><summary>Keyword argument <code>resolution</code></summary><p>5 arc minutes - <code>5.0</code></p><p>30 arc seconds, approx. 1×1 km - <code>0.5</code></p><p>10 arc minutes - <code>10.0</code></p><p>2.5 arc minutes, approx 4×4 km - <code>2.5</code></p></details><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{WorldClim2, WindSpeed})</code>.</p></details>`,76)]))}const h=a(s,[["render",c]]);export{m as __pageData,h as default};
