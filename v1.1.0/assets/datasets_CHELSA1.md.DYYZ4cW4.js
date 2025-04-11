import{_ as o,c as d,a2 as c,o as t}from"./chunks/framework.DF-HKlxZ.js";const S=JSON.parse('{"title":"CHELSA1","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/CHELSA1.md","filePath":"datasets/CHELSA1.md","lastUpdated":null}'),a={name:"datasets/CHELSA1.md"};function s(r,e,_,M,C,i){return t(),d("div",null,e[0]||(e[0]=[c(`<h1 id="chelsa1" tabindex="-1">CHELSA1 <a class="header-anchor" href="#chelsa1" aria-label="Permalink to &quot;CHELSA1&quot;">​</a></h1><div class="warning custom-block"><p class="custom-block-title">Deprecated dataset</p><p>This dataset is included for reference, but is considered deprecated, and should be replaced by <code>CHELSA2</code>.</p></div><p>CHELSA (Climatologies at high resolution for the earth’s land surface areas) is a very high resolution (30 arc sec, ~1km) global downscaled climate data set currently hosted by the Swiss Federal Institute for Forest, Snow and Landscape Research WSL. It is built to provide free access to high resolution climate data for research and application, and is constantly updated and refined.</p><details class="details custom-block"><summary>Citations</summary><p>Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017): Climatologies at high resolution for the Earth land surface areas. Scientific Data. 4 170122.</p><p>Karger D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E, Linder, H.P., Kessler, M. (2018): Data from: Climatologies at high resolution for the earth’s land surface areas. Dryad digital repository. <a href="http://dx.doi.org/doi:10.5061/dryad.kd1d4" target="_blank" rel="noreferrer">http://dx.doi.org/doi:10.5061/dryad.kd1d4</a></p></details><p>For more information about this provider: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><h2 id="averagetemperature" tabindex="-1">AverageTemperature <a class="header-anchor" href="#averagetemperature" aria-label="Permalink to &quot;AverageTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, AverageTemperature))  </span></span></code></pre></div><p>Average temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA1, AverageTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for RCP26</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP45</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP60</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP85</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><h2 id="bioclim" tabindex="-1">BioClim <a class="header-anchor" href="#bioclim" aria-label="Permalink to &quot;BioClim&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, BioClim))  </span></span></code></pre></div><p>The BioClim variables are derived from monthly data about precipitation and temperature, and convey information about annual variation, as well as extreme values for specific quarters. These variables are usually thought to represent limiting environmental conditions.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/bioclim/" target="_blank" rel="noreferrer">https://chelsa-climate.org/bioclim/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>BIO8</code></td><td style="text-align:right;">Mean Temperature of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO14</code></td><td style="text-align:right;">Precipitation of Driest Month</td></tr><tr><td style="text-align:right;"><code>BIO16</code></td><td style="text-align:right;">Precipitation of Wettest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO18</code></td><td style="text-align:right;">Precipitation of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO19</code></td><td style="text-align:right;">Precipitation of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO10</code></td><td style="text-align:right;">Mean Temperature of Warmest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO12</code></td><td style="text-align:right;">Annual Precipitation</td></tr><tr><td style="text-align:right;"><code>BIO13</code></td><td style="text-align:right;">Precipitation of Wettest Month</td></tr><tr><td style="text-align:right;"><code>BIO2</code></td><td style="text-align:right;">Mean Diurnal Range (Mean of monthly (max temp - min temp))</td></tr><tr><td style="text-align:right;"><code>BIO11</code></td><td style="text-align:right;">Mean Temperature of Coldest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO6</code></td><td style="text-align:right;">Min Temperature of Coldest Month</td></tr><tr><td style="text-align:right;"><code>BIO4</code></td><td style="text-align:right;">Temperature Seasonality (standard deviation ×100)</td></tr><tr><td style="text-align:right;"><code>BIO17</code></td><td style="text-align:right;">Precipitation of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO7</code></td><td style="text-align:right;">Temperature Annual Range (BIO5-BIO6)</td></tr><tr><td style="text-align:right;"><code>BIO1</code></td><td style="text-align:right;">Annual Mean Temperature</td></tr><tr><td style="text-align:right;"><code>BIO5</code></td><td style="text-align:right;">Max Temperature of Warmest Month</td></tr><tr><td style="text-align:right;"><code>BIO9</code></td><td style="text-align:right;">Mean Temperature of Driest Quarter</td></tr><tr><td style="text-align:right;"><code>BIO3</code></td><td style="text-align:right;">Isothermality (BIO2/BIO7) (×100)</td></tr><tr><td style="text-align:right;"><code>BIO15</code></td><td style="text-align:right;">Precipitation Seasonality (Coefficient of Variation)</td></tr></tbody></table></details><details class="details custom-block"><summary>Projections for RCP26</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP45</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP60</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP85</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><h2 id="maximumtemperature" tabindex="-1">MaximumTemperature <a class="header-anchor" href="#maximumtemperature" aria-label="Permalink to &quot;MaximumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, MaximumTemperature))  </span></span></code></pre></div><p>Maximum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA1, MaximumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for RCP26</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP45</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP60</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP85</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><h2 id="minimumtemperature" tabindex="-1">MinimumTemperature <a class="header-anchor" href="#minimumtemperature" aria-label="Permalink to &quot;MinimumTemperature&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, MinimumTemperature))  </span></span></code></pre></div><p>Minimum temperature within each grid cell, usually represented in degrees, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA1, MinimumTemperature})</code>.</p></details><details class="details custom-block"><summary>Projections for RCP26</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP45</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP60</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP85</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><h2 id="precipitation" tabindex="-1">Precipitation <a class="header-anchor" href="#precipitation" aria-label="Permalink to &quot;Precipitation&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA1, Precipitation))  </span></span></code></pre></div><p>Precipitation (rainfall) within each grid cell, usually represented as the total amount received, and usually provided as part of a dataset giving daily, weekly, or monthly temporal resolution.</p><p>For more information about this dataset: <a href="https://chelsa-climate.org/" target="_blank" rel="noreferrer">https://chelsa-climate.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>month</code></summary><p>This dataset can be accessed monthly, using the <code>month</code> keyword argument. You can list the available months using <code>SimpleSDMDatasets.months(RasterData{CHELSA1, Precipitation})</code>.</p></details><details class="details custom-block"><summary>Projections for RCP26</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP45</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP60</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details><details class="details custom-block"><summary>Projections for RCP85</summary><p>Note that the future scenarios support the <em>same</em> keyword arguments as the contemporary data.</p><p><strong>Models</strong>: <code>ACCESS1_0</code>, <code>BNU_ESM</code>, <code>CCSM4</code>, <code>CESM1_BGC</code>, <code>CESM1_CAM5</code>, <code>CMCC_CESM</code>, <code>CMCC_CM</code>, <code>CMCC_CMS</code>, <code>CNRM_CM5</code>, <code>CSIRO_Mk3L_1_2</code>, <code>CSIRO_Mk3_6_0</code>, <code>CanESM2</code>, <code>EC_EARTH</code>, <code>FGOALS_g2</code>, <code>FIO_ESM</code>, <code>GFDL_CM3</code>, <code>GFDL_ESM2G</code>, <code>GFDL_ESM2M</code>, <code>GISS_E2_H</code>, <code>GISS_E2_H_CC</code>, <code>GISS_E2_R</code>, <code>GISS_E2_R_CC</code>, <code>HadGEM2_AO</code>, <code>HadGEM2_CC</code>, <code>HadGEM2_ES</code>, <code>IPSL_CM5A_LR</code>, <code>IPSL_CM5A_MR</code>, <code>MIROC5</code>, <code>MIROC_ESM</code>, <code>MIROC_ESM_CHEM</code>, <code>MPI_ESM_LR</code>, <code>MPI_ESM_MR</code>, <code>MRI_CGCM3</code>, <code>MRI_ESM1</code> and <code>NorESM1_ME</code></p><p><strong>Timespans</strong>: Year(2041) =&gt; Year(2060) and Year(2061) =&gt; Year(2080)</p></details>`,50)]))}const l=o(a,[["render",s]]);export{S as __pageData,l as default};
