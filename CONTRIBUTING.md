# Contributing guidelines

## How to contribute

It is advised to **not** fork this repository to make a contribution -- instead, reach out
to @tpoisot and ask for access to the repo; this will make it easier for other contributors
to checkout your branch and contribute to it during the pull request process.

It is advised to open a pull request *as soon as possible* (typically upon the first
commit), so that the link to the preview documentation will be generated, and the tests can
start running.

## Naming of branches

Branches are named with the following scheme: `<package>/<type>/<description>`

The `<package>` entry specifies which package is covered by the changes (packages names are
 lowercase and we omit the `.jl` extension). For branches that cover the top level package,
the abbreviation `sdt` (for `SpeciesDistributionToolkit`) is acceptable. For branches
that target the documentation, the prefix `doc` should be used.

The `<type>` entry specifies what the branch does, and can be one of `feat` (new feature),
`refactor` (changes in the internal code), `bug` (for longer work on a bug), or `hotfix`
(for something that's gotta be merged soon. If needed, the `chore` or `misc` types can
also be used.

Finally, the `<description>` suffix is a short (a few characters) description of what the
branch does.

For example, `gbif/feat/map-api-interface` is an appropriate name for a branch that targets
the GBIF component, adds a new feature, specifically about the map API interface.

**Do not** reference an issue number in the branch name -- this can be done in the issue
itself on github. The branch name must convey more context than the issue number can.

## Commit conventions

We use a variant of [conventional commits][convcom] for the commits. Specifically, in
addition to the `fix` and `feat` actions, we also use `semver` (for changes to the versions
of packages, following [semantic versioning][semver]), `compat` (for compatibilies
changes in the Julia [package management][pkg]), `dependencies` (for changes in
requirements), `doc` (for documentation), and `test` (for unit testing).

[convcom]: https://www.conventionalcommits.org/en/v1.0.0/#summary
[semver]: https://semver.org/
[pkg]: https://pkgdocs.julialang.org/v1/compatibility/

As much as possible, we try to qualify the action by specifying which component package is
targeted by the commit (this might be apparent from the branch name, but especially when
doing work in branches that start with `doc` or `sdt`, there may be changes in more
than one package. For example, a commit that modifies the internals of `SimpleSDMLayers`
would start with `refactor(layers):  `.

Note that the name of component packages are lowercase, and that abbreviations are OK.
Specifically, `Phylopic.jl` is `phylopic`, `SpeciesDistributionToolkit.jl` is `sdt`,
`GBIF.jl` is `gbif`, `SimpleSDMLayers.jl` is `layers`, `Fauxcurrences.jl` is `faux`, and
`SimpleSDMDatasets.jl` is `datasets`.

In case of breaking changes, the commit prefix **must** be followed by `!`. This is **not**
limited to commits with the `semver` prefix, but is meant to be used in the specific commit
that introduces breaking changes. For example, a new feature in GBIF that would require to
re-write all code would have the prefix `feat(gbif)!: ` (and be followed by a `semver` commit
to reflect the new version).

The commit message is on the same line as the commit prefix, and is (ideally) a short
sentence in the imperative. The next line in the body of the message, if required, can be
used to mention linked issues or close them. Additional information about the commit is
given *after* the links to issues.

## Pull requests and merging

The commits in a pull request *will* be squashed before merging, and the list of commit
messages will be kept in the body of the closing commit. The merge commit *must* follow the
commit convention. The branches are automatically deleted when a pull request is merged.

