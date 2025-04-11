import{_ as l,C as h,c as p,o,j as i,a,G as t,ag as n}from"./chunks/framework.DfWWDbyc.js";const f=JSON.parse('{"title":"Internals","description":"","frontmatter":{},"headers":[],"relativePath":"reference/gbif/internals.md","filePath":"reference/gbif/internals.md","lastUpdated":null}'),k={name:"reference/gbif/internals.md"},r={class:"jldocstring custom-block",open:""},d={class:"jldocstring custom-block",open:""},c={class:"jldocstring custom-block",open:""};function A(g,s,y,u,C,D){const e=h("Badge");return o(),p("div",null,[s[10]||(s[10]=i("h1",{id:"internals",tabindex:"-1"},[a("Internals "),i("a",{class:"header-anchor",href:"#internals","aria-label":'Permalink to "Internals"'},"​")],-1)),i("details",r,[i("summary",null,[s[0]||(s[0]=i("a",{id:"GBIF.format_date",href:"#GBIF.format_date"},[i("span",{class:"jlbinding"},"GBIF.format_date")],-1)),s[1]||(s[1]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=i("p",null,[i("strong",null,"Internal function to format dates in records")],-1)),s[3]||(s[3]=i("p",null,[i("a",{href:"https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/types/GBIFRecords.jl#L43-L45",target:"_blank",rel:"noreferrer"},"source")],-1))]),i("details",d,[i("summary",null,[s[4]||(s[4]=i("a",{id:"GBIF.validate_occurrence_query",href:"#GBIF.validate_occurrence_query"},[i("span",{class:"jlbinding"},"GBIF.validate_occurrence_query")],-1)),s[5]||(s[5]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[6]||(s[6]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">validate_occurrence_query</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(query</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Pair</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Checks that the queries for occurrences searches are well formatted.</p><p>This is used internally.</p><p>Everything this function does is derived from the GBIF API documentation, including (and especially) the values for enum types. This modifies the queryset. Filters that are not allowed are removed, and filters that have incorrect values are dropped too.</p><p>This feels like the most conservative option – the user can always filter the results when they are returned.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/query.jl#L1-L15" target="_blank" rel="noreferrer">source</a></p>',6))]),i("details",c,[i("summary",null,[s[7]||(s[7]=i("a",{id:"Base.show",href:"#Base.show"},[i("span",{class:"jlbinding"},"Base.show")],-1)),s[8]||(s[8]=a()),t(e,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[9]||(s[9]=n(`<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">([io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> stdout], x)</span></span></code></pre></div><p>Write a text representation of a value <code>x</code> to the output stream <code>io</code>. New types <code>T</code> should overload <code>show(io::IO, x::T)</code>. The representation used by <code>show</code> generally includes Julia-specific formatting and type information, and should be parseable Julia code when possible.</p><p><a href="./@ref"><code>repr</code></a> returns the output of <code>show</code> as a string.</p><p>For a more verbose human-readable text output for objects of type <code>T</code>, define <code>show(io::IO, ::MIME&quot;text/plain&quot;, ::T)</code> in addition. Checking the <code>:compact</code> <a href="./@ref"><code>IOContext</code></a> key (often checked as <code>get(io, :compact, false)::Bool</code>) of <code>io</code> in such methods is recommended, since some containers show their elements by calling this method with <code>:compact =&gt; true</code>.</p><p>See also <a href="./@ref"><code>print</code></a>, which writes un-decorated representations.</p><p><strong>Examples</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Hello World!&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Hello World!&quot;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> print</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;Hello World!&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">Hello World!</span></span></code></pre></div><p><a href="https://github.com/JuliaLang/julia/blob/d63adeda50d5b8c440a7c29c9a65357a98fe927f/base/show.jl#L450-L476" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, mime, x)</span></span></code></pre></div><p>The <a href="./@ref"><code>display</code></a> functions ultimately call <code>show</code> in order to write an object <code>x</code> as a given <code>mime</code> type to a given I/O stream <code>io</code> (usually a memory buffer), if possible. In order to provide a rich multimedia representation of a user-defined type <code>T</code>, it is only necessary to define a new <code>show</code> method for <code>T</code>, via: <code>show(io, ::MIME&quot;mime&quot;, x::T) = ...</code>, where <code>mime</code> is a MIME-type string and the function body calls <a href="./@ref"><code>write</code></a> (or similar) to write that representation of <code>x</code> to <code>io</code>. (Note that the <code>MIME&quot;&quot;</code> notation only supports literal strings; to construct <code>MIME</code> types in a more flexible manner use <code>MIME{Symbol(&quot;&quot;)}</code>.)</p><p>For example, if you define a <code>MyImage</code> type and know how to write it to a PNG file, you could define a function <code>show(io, ::MIME&quot;image/png&quot;, x::MyImage) = ...</code> to allow your images to be displayed on any PNG-capable <code>AbstractDisplay</code> (such as IJulia). As usual, be sure to <code>import Base.show</code> in order to add new methods to the built-in Julia function <code>show</code>.</p><p>Technically, the <code>MIME&quot;mime&quot;</code> macro defines a singleton type for the given <code>mime</code> string, which allows us to exploit Julia&#39;s dispatch mechanisms in determining how to display objects of any given type.</p><p>The default MIME type is <code>MIME&quot;text/plain&quot;</code>. There is a fallback definition for <code>text/plain</code> output that calls <code>show</code> with 2 arguments, so it is not always necessary to add a method for that case. If a type benefits from custom human-readable output though, <code>show(::IO, ::MIME&quot;text/plain&quot;, ::T)</code> should be defined. For example, the <code>Day</code> type uses <code>1 day</code> as the output for the <code>text/plain</code> MIME type, and <code>Day(1)</code> as the output of 2-argument <code>show</code>.</p><p><strong>Examples</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;"> struct</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Day</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">           n</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Int</span></span>
<span class="line"><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">       end</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Base</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">MIME&quot;text/plain&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, d</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Day</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">) </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> print</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io, d</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">.</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">n, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot; day&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> Day</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> day</span></span></code></pre></div><p>Container types generally implement 3-argument <code>show</code> by calling <code>show(io, MIME&quot;text/plain&quot;(), x)</code> for elements <code>x</code>, with <code>:compact =&gt; true</code> set in an <a href="./@ref"><code>IOContext</code></a> passed as the first argument.</p><p><a href="https://github.com/JuliaLang/julia/blob/d63adeda50d5b8c440a7c29c9a65357a98fe927f/base/multimedia.jl#L79-L121" target="_blank" rel="noreferrer">source</a></p><p><strong>Show an occurrence</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, o::GBIFRecord)</span></span></code></pre></div><p>Displays the key, the taxon name, and the country of observation.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/types/show.jl#L6-L12" target="_blank" rel="noreferrer">source</a></p><p><strong>Show several occurrences</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, o::GBIFRecords)</span></span></code></pre></div><p>Displays the total number, and the number of currently unmasked records.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/types/show.jl#L17-L23" target="_blank" rel="noreferrer">source</a></p><p><strong>Show a taxonomic record</strong></p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span>show(io::IO, t::GBIFTaxon)</span></span></code></pre></div><p>Displays the taxon name.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/7840d3aad0d20a91c3b4902788a03048058ce5f5/GBIF/src/types/show.jl#L28-L34" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, x</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Quantity</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Show a unitful quantity by calling <a href="./@ref"><code>showval</code></a> on the numeric value, appending a space, and then calling <code>show</code> on a units object <code>U()</code>.</p><p><a href="https://github.com/PainterQubits/Unitful.jl/blob/v1.22.0/src/display.jl#L109-L113" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, x</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Unitlike</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Call <a href="./@ref"><code>Unitful.showrep</code></a> on each object in the tuple that is the type variable of a <a href="./@ref"><code>Unitful.Units</code></a> or <a href="./@ref"><code>Unitful.Dimensions</code></a> object.</p><p><a href="https://github.com/PainterQubits/Unitful.jl/blob/v1.22.0/src/display.jl#L164-L168" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">([io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, ]df</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractDataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">;</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     allrows</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> !</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">get</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io, :limit, </span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     allcols</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> !</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">get</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io, :limit, </span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     allgroups</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> !</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">get</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io, :limit, </span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">),</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     rowlabel</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Symbol</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> :Row,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     summary</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     eltypes</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Bool</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;"> true</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     truncate</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">Int</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> =</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 32</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">     kwargs</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">...</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Render a data frame to an I/O stream. The specific visual representation chosen depends on the width of the display.</p><p>If <code>io</code> is omitted, the result is printed to <code>stdout</code>, and <code>allrows</code>, <code>allcols</code> and <code>allgroups</code> default to <code>false</code>.</p><p><strong>Arguments</strong></p><ul><li><p><code>io::IO</code>: The I/O stream to which <code>df</code> will be printed.</p></li><li><p><code>df::AbstractDataFrame</code>: The data frame to print.</p></li><li><p><code>allrows::Bool</code>: Whether to print all rows, rather than a subset that fits the device height. By default this is the case only if <code>io</code> does not have the <code>IOContext</code> property <code>limit</code> set.</p></li><li><p><code>allcols::Bool</code>: Whether to print all columns, rather than a subset that fits the device width. By default this is the case only if <code>io</code> does not have the <code>IOContext</code> property <code>limit</code> set.</p></li><li><p><code>allgroups::Bool</code>: Whether to print all groups rather than the first and last, when <code>df</code> is a <code>GroupedDataFrame</code>. By default this is the case only if <code>io</code> does not have the <code>IOContext</code> property <code>limit</code> set.</p></li><li><p><code>rowlabel::Symbol = :Row</code>: The label to use for the column containing row numbers.</p></li><li><p><code>summary::Bool = true</code>: Whether to print a brief string summary of the data frame.</p></li><li><p><code>eltypes::Bool = true</code>: Whether to print the column types under column names.</p></li><li><p><code>truncate::Int = 32</code>: the maximal display width the output can use before being truncated (in the <code>textwidth</code> sense, excluding <code>…</code>). If <code>truncate</code> is 0 or less, no truncation is applied.</p></li><li><p><code>kwargs...</code>: Any keyword argument supported by the function <code>pretty_table</code> of PrettyTables.jl can be passed here to customize the output.</p></li></ul><p><strong>Examples</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;"> using</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> DataFrames</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> df </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> DataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(A</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, B</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">[</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;x&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;y&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;z&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]);</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(df, show_row_number</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#35A77C;--shiki-dark:#83C092;">false</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">×</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> DataFrame</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> A      B</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Int64  String</span></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">───────────────</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">     1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">  x</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">     2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">  y</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">     3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">  z</span></span></code></pre></div><p><a href="https://github.com/JuliaData/DataFrames.jl/blob/v1.7.0/src/abstractdataframe/show.jl#L284-L338" target="_blank" rel="noreferrer">source</a></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(io</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">IO</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, mime</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">MIME</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, df</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">::</span><span style="--shiki-light:#3A94C5;--shiki-dark:#7FBBB3;">AbstractDataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">)</span></span></code></pre></div><p>Render a data frame to an I/O stream in MIME type <code>mime</code>.</p><p><strong>Arguments</strong></p><ul><li><p><code>io::IO</code>: The I/O stream to which <code>df</code> will be printed.</p></li><li><p><code>mime::MIME</code>: supported MIME types are: <code>&quot;text/plain&quot;</code>, <code>&quot;text/html&quot;</code>, <code>&quot;text/latex&quot;</code>, <code>&quot;text/csv&quot;</code>, <code>&quot;text/tab-separated-values&quot;</code> (the last two MIME types do not support showing <code>#undef</code> values)</p></li><li><p><code>df::AbstractDataFrame</code>: The data frame to print.</p></li></ul><p>Additionally selected MIME types support passing the following keyword arguments:</p><ul><li><p>MIME type <code>&quot;text/plain&quot;</code> accepts all listed keyword arguments and their behavior is identical as for <code>show(::IO, ::AbstractDataFrame)</code></p></li><li><p>MIME type <code>&quot;text/html&quot;</code> accepts the following keyword arguments:</p><ul><li><p><code>eltypes::Bool = true</code>: Whether to print the column types under column names.</p></li><li><p><code>summary::Bool = true</code>: Whether to print a brief string summary of the data frame.</p></li><li><p><code>max_column_width::AbstractString = &quot;&quot;</code>: The maximum column width. It must be a string containing a valid CSS length. For example, passing &quot;100px&quot; will limit the width of all columns to 100 pixels. If empty, the columns will be rendered without limits.</p></li><li><p><code>kwargs...</code>: Any keyword argument supported by the function <code>pretty_table</code> of PrettyTables.jl can be passed here to customize the output.</p></li></ul></li></ul><p><strong>Examples</strong></p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes everforest-light everforest-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(stdout, </span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">MIME</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;text/latex&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">), </span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(A</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, B</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">[</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;x&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;y&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;z&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]))</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\</span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">begin</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">{tabular}{r</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">|</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">cc}</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">	&amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> A </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> B</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\\\</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">	\\</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">hline</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">	&amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> Int64 </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> String</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\\\</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">	\\</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">hline</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">	1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> x </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\\\</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">	2</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 2</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> y </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\\\</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">	3</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;"> 3</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;"> &amp;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;"> z </span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\\\</span></span>
<span class="line"><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">\\</span><span style="--shiki-light:#F85552;--shiki-dark:#E67E80;">end</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">{tabular}</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">14</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">julia</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">&gt;</span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;"> show</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(stdout, </span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">MIME</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;text/csv&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">), </span><span style="--shiki-light:#8DA101;--shiki-dark:#A7C080;">DataFrame</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">(A</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">:</span><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, B</span><span style="--shiki-light:#F57D26;--shiki-dark:#E69875;">=</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">[</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;x&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;y&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">, </span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;z&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">]))</span></span>
<span class="line"><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;A&quot;</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;B&quot;</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">1</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;x&quot;</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">2</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;y&quot;</span></span>
<span class="line"><span style="--shiki-light:#DF69BA;--shiki-dark:#D699B6;">3</span><span style="--shiki-light:#5C6A72;--shiki-dark:#D3C6AA;">,</span><span style="--shiki-light:#DFA000;--shiki-dark:#DBBC7F;">&quot;z&quot;</span></span></code></pre></div><p><a href="https://github.com/JuliaData/DataFrames.jl/blob/v1.7.0/src/abstractdataframe/io.jl#L89-L134" target="_blank" rel="noreferrer">source</a></p>`,52))])])}const F=l(k,[["render",A]]);export{f as __pageData,F as default};
