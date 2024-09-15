# Contributing guidelines

## Repository structure

This repository functions as a "monorepo", *i.e.* one where the top-level
package (`SpeciesDistributionToolkit.jl`) and its components packages reside.
The documentation for all packages is centralized in `docs`, and then each
package has its code, unit tests, and `Project.toml` file in its own sub-folder.
As a rule, we try to minimize the situations where a component package depends
on another component package -- currently, only `Fauxcurrences` has direct
dependences on other component packages. Code that is meant to facilitate the
integration of multiple packages lives in `SpeciesDistributionToolkit.jl`.

If some of the code in `SpeciesDistributionToolkit.jl` becomes too large, it can
branched of to another component package. Note that because we re-export all of
the component packages, this can be done without affecting existing code.

## How to contribute

### Discussions

There is a [discussion board][discussion] where you can talk about the
package(s). Useful contributions there are feature ideas, use cases, and
clarifications to the documentation.

[discussion]: https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions

### Issues

Everything that doesn't feel right as a discussion can be opened as an issue.
Issues are tracked in a central [project][pboard], which is used internally to
prioritize the work. We have a tag system in place to sort issues in broad
categories, based on what they target, the type of work required, the amount of
effort needed, and the overall priority.

[pboard]: https://github.com/orgs/PoisotLab/projects/3

Issues are a good starting point (in fact, essentially a pre-requisite) to
opening a pull request, as explained in the name paragraph.

### Working on the code

It is advised to **not** fork this repository to make a contribution -- instead,
reach out to @tpoisot and ask for access to the repo; this will make it easier
for other contributors to checkout your branch and contribute to it during the
pull request process. Typically, you will be added to the repo when opening an
issue or a discussion that you have indicated you would be willing to work on.

It is advised to open a pull request *as soon as possible* (typically upon the
first commit), so that the link to the preview documentation will be generated,
and the tests can start running. Each pull request is resulting in a new
documentation build, which takes a lot of time as the vignettes are using almost
all of the package(s) functionalities.

## Repository conventions

### Naming of branches

Branches are named with the following scheme: `<package>/<type>/<description>`

The `<package>` entry specifies which package is covered by the changes
 (packages names are lowercase and we omit the `.jl` extension). For branches
that cover the top level package, the abbreviation `sdt` (for
`SpeciesDistributionToolkit`) is acceptable. For branches that target the
documentation, the prefix `doc` should be used.

The `<type>` entry specifies what the branch does, and can be one of `feat` (new
feature), `refactor` (changes in the internal code), `bug` (for longer work on a
bug), or `hotfix` (for something that's gotta be merged soon. If needed, the
`chore` or `misc` types can also be used.

Finally, the `<description>` suffix is a short (a few characters) description of
what the branch does.

For example, `gbif/feat/map-api-interface` is an appropriate name for a branch
that targets the GBIF component, adds a new feature, specifically about the map
API interface.

**Do not** reference an issue number in the branch name -- this can be done in
the issue itself on github. The branch name must convey more context than the
issue number can.

### Commit conventions

We use a variant of [conventional commits][convcom] for the commits. Specifically, in
addition to the `fix` and `feat` actions, we also use `semver` (for changes to the versions
of packages, following [semantic versioning][semver]), `compat` (for compatibilies
changes in the Julia [package management][pkg]), `dependencies` (for changes in
requirements), `doc` (for documentation), and `test` (for unit testing).

As a reference, this table summarizes what type of commit may go with each
prefix:

| Prefix         | Explanation                                                                                   |
|----------------|-----------------------------------------------------------------------------------------------|
| `fix`          | Solves a bug / closes a PR                                                                    |
| `feat`         | Adds a new feature                                                                            |
| `semver`       | Commit that will be tagged in a new release -- this should contain a change in `Project.toml` |
| `dependencies` | Changes in `Project.toml` to add or drop a dependency                                         |
| `compat`       | Changes in `Project.toml` to change the compatibility entry                                   |
| `ci`           | Acts on github actions / workflows                                                            |
| `doc`          | Changes or adds documentation, including docstrings, and possibly comments                    |
| `perf`         | Improves the performance of the code                                                          |
| `test`         | Adds (or fixes) unit tests                                                                    |
| `style`        | Applies the formatter without modifying the content                                           |
| `refactor`     | Changes the internals of a function, or changes to methods that are not exported              |
| `chore`        | General housekeeping                                                                          |

[convcom]: https://www.conventionalcommits.org/en/v1.0.0/#summary
[semver]: https://semver.org/
[pkg]: https://pkgdocs.julialang.org/v1/compatibility/

As much as possible, we try to qualify the action by specifying which component
package is targeted by the commit (this might be apparent from the branch name,
but especially when doing work in branches that start with `doc` or `sdt`, there
may be changes in more than one package. For example, a commit that modifies the
internals of `SimpleSDMLayers` would start with `refactor(layers): `.

Note that the name of component packages are lowercase, and that abbreviations
are OK. Specifically, `Phylopic.jl` is `phylopic`,
`SpeciesDistributionToolkit.jl` is `sdt`, `GBIF.jl` is `gbif`,
`SimpleSDMLayers.jl` is `layers`, `Fauxcurrences.jl` is `faux`, `STACApi.jl` is
`stac`, and `SimpleSDMDatasets.jl` is `datasets`.

In case of breaking changes, the commit prefix **must** be followed by `!`. This
is **not** limited to commits with the `semver` prefix, but is meant to be used
in the specific commit that introduces breaking changes. For example, a new
feature in GBIF that would require to re-write all code would have the prefix
`feat(gbif)!: ` (and be followed by a `semver` commit to reflect the new
version).

In case of an *incomplete commit* (*e.g.* the code is only partly finished), the
commit prefix **must** be followed by `?`. This is useful when leaving work
unfinished at the end of a session. For example, a commit with an incomplete
`SimpleSDMDatasets.jl` vignette can start with `doc(datasets)?: `.

The commit message is on the same line as the commit prefix, and is (ideally) a
short sentence in the imperative. The next line in the body of the message, if
required, can be used to mention linked issues or close them. Additional
information about the commit is given *after* the links to issues.

### Pull requests and merging

The commits in a pull request *may* be squashed before merging, and the list of
commit messages will be kept in the body of the closing commit. The merge commit
*must* follow the commit convention. The branches are automatically deleted when
a pull request is merged. The commits that result from
pulling/rebasing/conflicts operations *do not need* to follow the commit naming
convention.

**When the changes in a pull request** affect more than one package, the best
solution is to *not* squash the merge commit, because it will make tagging
different versions more difficult. This can be decided at PR merging time.

## Releases

Releases are handled by @tpoisot - we use the [Julia
Registrator](https://github.com/JuliaRegistries/Registrator.jl) bot to create
new releases. Ideally, the release process is: merging a PR in `main`,
confirming that the unit tests pass and the documentation build, and then
commenting on the commit with  `@JuliaRegistrator register()`, adding
`subdir="<PKGNAME>"` when the release is about a sub-package.