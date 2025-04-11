import{_ as a,c as e,a2 as t,o as n}from"./chunks/framework.ChLjt0KG.js";const u=JSON.parse('{"title":"... know which layers are provided?","description":"","frontmatter":{},"headers":[],"relativePath":"howto/know_layers_provided.md","filePath":"howto/know_layers_provided.md","lastUpdated":null}'),i={name:"howto/know_layers_provided.md"};function p(o,s,l,r,d,c){return n(),e("div",null,s[0]||(s[0]=[t(`<h1 id="...-know-which-layers-are-provided?" tabindex="-1">... know which layers are provided? <a class="header-anchor" href="#...-know-which-layers-are-provided?" aria-label="Permalink to &quot;... know which layers are provided? {#...-know-which-layers-are-provided?}&quot;">​</a></h1><p>This page gives an overview of the methods to get access to additional information about the data available through different data providers. Note that the documentation website has a series of auto-generated pages that summarize the same information.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> InteractiveUtils</span></span></code></pre></div><p>Note that when working from the REPL, <code>InteractiveUtils</code> is loaded by default.</p><p>Data are identified by a <code>RasterProvider</code> (<em>e.g.</em> the initiative or website providing the data), and a <code>RasterDataset</code> that is a collection of layers representing specific information.</p><h2 id="Listing-the-providers" tabindex="-1">Listing the providers <a class="header-anchor" href="#Listing-the-providers" aria-label="Permalink to &quot;Listing the providers {#Listing-the-providers}&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">subtypes</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(RasterProvider)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>6-element Vector{Any}:</span></span>
<span class="line"><span> BiodiversityMapping</span></span>
<span class="line"><span> CHELSA1</span></span>
<span class="line"><span> CHELSA2</span></span>
<span class="line"><span> EarthEnv</span></span>
<span class="line"><span> PaleoClim</span></span>
<span class="line"><span> WorldClim2</span></span></code></pre></div><h2 id="Listing-the-datasets-associated-to-a-provider" tabindex="-1">Listing the datasets associated to a provider <a class="header-anchor" href="#Listing-the-datasets-associated-to-a-provider" aria-label="Permalink to &quot;Listing the datasets associated to a provider {#Listing-the-datasets-associated-to-a-provider}&quot;">​</a></h2><p>The <code>provides</code> method from <code>SimpleSDMDatasets</code> will return <code>true</code> if the provide offers the dataset:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">[ds </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">for</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> ds </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">in</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> subtypes</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(RasterDataset) </span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">if</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">provides</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(WorldClim2, ds)]</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>9-element Vector{DataType}:</span></span>
<span class="line"><span> AverageTemperature</span></span>
<span class="line"><span> BioClim</span></span>
<span class="line"><span> Elevation</span></span>
<span class="line"><span> MaximumTemperature</span></span>
<span class="line"><span> MinimumTemperature</span></span>
<span class="line"><span> Precipitation</span></span>
<span class="line"><span> SolarRadiation</span></span>
<span class="line"><span> WaterVaporPressure</span></span>
<span class="line"><span> WindSpeed</span></span></code></pre></div><h2 id="Datasets-with-multiple-layers" tabindex="-1">Datasets with multiple layers <a class="header-anchor" href="#Datasets-with-multiple-layers" aria-label="Permalink to &quot;Datasets with multiple layers {#Datasets-with-multiple-layers}&quot;">​</a></h2><p>The <code>layers</code> and <code>layerdescriptions</code> methods return a list of layers:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">layers</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, BioClim))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>19-element Vector{String}:</span></span>
<span class="line"><span> &quot;BIO1&quot;</span></span>
<span class="line"><span> &quot;BIO2&quot;</span></span>
<span class="line"><span> &quot;BIO3&quot;</span></span>
<span class="line"><span> &quot;BIO4&quot;</span></span>
<span class="line"><span> &quot;BIO5&quot;</span></span>
<span class="line"><span> &quot;BIO6&quot;</span></span>
<span class="line"><span> &quot;BIO7&quot;</span></span>
<span class="line"><span> &quot;BIO8&quot;</span></span>
<span class="line"><span> &quot;BIO9&quot;</span></span>
<span class="line"><span> &quot;BIO10&quot;</span></span>
<span class="line"><span> &quot;BIO11&quot;</span></span>
<span class="line"><span> &quot;BIO12&quot;</span></span>
<span class="line"><span> &quot;BIO13&quot;</span></span>
<span class="line"><span> &quot;BIO14&quot;</span></span>
<span class="line"><span> &quot;BIO15&quot;</span></span>
<span class="line"><span> &quot;BIO16&quot;</span></span>
<span class="line"><span> &quot;BIO17&quot;</span></span>
<span class="line"><span> &quot;BIO18&quot;</span></span>
<span class="line"><span> &quot;BIO19&quot;</span></span></code></pre></div><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">SimpleSDMDatasets</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">layerdescriptions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(CHELSA2, BioClim))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>Dict{String, String} with 19 entries:</span></span>
<span class="line"><span>  &quot;BIO8&quot; =&gt; &quot;Mean Temperature of Wettest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO14&quot; =&gt; &quot;Precipitation of Driest Month&quot;</span></span>
<span class="line"><span>  &quot;BIO16&quot; =&gt; &quot;Precipitation of Wettest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO18&quot; =&gt; &quot;Precipitation of Warmest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO19&quot; =&gt; &quot;Precipitation of Coldest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO10&quot; =&gt; &quot;Mean Temperature of Warmest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO12&quot; =&gt; &quot;Annual Precipitation&quot;</span></span>
<span class="line"><span>  &quot;BIO13&quot; =&gt; &quot;Precipitation of Wettest Month&quot;</span></span>
<span class="line"><span>  &quot;BIO2&quot; =&gt; &quot;Mean Diurnal Range (Mean of monthly (max temp - min temp))&quot;</span></span>
<span class="line"><span>  &quot;BIO11&quot; =&gt; &quot;Mean Temperature of Coldest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO6&quot; =&gt; &quot;Min Temperature of Coldest Month&quot;</span></span>
<span class="line"><span>  &quot;BIO4&quot; =&gt; &quot;Temperature Seasonality (standard deviation ×100)&quot;</span></span>
<span class="line"><span>  &quot;BIO17&quot; =&gt; &quot;Precipitation of Driest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO7&quot; =&gt; &quot;Temperature Annual Range (BIO5-BIO6)&quot;</span></span>
<span class="line"><span>  &quot;BIO1&quot; =&gt; &quot;Annual Mean Temperature&quot;</span></span>
<span class="line"><span>  &quot;BIO5&quot; =&gt; &quot;Max Temperature of Warmest Month&quot;</span></span>
<span class="line"><span>  &quot;BIO9&quot; =&gt; &quot;Mean Temperature of Driest Quarter&quot;</span></span>
<span class="line"><span>  &quot;BIO3&quot; =&gt; &quot;Isothermality (BIO2/BIO7) (×100)&quot;</span></span>
<span class="line"><span>  &quot;BIO15&quot; =&gt; &quot;Precipitation Seasonality (Coefficient of Variation)&quot;</span></span></code></pre></div><h2 id="Related-documentation" tabindex="-1">Related documentation <a class="header-anchor" href="#Related-documentation" aria-label="Permalink to &quot;Related documentation {#Related-documentation}&quot;">​</a></h2><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SimpleSDMDatasets.RasterDataset-howto-know_layers_provided" href="#SimpleSDMDatasets.RasterDataset-howto-know_layers_provided">#</a> <b><u>SimpleSDMDatasets.RasterDataset</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterDataset</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as being a dataset. Datasets are given by <code>RasterProvider</code>s, and the same dataset can have multiple providers.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6697ecce5820d923f8af87ca570f24c36d99117e/SimpleSDMDatasets/src/types/datasets.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p></div><br><div style="border-width:1px;border-style:solid;border-color:black;padding:1em;border-radius:25px;"><a id="SimpleSDMDatasets.RasterProvider-howto-know_layers_provided" href="#SimpleSDMDatasets.RasterProvider-howto-know_layers_provided">#</a> <b><u>SimpleSDMDatasets.RasterProvider</u></b> — <i>Type</i>. <div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">RasterProvider</span></span></code></pre></div><p>This is an <em>abstract</em> type to label something as a provider of <code>RasterDataset</code>s. For example, WorldClim2 and CHELSA2 are <code>RasterProvider</code>s.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/6697ecce5820d923f8af87ca570f24c36d99117e/SimpleSDMDatasets/src/types/providers.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p></div><br>`,23)]))}const k=a(i,[["render",p]]);export{u as __pageData,k as default};
