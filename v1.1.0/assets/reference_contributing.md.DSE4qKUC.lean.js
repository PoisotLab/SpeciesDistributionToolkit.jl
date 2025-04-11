import{_ as t,c as o,a2 as a,o as i}from"./chunks/framework.DF-HKlxZ.js";const g=JSON.parse('{"title":"Contribution guidelines","description":"","frontmatter":{},"headers":[],"relativePath":"reference/contributing.md","filePath":"reference/contributing.md","lastUpdated":null}'),n={name:"reference/contributing.md"};function s(r,e,c,d,l,h){return i(),o("div",null,e[0]||(e[0]=[a('<h1 id="Contribution-guidelines" tabindex="-1">Contribution guidelines <a class="header-anchor" href="#Contribution-guidelines" aria-label="Permalink to &quot;Contribution guidelines {#Contribution-guidelines}&quot;">​</a></h1><h2 id="Repository-structure" tabindex="-1">Repository structure <a class="header-anchor" href="#Repository-structure" aria-label="Permalink to &quot;Repository structure {#Repository-structure}&quot;">​</a></h2><p>This repository functions as a &quot;monorepo&quot;, <em>i.e.</em> one where the top-level package (<code>SpeciesDistributionToolkit.jl</code>) and its components packages reside. The documentation for all packages is centralized in <code>docs</code>, and then each package has its code, unit tests, and <code>Project.toml</code> file in its own sub-folder. As a rule, we try to minimize the situations where a component package depends on another component package – currently, only <code>Fauxcurrences</code> has direct dependences on other component packages. Code that is meant to facilitate the integration of multiple packages lives in <code>SpeciesDistributionToolkit.jl</code>.</p><p>If some of the code in <code>SpeciesDistributionToolkit.jl</code> becomes too large, it can branched of to another component package. Note that because we re-export all of the component packages, this can be done without affecting existing code.</p><h2 id="How-to-contribute" tabindex="-1">How to contribute <a class="header-anchor" href="#How-to-contribute" aria-label="Permalink to &quot;How to contribute {#How-to-contribute}&quot;">​</a></h2><h3 id="discussions" tabindex="-1">Discussions <a class="header-anchor" href="#discussions" aria-label="Permalink to &quot;Discussions&quot;">​</a></h3><p>There is a <a href="https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions" target="_blank" rel="noreferrer">discussion board</a> where you can talk about the package(s). Useful contributions there are feature ideas, use cases, and clarifications to the documentation.</p><h3 id="issues" tabindex="-1">Issues <a class="header-anchor" href="#issues" aria-label="Permalink to &quot;Issues&quot;">​</a></h3><p>Everything that doesn&#39;t feel right as a discussion can be opened as an issue. Issues are tracked in a central <a href="https://github.com/orgs/PoisotLab/projects/3" target="_blank" rel="noreferrer">project</a>, which is used internally to prioritize the work. We have a tag system in place to sort issues in broad categories, based on what they target, the type of work required, the amount of effort needed, and the overall priority.</p><p>Issues are a good starting point (in fact, essentially a pre-requisite) to opening a pull request, as explained in the name paragraph.</p><h3 id="Working-on-the-code" tabindex="-1">Working on the code <a class="header-anchor" href="#Working-on-the-code" aria-label="Permalink to &quot;Working on the code {#Working-on-the-code}&quot;">​</a></h3><p>It is advised to <strong>not</strong> fork this repository to make a contribution – instead, reach out to @tpoisot and ask for access to the repo; this will make it easier for other contributors to checkout your branch and contribute to it during the pull request process. Typically, you will be added to the repo when opening an issue or a discussion that you have indicated you would be willing to work on.</p><p>It is advised to open a pull request <em>as soon as possible</em> (typically upon the first commit), so that the link to the preview documentation will be generated, and the tests can start running. Each pull request is resulting in a new documentation build, which takes a lot of time as the vignettes are using almost all of the package(s) functionalities.</p><h2 id="Repository-conventions" tabindex="-1">Repository conventions <a class="header-anchor" href="#Repository-conventions" aria-label="Permalink to &quot;Repository conventions {#Repository-conventions}&quot;">​</a></h2><h3 id="Naming-of-branches" tabindex="-1">Naming of branches <a class="header-anchor" href="#Naming-of-branches" aria-label="Permalink to &quot;Naming of branches {#Naming-of-branches}&quot;">​</a></h3><p>Branches are named with the following scheme: <code>&lt;package&gt;/&lt;type&gt;/&lt;description&gt;</code></p><p>The <code>&lt;package&gt;</code> entry specifies which package is covered by the changes (packages names are lowercase and we omit the <code>.jl</code> extension). For branches that cover the top level package, the abbreviation <code>sdt</code> (for <code>SpeciesDistributionToolkit</code>) is acceptable. For branches that target the documentation, the prefix <code>doc</code> should be used.</p><p>The <code>&lt;type&gt;</code> entry specifies what the branch does, and can be one of <code>feat</code> (new feature), <code>refactor</code> (changes in the internal code), <code>bug</code> (for longer work on a bug), or <code>hotfix</code> (for something that&#39;s gotta be merged soon. If needed, the <code>chore</code> or <code>misc</code> types can also be used.</p><p>Finally, the <code>&lt;description&gt;</code> suffix is a short (a few characters) description of what the branch does.</p><p>For example, <code>gbif/feat/map-api-interface</code> is an appropriate name for a branch that targets the GBIF component, adds a new feature, specifically about the map API interface.</p><p><strong>Do not</strong> reference an issue number in the branch name – this can be done in the issue itself on github. The branch name must convey more context than the issue number can.</p><h3 id="Commit-conventions" tabindex="-1">Commit conventions <a class="header-anchor" href="#Commit-conventions" aria-label="Permalink to &quot;Commit conventions {#Commit-conventions}&quot;">​</a></h3><p>We use a variant of [conventional commits][convcom] for the commits. Specifically, in addition to the <code>fix</code> and <code>feat</code> actions, we also use <code>semver</code> (for changes to the versions of packages, following [semantic versioning][semver]), <code>compat</code> (for compatibilies changes in the Julia [package management][pkg]), <code>dependencies</code> (for changes in requirements), <code>doc</code> (for documentation), and <code>test</code> (for unit testing).</p><p>As a reference, this table summarizes what type of commit may go with each prefix:</p><table tabindex="0"><thead><tr><th style="text-align:right;">Prefix</th><th style="text-align:right;">Explanation</th></tr></thead><tbody><tr><td style="text-align:right;"><code>fix</code></td><td style="text-align:right;">Solves a bug / closes a PR</td></tr><tr><td style="text-align:right;"><code>feat</code></td><td style="text-align:right;">Adds a new feature</td></tr><tr><td style="text-align:right;"><code>semver</code></td><td style="text-align:right;">Commit that will be tagged in a new release – this should contain a change in <code>Project.toml</code></td></tr><tr><td style="text-align:right;"><code>dependencies</code></td><td style="text-align:right;">Changes in <code>Project.toml</code> to add or drop a dependency</td></tr><tr><td style="text-align:right;"><code>compat</code></td><td style="text-align:right;">Changes in <code>Project.toml</code> to change the compatibility entry</td></tr><tr><td style="text-align:right;"><code>ci</code></td><td style="text-align:right;">Acts on github actions / workflows</td></tr><tr><td style="text-align:right;"><code>doc</code></td><td style="text-align:right;">Changes or adds documentation, including docstrings, and possibly comments</td></tr><tr><td style="text-align:right;"><code>perf</code></td><td style="text-align:right;">Improves the performance of the code</td></tr><tr><td style="text-align:right;"><code>test</code></td><td style="text-align:right;">Adds (or fixes) unit tests</td></tr><tr><td style="text-align:right;"><code>style</code></td><td style="text-align:right;">Applies the formatter without modifying the content</td></tr><tr><td style="text-align:right;"><code>refactor</code></td><td style="text-align:right;">Changes the internals of a function, or changes to methods that are not exported</td></tr><tr><td style="text-align:right;"><code>chore</code></td><td style="text-align:right;">General housekeeping</td></tr></tbody></table><p>[convcom]: <a href="https://www.conventionalcommits.org/en/v1.0.0/#summary" target="_blank" rel="noreferrer">https://www.conventionalcommits.org/en/v1.0.0/#summary</a> [semver]: <a href="https://semver.org/" target="_blank" rel="noreferrer">https://semver.org/</a> [pkg]: <a href="https://pkgdocs.julialang.org/v1/compatibility/" target="_blank" rel="noreferrer">https://pkgdocs.julialang.org/v1/compatibility/</a></p><p>As much as possible, we try to qualify the action by specifying which component package is targeted by the commit (this might be apparent from the branch name, but especially when doing work in branches that start with <code>doc</code> or <code>sdt</code>, there may be changes in more than one package. For example, a commit that modifies the internals of <code>SimpleSDMLayers</code> would start with <code>refactor(layers):</code>.</p><p>Note that the name of component packages are lowercase, and that abbreviations are OK. Specifically, <code>Phylopic.jl</code> is <code>phylopic</code>, <code>SpeciesDistributionToolkit.jl</code> is <code>sdt</code>, <code>GBIF.jl</code> is <code>gbif</code>, <code>SimpleSDMLayers.jl</code> is <code>layers</code>, <code>OccurrencesInterface.jl</code> is <code>occ</code>, <code>Fauxcurrences.jl</code> is <code>faux</code>, <code>SDeMo.jl</code> is <code>demo</code>, and <code>SimpleSDMDatasets.jl</code> is <code>datasets</code>.</p><p>In case of breaking changes, the commit prefix <strong>must</strong> be followed by <code>!</code>. This is <strong>not</strong> limited to commits with the <code>semver</code> prefix, but is meant to be used in the specific commit that introduces breaking changes. For example, a new feature in GBIF that would require to re-write all code would have the prefix <code>feat(gbif)!:</code> (and be followed by a <code>semver</code> commit to reflect the new version).</p><p>In case of an <em>incomplete commit</em> (<em>e.g.</em> the code is only partly finished), the commit prefix <strong>must</strong> be followed by <code>?</code>. This is useful when leaving work unfinished at the end of a session. For example, a commit with an incomplete <code>SimpleSDMDatasets.jl</code> vignette can start with <code>doc(datasets)?:</code>.</p><p>The commit message is on the same line as the commit prefix, and is (ideally) a short sentence in the imperative. The next line in the body of the message, if required, can be used to mention linked issues or close them. Additional information about the commit is given <em>after</em> the links to issues.</p><h3 id="Pull-requests-and-merging" tabindex="-1">Pull requests and merging <a class="header-anchor" href="#Pull-requests-and-merging" aria-label="Permalink to &quot;Pull requests and merging {#Pull-requests-and-merging}&quot;">​</a></h3><p>The commits in a pull request <em>may</em> be squashed before merging, and the list of commit messages will be kept in the body of the closing commit. The merge commit <em>must</em> follow the commit convention. The branches are automatically deleted when a pull request is merged. The commits that result from pulling/rebasing/conflicts operations <em>do not need</em> to follow the commit naming convention.</p><p><strong>When the changes in a pull request</strong> affect more than one package, the best solution is to <em>not</em> squash the merge commit, because it will make tagging different versions more difficult. This can be decided at PR merging time.</p><h2 id="releases" tabindex="-1">Releases <a class="header-anchor" href="#releases" aria-label="Permalink to &quot;Releases&quot;">​</a></h2><p>Releases are handled by @tpoisot - we use the <a href="https://github.com/JuliaRegistries/Registrator.jl" target="_blank" rel="noreferrer">Julia Registrator</a> bot to create new releases. Ideally, the release process is: merging a PR in <code>main</code>, confirming that the unit tests pass and the documentation build, and then commenting on the commit with <code>@JuliaRegistrator register()</code>, adding <code>subdir=&quot;&lt;PKGNAME&gt;&quot;</code> when the release is about a sub-package.</p>',36)]))}const u=t(n,[["render",s]]);export{g as __pageData,u as default};
