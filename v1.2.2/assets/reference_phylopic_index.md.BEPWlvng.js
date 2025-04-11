import{_ as n,C as o,c as p,o as r,j as i,a as e,ag as a,G as l}from"./chunks/framework.RaFiNGy7.js";const B=JSON.parse('{"title":"Phylopic","description":"","frontmatter":{},"headers":[],"relativePath":"reference/phylopic/index.md","filePath":"reference/phylopic/index.md","lastUpdated":null}'),h={name:"reference/phylopic/index.md"},d={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},A={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},D={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""};function T(j,s,P,v,U,I){const t=o("Badge");return r(),p("div",null,[s[39]||(s[39]=i("h1",{id:"phylopic",tabindex:"-1"},[e("Phylopic "),i("a",{class:"header-anchor",href:"#phylopic","aria-label":'Permalink to "Phylopic"'},"​")],-1)),i("details",d,[i("summary",null,[s[0]||(s[0]=i("a",{id:"Phylopic._get_uuids_at_page-Tuple{Any, Any}",href:"#Phylopic._get_uuids_at_page-Tuple{Any, Any}"},[i("span",{class:"jlbinding"},"Phylopic._get_uuids_at_page")],-1)),s[1]||(s[1]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[2]||(s[2]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">_get_uuids_at_page</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(query, page)</span></span></code></pre></div><p>This function is an internal helped function to return an array of pairs, wherein each pair maps a name to a UUID, for a given query and page. These outpurs are collected in a dictionary by <code>Phylopic.names</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/imagesof.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",c,[i("summary",null,[s[3]||(s[3]=i("a",{id:"Phylopic.attribution-Tuple{Base.UUID}",href:"#Phylopic.attribution-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.attribution")],-1)),s[4]||(s[4]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[5]||(s[5]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">attribution</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Generates a string for the attribution of an image, as identified by its <code>uuid</code>. This string is markdown-formatted, and will include a link to the license.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/attribution.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",k,[i("summary",null,[s[6]||(s[6]=i("a",{id:"Phylopic.autocomplete-Tuple{AbstractString}",href:"#Phylopic.autocomplete-Tuple{AbstractString}"},[i("span",{class:"jlbinding"},"Phylopic.autocomplete")],-1)),s[7]||(s[7]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[8]||(s[8]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">autocomplete</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractString</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Performs an autocomplete query based on a string, which must be at least two characters in length.</p><p>This function will return an <em>array</em> of strings, which can be empty if there are no matches. In you want to do things depending on the values returned, check them with <code>isempty</code>, not <code>isnothing</code>.</p><p>The output of this function, when not empty, can be passed to either <code>Phylopic.nodes</code> or <code>Phylopic.images</code> using their <code>filter_name</code> keyword argument. Note that the <code>filter_name</code> argument accepts a <em>single</em> name, not an array of names.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/autocomplete.jl#L1-L9" target="_blank" rel="noreferrer">source</a></p>',5))]),i("details",u,[i("summary",null,[s[9]||(s[9]=i("a",{id:"Phylopic.available_resolutions-Tuple{Base.UUID}",href:"#Phylopic.available_resolutions-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.available_resolutions")],-1)),s[10]||(s[10]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[11]||(s[11]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">available_resolutions</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the available resolutions for a raster image given its UUID. The resolutions are given as a string, and can be passed as a second argument to the <code>Phylopic.raster</code> function. As the raster sizes can be different, there is no default argument to Phylopic.raster, and the first image will be used instead.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L53-L57" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",g,[i("summary",null,[s[12]||(s[12]=i("a",{id:"Phylopic.build-Tuple{}",href:"#Phylopic.build-Tuple{}"},[i("span",{class:"jlbinding"},"Phylopic.build")],-1)),s[13]||(s[13]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[14]||(s[14]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">build</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()</span></span></code></pre></div><p>Returns the current build to perform the queries</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/ping.jl#L19-L23" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",y,[i("summary",null,[s[15]||(s[15]=i("a",{id:"Phylopic.imagesof-Tuple{AbstractString}",href:"#Phylopic.imagesof-Tuple{AbstractString}"},[i("span",{class:"jlbinding"},"Phylopic.imagesof")],-1)),s[16]||(s[16]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[17]||(s[17]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">imagesof</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(name</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractString</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; items</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, attribution</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, sharealike</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, nocommercial</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns a mapping between names and UUIDs of images for a given text (see also <code>Phylopic.autocomplete</code> to find relevant names). By default, the search will return images that come without BY, SA, and NC clauses (<em>i.e.</em> public domain dedication), but this can be changed using the keyword arguments.</p><p><code>items</code> : Default to 1 : Specifies the number of items to return. When a single item is returned, it is return as a pair mapping the name to the UUID; when there are more than 1, they are returned as a dictionary</p><p><code>attribution</code> : Default to <code>false</code> : Specifies whether the images returned require attribution to the creator</p><p><code>sharealike</code> : Default to <code>false</code> : Specifies whether the images returned require sharing of derived products using a license with a SA clause</p><p><code>nocommercial</code> : Default to <code>false</code> : Specifies whether the images returned are prevented from being used in commercial projects</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/imagesof.jl#L16-L36" target="_blank" rel="noreferrer">source</a></p>',7))]),i("details",b,[i("summary",null,[s[18]||(s[18]=i("a",{id:"Phylopic.ping-Tuple{}",href:"#Phylopic.ping-Tuple{}"},[i("span",{class:"jlbinding"},"Phylopic.ping")],-1)),s[19]||(s[19]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[20]||(s[20]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">ping</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">()</span></span></code></pre></div><p>This function will perform a simple ping of the API, and return <code>nothing</code> if it is responding, and throw and <code>ErrorException</code> (containing the string <code>&quot;not responding&quot;</code>) if the API does not returns a <code>204 No Content</code> success status.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/ping.jl#L4-L8" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",A,[i("summary",null,[s[21]||(s[21]=i("a",{id:"Phylopic.raster-Tuple{Base.UUID, Any}",href:"#Phylopic.raster-Tuple{Base.UUID, Any}"},[i("span",{class:"jlbinding"},"Phylopic.raster")],-1)),s[22]||(s[22]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[23]||(s[23]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">raster</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, resl)</span></span></code></pre></div><p>Returns the URL to an image in raster format, at the given resolution. Available resolutions for any image can be obtained with <code>Phylopic.available_resolutions</code>.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L72-L76" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",f,[i("summary",null,[s[24]||(s[24]=i("a",{id:"Phylopic.raster-Tuple{Base.UUID}",href:"#Phylopic.raster-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.raster")],-1)),s[25]||(s[25]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[26]||(s[26]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">raster</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the URL to an image in raster format when no resolution is specified. In this case, the first (usually the largest) image will be returned.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L87-L91" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",m,[i("summary",null,[s[27]||(s[27]=i("a",{id:"Phylopic.source-Tuple{Base.UUID}",href:"#Phylopic.source-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.source")],-1)),s[28]||(s[28]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[29]||(s[29]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">source</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the source image for a UUID.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L21-L25" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",C,[i("summary",null,[s[30]||(s[30]=i("a",{id:"Phylopic.thumbnail-Tuple{Base.UUID}",href:"#Phylopic.thumbnail-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.thumbnail")],-1)),s[31]||(s[31]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[32]||(s[32]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">thumbnail</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">; resolution</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">192</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the URL (if it exists) to the thumbnails for the silhouette. The thumbnail <code>resolution</code> can be <code>64</code>, <code>128</code>, or <code>192</code> (the default).</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L31-L35" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",D,[i("summary",null,[s[33]||(s[33]=i("a",{id:"Phylopic.twitterimage-Tuple{Base.UUID}",href:"#Phylopic.twitterimage-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.twitterimage")],-1)),s[34]||(s[34]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[35]||(s[35]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">twitterimage</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the twitter image for a UUID.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L11-L15" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",_,[i("summary",null,[s[36]||(s[36]=i("a",{id:"Phylopic.vector-Tuple{Base.UUID}",href:"#Phylopic.vector-Tuple{Base.UUID}"},[i("span",{class:"jlbinding"},"Phylopic.vector")],-1)),s[37]||(s[37]=e()),l(t,{type:"info",class:"jlObjectType jlMethod",text:"Method"})]),s[38]||(s[38]=a('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Phylopic</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">vector</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(uuid</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">UUIDs.UUID</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Returns the URL (if it exists) to the original vector image for the silhouette. Note that the image must be identified by its UUID, not by a string.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/158207b59cf0ce3ca0b4913c82372e7f0fc95472/Phylopic/src/images.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))])])}const L=n(h,[["render",T]]);export{B as __pageData,L as default};
