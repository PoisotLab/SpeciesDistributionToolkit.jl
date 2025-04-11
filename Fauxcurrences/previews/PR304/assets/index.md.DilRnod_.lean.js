import{_ as l,c as r,j as i,a as e,G as a,a2 as n,B as o,o as p}from"./chunks/framework.BwaEuyWd.js";const P=JSON.parse('{"title":"Generation of fauxcurrences","description":"","frontmatter":{},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}'),c={name:"index.md"},d={class:"jldocstring custom-block",open:""},h={class:"jldocstring custom-block",open:""},u={class:"jldocstring custom-block",open:""},k={class:"jldocstring custom-block",open:""},b={class:"jldocstring custom-block",open:""},g={class:"jldocstring custom-block",open:""},m={class:"jldocstring custom-block",open:""},y={class:"jldocstring custom-block",open:""},f={class:"jldocstring custom-block",open:""},F={class:"jldocstring custom-block",open:""},j={class:"jldocstring custom-block",open:""},E={class:"jldocstring custom-block",open:""},x={class:"jldocstring custom-block",open:""},v={class:"jldocstring custom-block",open:""},C={class:"jldocstring custom-block",open:""},_={class:"jldocstring custom-block",open:""};function w(L,s,T,B,D,A){const t=o("Badge");return p(),r("div",null,[s[48]||(s[48]=i("h1",{id:"Generation-of-fauxcurrences",tabindex:"-1"},[e("Generation of fauxcurrences "),i("a",{class:"header-anchor",href:"#Generation-of-fauxcurrences","aria-label":'Permalink to "Generation of fauxcurrences {#Generation-of-fauxcurrences}"'},"​")],-1)),i("details",d,[i("summary",null,[s[0]||(s[0]=i("a",{id:"Fauxcurrences.bootstrap!",href:"#Fauxcurrences.bootstrap!"},[i("span",{class:"jlbinding"},"Fauxcurrences.bootstrap!")],-1)),s[1]||(s[1]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[2]||(s[2]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bootstrap!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(sim, layer, obs, obs_intra, obs_inter, sim_intra, sim_inter)</span></span></code></pre></div><p>Generates the initial proposition for points - this function generates the points for all taxa at once, so some knowledge of the distance matrices is required. Note that this function is modifying the <em>bootstrapped</em> object, in order to make be as efficient as possible.</p><p>Specifically, the first point for each taxa is picked to respect the maximal inter-specific distances, and then the following points are picked to respect the intra and inter-specific distances. Points after the first one are added <em>at random</em>, so there can be an accumulation of points in some species early on.</p><p>Note that this function is not particularly efficient, but this is a little bit of over-head for every simulation. The only guarantee offered is that the distances are not above the maximal distances in the dataset, there is no reason to expect that the distribution of distances within or across taxa will be respected.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/bootstrap.jl#L1-L19" target="_blank" rel="noreferrer">source</a></p>',5))]),i("details",h,[i("summary",null,[s[3]||(s[3]=i("a",{id:"Fauxcurrences.preallocate_simulated_points",href:"#Fauxcurrences.preallocate_simulated_points"},[i("span",{class:"jlbinding"},"Fauxcurrences.preallocate_simulated_points")],-1)),s[4]||(s[4]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[5]||(s[5]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">preallocate_simulated_points</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(obs; samples</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">size</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.(obs, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span></code></pre></div><p>Create an empty matrix given a series of observations, and a number of samples to keep in the simulated dataset for each series of observations.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/bootstrap.jl#L67-L72" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",u,[i("summary",null,[s[6]||(s[6]=i("a",{id:"Fauxcurrences.get_valid_coordinates",href:"#Fauxcurrences.get_valid_coordinates"},[i("span",{class:"jlbinding"},"Fauxcurrences.get_valid_coordinates")],-1)),s[7]||(s[7]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[8]||(s[8]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">get_valid_coordinates</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(observations</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">R</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, layer</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">where</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {R </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> AbstractOccurrenceCollection</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, T </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> SDMLayer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>Get the coordinates for a list of observations, filtering the ones that do not correspond to valid layer positions. Valid layer positions are defined as falling within a valued pixel from the layer.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/coordinates.jl#L1-L7" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",k,[i("summary",null,[s[9]||(s[9]=i("a",{id:"Fauxcurrences.step!",href:"#Fauxcurrences.step!"},[i("span",{class:"jlbinding"},"Fauxcurrences.step!")],-1)),s[10]||(s[10]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[11]||(s[11]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Fauxcurrences</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">step!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(sim, layer, W, obs_intra, obs_inter, sim_intra, sim_inter, bin_intra, bin_inter, bin_s_intra, bin_s_inter, distance)</span></span></code></pre></div><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/step.jl#L1-L3" target="_blank" rel="noreferrer">source</a></p>',2))]),i("details",b,[i("summary",null,[s[12]||(s[12]=i("a",{id:"Fauxcurrences._random_point",href:"#Fauxcurrences._random_point"},[i("span",{class:"jlbinding"},"Fauxcurrences._random_point")],-1)),s[13]||(s[13]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[14]||(s[14]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_random_point</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ref, d; R</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Fauxcurrences</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">_earth_radius)</span></span></code></pre></div><p>This solves the direct (first) geodetic problem assuming Haversine distances are a correct approximation of the distance between points.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L1-L6" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",g,[i("summary",null,[s[15]||(s[15]=i("a",{id:"Fauxcurrences._generate_new_random_point",href:"#Fauxcurrences._generate_new_random_point"},[i("span",{class:"jlbinding"},"Fauxcurrences._generate_new_random_point")],-1)),s[16]||(s[16]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[17]||(s[17]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_generate_new_random_point</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(layer, points, distances)</span></span></code></pre></div><p>Generates a new random point (that must fall within a valued cell of <code>layer</code>) based on a collection of <code>points</code> and a <code>Dxy</code> distance matrix. The algorithm works by sampling a point, a distance in the matrix, and then generates a new point through a call to <code>_random_point</code>. Note that the distance is multiplied by the square root of a random deviate within the unit interval, in order to have points that fall uniformly within the circle defined by the sampled distance. In the absence of this correction, the distribution of points is biased towards the center.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L22-L33" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",m,[i("summary",null,[s[18]||(s[18]=i("a",{id:"Fauxcurrences._bin_distribution",href:"#Fauxcurrences._bin_distribution"},[i("span",{class:"jlbinding"},"Fauxcurrences._bin_distribution")],-1)),s[19]||(s[19]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[20]||(s[20]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_bin_distribution</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(D</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Matrix{Float64}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, m</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Float64</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Vector{Float64}</span></span></code></pre></div><p>Bin a distance matrix, using a default count of 20 bins. This function is instrumental in the package, as it is used internally to calculate the divergence between the observed and simulated distances distributions. This specific implementation had the least-worst performance during a series of benchmarks, but in practice the package is going to spend a lot of time running it. It is a prime candidate for optimisation.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L46-L55" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",y,[i("summary",null,[s[21]||(s[21]=i("a",{id:"Fauxcurrences._bin_distribution!",href:"#Fauxcurrences._bin_distribution!"},[i("span",{class:"jlbinding"},"Fauxcurrences._bin_distribution!")],-1)),s[22]||(s[22]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[23]||(s[23]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_bin_distribution!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(c</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Vector{Float64}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, D</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Matrix{Float64}</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, m</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Float64</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Vector{Float64}</span></span></code></pre></div><p>In-place allocation of the distribution binning. This function is the one that is used internally to over-write the scores.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L61-L66" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",f,[i("summary",null,[s[24]||(s[24]=i("a",{id:"Fauxcurrences._distance_between_binned_distributions",href:"#Fauxcurrences._distance_between_binned_distributions"},[i("span",{class:"jlbinding"},"Fauxcurrences._distance_between_binned_distributions")],-1)),s[25]||(s[25]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[26]||(s[26]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_distance_between_binned_distributions</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p, q)</span></span></code></pre></div><p>Returns the Jensen-Shannon distance (i.e. the square root of the JS divergence) for the two distance matrices. This version is preferred to the KL divergence in the original implementation as it prevents the <code>Inf</code> values when p(x)=0 and q(x)&gt;0. The JS divergences is bounded between 0 and the natural log of 2, which gives an absolute measure of fit allowing to compare the solutions. Note that the value returned is <em>already</em> corrected, so it can be at most 1.0, and at best (identical matrices) 0.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L80-L90" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",F,[i("summary",null,[s[27]||(s[27]=i("a",{id:"Fauxcurrences.preallocate_distance_matrices",href:"#Fauxcurrences.preallocate_distance_matrices"},[i("span",{class:"jlbinding"},"Fauxcurrences.preallocate_distance_matrices")],-1)),s[28]||(s[28]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[29]||(s[29]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">preallocate_distance_matrices</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(obs; samples</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">size</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.(obs, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span></code></pre></div><p>Generates the internal distance matrices.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L95-L99" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",j,[i("summary",null,[s[30]||(s[30]=i("a",{id:"Fauxcurrences.measure_intraspecific_distances!",href:"#Fauxcurrences.measure_intraspecific_distances!"},[i("span",{class:"jlbinding"},"Fauxcurrences.measure_intraspecific_distances!")],-1)),s[31]||(s[31]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[32]||(s[32]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">measure_intraspecific_distances!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(intra, obs; updated</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">length</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(obs))</span></span></code></pre></div><p>Updates the matrices for intraspecific distances; note that internally, the <code>updated</code> keyword argument is going to change, to only replace what needs to be replaced.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L114-L120" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",E,[i("summary",null,[s[33]||(s[33]=i("a",{id:"Fauxcurrences.measure_interspecific_distances!",href:"#Fauxcurrences.measure_interspecific_distances!"},[i("span",{class:"jlbinding"},"Fauxcurrences.measure_interspecific_distances!")],-1)),s[34]||(s[34]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[35]||(s[35]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">measure_interspecific_distances!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(inter, obs; updated</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">length</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(obs))</span></span></code></pre></div><p>Updates the matrices for interspecific distances; note that internally, the <code>updated</code> keyword argument is going to change, to only replace what needs to be replaced.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L129-L135" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",x,[i("summary",null,[s[36]||(s[36]=i("a",{id:"Fauxcurrences.score_distributions",href:"#Fauxcurrences.score_distributions"},[i("span",{class:"jlbinding"},"Fauxcurrences.score_distributions")],-1)),s[37]||(s[37]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[38]||(s[38]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">score_distributions</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(W, bin_intra, bin_s_intra, bin_inter, bin_s_inter)</span></span></code></pre></div><p>Performs the actual score of the distributions, based on the weight matrix.</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/utilities.jl#L153-L157" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",v,[i("summary",null,[s[39]||(s[39]=i("a",{id:"Fauxcurrences.equal_weights",href:"#Fauxcurrences.equal_weights"},[i("span",{class:"jlbinding"},"Fauxcurrences.equal_weights")],-1)),s[40]||(s[40]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[41]||(s[41]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">equal_weights</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(n)</span></span></code></pre></div><p>All matrices have the same weight</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/weightmatrices.jl#L1-L5" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",C,[i("summary",null,[s[42]||(s[42]=i("a",{id:"Fauxcurrences.weighted_components",href:"#Fauxcurrences.weighted_components"},[i("span",{class:"jlbinding"},"Fauxcurrences.weighted_components")],-1)),s[43]||(s[43]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[44]||(s[44]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">weighted_components</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(n, intra)</span></span></code></pre></div><p>The intra-specific component has relative weight <code>intra</code> – for a value of 1.0, the model is a purely intra-specific one</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/weightmatrices.jl#L16-L21" target="_blank" rel="noreferrer">source</a></p>',3))]),i("details",_,[i("summary",null,[s[45]||(s[45]=i("a",{id:"Fauxcurrences.equally_weighted_components",href:"#Fauxcurrences.equally_weighted_components"},[i("span",{class:"jlbinding"},"Fauxcurrences.equally_weighted_components")],-1)),s[46]||(s[46]=e()),a(t,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),s[47]||(s[47]=n('<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">equally_weighted_components</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(n)</span></span></code></pre></div><p>The intra and inter components have the same weight, which means the inter-specific matrices can have less cumulative weight</p><p><a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/blob/0065e4af5264b9556089f7be1418c7d91b74ec45/Fauxcurrences/src/weightmatrices.jl#L36-L41" target="_blank" rel="noreferrer">source</a></p>',3))])])}const O=l(c,[["render",w]]);export{P as __pageData,O as default};
