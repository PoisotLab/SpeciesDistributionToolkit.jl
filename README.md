# SpeciesDistributionToolkit

🗺️ `SpeciesDistributionToolkit.jl` is a collection of Julia packages forming a
toolkit meant to deal with (surprise!) species distribution data. Specifically,
the goal of these packages put together is to provide a consistent way to handle
occurrence data, put them on a map, and make it interact with environmental
information.

![GitHub Release](https://img.shields.io/github/v/release/poisotlab/speciesdistributiontoolkit.jl?filter=v*&style=flat-square&label=Main%20package) [![DOC](https://img.shields.io/badge/Manual-teal?style=flat-square)](https://poisotlab.github.io/SpeciesDistributionToolkit.jl) [![Static Badge](https://img.shields.io/badge/Cite_the_paper-10.21105%2Fjoss.02872-orange?style=flat-square)](https://joss.theoj.org/papers/10.21105/joss.02872) ![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6?style=flat-square)

## Want to help?

🧑‍💻 To get a sense of the next steps and help with the development, see the 
[issues/bugs tracker](https://github.com/orgs/PoisotLab/projects/3).

🤓 From a technical point of view, this *repository* is a [Monorepo][mnrp]
consisting of several related packages to work with species distribution data.
These packages were formerly independent and tied together with moxie and
`Require`, which was less than ideal. All the packages forming the toolkit share
a version number (which was set based on the version number of the eldest
package, `SimpleSDMLayers`), and the toolkit itself has its own version number.

[mnrp]: https://monorepo.tools/
