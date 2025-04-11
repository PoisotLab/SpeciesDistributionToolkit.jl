import{_ as i,c as a,a2 as e,o as s}from"./chunks/framework.BjRFXuln.js";const g=JSON.parse('{"title":"BiodiversityMapping","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/BiodiversityMapping.md","filePath":"datasets/BiodiversityMapping.md","lastUpdated":null}'),r={name:"datasets/BiodiversityMapping.md"};function l(n,t,d,o,h,p){return s(),a("div",null,t[0]||(t[0]=[e(`<h1 id="biodiversitymapping" tabindex="-1">BiodiversityMapping <a class="header-anchor" href="#biodiversitymapping" aria-label="Permalink to &quot;BiodiversityMapping&quot;">​</a></h1><p>Summary of the richness of different taxonomic groups at a 10x10 km resolution.</p><details class="details custom-block"><summary>Citation</summary><p>Jenkins, C.N., Pimm, S.L., and Joppa, L.N. (2013). Global patterns of terrestrial vertebrate diversity and conservation. Proc. Natl. Acad. Sci. U. S. A. 110, E2602-10.</p></details><p>For more information about this provider: <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a></p><h2 id="amphibianrichness" tabindex="-1">AmphibianRichness <a class="header-anchor" href="#amphibianrichness" aria-label="Permalink to &quot;AmphibianRichness&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(BiodiversityMapping, AmphibianRichness))  </span></span></code></pre></div><p>Summary of the richness of different taxonomic groups at a 10x10 km resolution.</p><details class="details custom-block"><summary>Citation</summary><p>Jenkins, C.N., Pimm, S.L., and Joppa, L.N. (2013). Global patterns of terrestrial vertebrate diversity and conservation. Proc. Natl. Acad. Sci. U. S. A. 110, E2602-10.</p></details><p>For more information about this dataset: <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>Gymnophiona</code></td><td style="text-align:right;">Gymnophiona</td></tr><tr><td style="text-align:right;"><code>Amphibians</code></td><td style="text-align:right;">Amphibians</td></tr><tr><td style="text-align:right;"><code>Anura</code></td><td style="text-align:right;">Anura</td></tr><tr><td style="text-align:right;"><code>Caudata</code></td><td style="text-align:right;">Caudata</td></tr></tbody></table></details><h2 id="birdrichness" tabindex="-1">BirdRichness <a class="header-anchor" href="#birdrichness" aria-label="Permalink to &quot;BirdRichness&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(BiodiversityMapping, BirdRichness))  </span></span></code></pre></div><p>Summary of the richness of different taxonomic groups at a 10x10 km resolution.</p><details class="details custom-block"><summary>Citation</summary><p>Jenkins, C.N., Pimm, S.L., and Joppa, L.N. (2013). Global patterns of terrestrial vertebrate diversity and conservation. Proc. Natl. Acad. Sci. U. S. A. 110, E2602-10.</p></details><p>For more information about this dataset: <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>Passeriformes</code></td><td style="text-align:right;">Passeriformes</td></tr><tr><td style="text-align:right;"><code>Birds</code></td><td style="text-align:right;">Birds</td></tr><tr><td style="text-align:right;"><code>Psittaciformes</code></td><td style="text-align:right;">Psittaciformes</td></tr><tr><td style="text-align:right;"><code>Trochilidae</code></td><td style="text-align:right;">Trochilidae</td></tr></tbody></table></details><h2 id="mammalrichness" tabindex="-1">MammalRichness <a class="header-anchor" href="#mammalrichness" aria-label="Permalink to &quot;MammalRichness&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark has-focused-lines vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> SpeciesDistributionToolkit</span></span>
<span class="line has-focus"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">layer </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> SDMLayer</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">RasterData</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(BiodiversityMapping, MammalRichness))  </span></span></code></pre></div><p>Summary of the richness of different taxonomic groups at a 10x10 km resolution.</p><details class="details custom-block"><summary>Citation</summary><p>Jenkins, C.N., Pimm, S.L., and Joppa, L.N. (2013). Global patterns of terrestrial vertebrate diversity and conservation. Proc. Natl. Acad. Sci. U. S. A. 110, E2602-10.</p></details><p>For more information about this dataset: <a href="https://biodiversitymapping.org/" target="_blank" rel="noreferrer">https://biodiversitymapping.org/</a></p><details class="details custom-block"><summary>Keyword argument <code>layer</code></summary><table tabindex="0"><thead><tr><th style="text-align:right;">Layer code</th><th style="text-align:right;">Description</th></tr></thead><tbody><tr><td style="text-align:right;"><code>Carnivora</code></td><td style="text-align:right;">Carnivora</td></tr><tr><td style="text-align:right;"><code>Chiroptera</code></td><td style="text-align:right;">Chiroptera</td></tr><tr><td style="text-align:right;"><code>Primates</code></td><td style="text-align:right;">Primates</td></tr><tr><td style="text-align:right;"><code>Rodentia</code></td><td style="text-align:right;">Rodentia</td></tr><tr><td style="text-align:right;"><code>Mammals</code></td><td style="text-align:right;">Mammals</td></tr><tr><td style="text-align:right;"><code>Cetartiodactyla</code></td><td style="text-align:right;">Cetartiodactyla</td></tr><tr><td style="text-align:right;"><code>Eulipotyphla</code></td><td style="text-align:right;">Eulipotyphla</td></tr><tr><td style="text-align:right;"><code>Marsupialia</code></td><td style="text-align:right;">Marsupialia</td></tr></tbody></table></details>`,22)]))}const y=i(r,[["render",l]]);export{g as __pageData,y as default};
