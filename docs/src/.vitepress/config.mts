import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";

// https://vitepress.dev/reference/site-config
export default defineConfig({
    base: 'REPLACE_ME_DOCUMENTER_VITEPRESS',// TODO: replace this in makedocs!
    title: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
    description: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
    lastUpdated: true,
    cleanUrls: true,
    outDir: 'REPLACE_ME_DOCUMENTER_VITEPRESS', // This is required for MarkdownVitepress to work correctly...
    head: [['link', { rel: 'icon', href: 'REPLACE_ME_DOCUMENTER_VITEPRESS_FAVICON' }]],
    ignoreDeadLinks: true,
    markdown: {
        math: true,
        config(md) {
            md.use(tabsMarkdownPlugin),
                md.use(mathjax3),
                md.use(footnote)
        },
        theme: {
            light: "min-light",
            dark: "min-dark"
        }
    },
    themeConfig: {
        outline: 'deep',
        docFooter: {
            next: false,
            prev: false
        },
        logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
        search: {
            provider: 'local',
            options: {
                detailedView: true
            }
        },
        nav: [
            { text: 'Index', link: '/index' },
            {
                text: 'Manual',
                items: [
                    { text: "Tutorials", link: "/tutorials" },
                    { text: "How-to", link: "/howto" },
                    { text: "Reference", link: "/reference" }
                ]
            },
            {
                text: 'Datasets',
                items: [
                    { text: "BiodiversityMapping", link: "/datasets/BiodiversityMapping" },
                    { text: "CHELSA 1", link: "/datasets/CHELSA1" },
                    { text: "CHELSA 2", link: "/datasets/CHELSA2" },
                    { text: "Copernicus", link: "/datasets/Copernicus" },
                    { text: "EarthEnv", link: "/datasets/EarthEnv" },
                    { text: "PaleoClim", link: "/datasets/PaleoClim" },
                    { text: "WorldClim 2", link: "/datasets/WorldClim2" },
                ]
            },
            {
                text: "Ecosystem",
                items: [
                    {
                        text: "Core packages",
                        items: [
                            { text: "Fauxcurrences.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/" },
                            { text: "GBIF.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/" },
                            { text: "OccurrencesInterface.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/OccurrencesInterface/" },
                            { text: "Phylopic.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/" },
                            { text: "SDeMo.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SDeMo/" },
                            { text: "SimpleSDMDatasets.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/" },
                            { text: "SimpleSDMLayers.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMLayers/" },
                        ]
                    },
                    {
                        text: "Packages we support",
                        items: [
                            { text: "BON.jl", link: "https://poisotlab.github.io/BiodiversityObservationNetworks.jl/dev/" },
                            { text: "Clustering.jl", link: "https://juliastats.org/Clustering.jl/stable/" },
                            { text: "MultivariateStats.jl", link: "https://juliastats.org/MultivariateStats.jl/stable/" },
                            { text: "NeutralLandscapes.jl", link: "https://docs.ecojulia.org/NeutralLandscapes.jl/dev/" },
                            { text: "SpatialBoundaries.jl", link: "https://poisotlab.github.io/SpatialBoundaries.jl/dev/" },
                            { text: "STAC.jl", link: "https://juliaclimate.github.io/STAC.jl/dev/" },
                        ]
                    }

                ]
            }
        ],
        sidebar: {
            "/howto/": [
                {
                    text: "How-to",
                    items: [
                        {
                            text: "Basic layer operations",
                            items: [
                                { text: "Masking layers", link: "/howto/mask-layer/" },
                                { text: "Masking layers with polygons", link: "/howto/mask-polygons/" },
                                { text: "Arithmetic on layers", link: "/howto/layer-arithmetic/" },
                                { text: "Statistics on layers", link: "/howto/layer-statistics/" },
                                { text: "Zonal statistics on layers", link: "/howto/zonal-statistics/" },
                                { text: "Neutral landscapes creation", link: "/howto/neutral-landscapes/" },
                                { text: "Splitting layers in tiles", link: "/howto/split-layer/" },
                                { text: "Clustering layers", link: "/howto/cluster-layers/" },
                                { text: "Multivariate layers transofmration", link: "/howto/multivariate-stats/" },
                            ]
                        },
                        {
                            text: "Data preparation",
                            items: [
                                { text: "Getting GBIF data", link: "/howto/get-gbif-data/" },
                                { text: "Getting STAC data", link: "/howto/stac/" },
                                { text: "Reading part of a layer", link: "/howto/read-part-layer/" },
                                { text: "Listing provided layers", link: "/howto/list-provided-layers/" },
                                { text: "Data interpolation", link: "/howto/interpolate/" },
                            ]
                        },
                        {
                            text: "Working with occurrence data",
                            items: [
                                { text: "Bounding boxes", link: "/howto/get-boundingbox/" },
                                { text: "Access layers at occurrences positions", link: "/howto/layer-occurrences/" },
                                { text: "Pseudo-absences", link: "/howto/pseudoabsences/" },
                                { text: "Hyper-parameters", link: "/howto/change-hyperparameters/" },
                                { text: "Makie integration", link: "/howto/makie/" },
                            ]
                        }
                    ]
                }
            ],
            "/tutorials/": [
                {
                    text: "Tutorials",
                    items: [
                        { text: "Calculating climate novelty", link: "/tutorials/climatenovelty/" },
                        { text: "Building the BIOCLIM model", link: "/tutorials/bioclim/" },
                        { text: "Generating a landcover consensus", link: "/tutorials/consensus/" },
                        { text: "Generating fauxcurrences", link: "/tutorials/fauxcurrences/" },
                        { text: "Generating virtual species", link: "/tutorials/virtual-species/" },
                        { text: "Identifying spatial boundaries", link: "/tutorials/spatial-boundaries/" },
                        { text: "SDMs 1 - training", link: "/tutorials/sdemo-introduction/" },
                        { text: "SDMs 2 - mapping", link: "/tutorials/sdemo-vignette/" },
                    ]
                }
            ],
            "/reference/": [
                {
                    text: "SpeciesDistributionToolkit",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/" },
                        { text: "GADM", link: "/reference/sdt/gadm/" },
                        { text: "Polygons", link: "/reference/sdt/gadm/" },
                        { text: "Pseudoabsences", link: "/reference/sdt/pseudoabsences/" },
                        { text: "GBIF", link: "/reference/sdt/gbif/" },
                        { text: "Changelog", link: "/reference/CHANGELOG/" },
                    ]
                },
                {
                    text: "GBIF",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/gbif/" },
                        { text: "Types", link: "/reference/gbif/types/" },
                        { text: "Data", link: "/reference/gbif/data/" },
                        { text: "Enumerated values", link: "/reference/gbif/enumerated/" },
                        { text: "Internals", link: "/reference/gbif/internals/" },
                        { text: "Changelog", link: "/reference/gbif/CHANGELOG/" },
                    ]
                },
                {
                    text: "OccurrencesInterface",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/occint/" },
                        { text: "Changelog", link: "/reference/occint/CHANGELOG/" },
                    ]
                },
                {
                    text: "Phylopic",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/phylopic/" },
                        { text: "Changelog", link: "/reference/phylopic/CHANGELOG/" },
                    ]
                },
                {
                    text: "Fauxcurrences",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/fauxcurrences/" },
                        { text: "Changelog", link: "/reference/fauxcurrences/CHANGELOG/" },
                    ]
                },
                {
                    text: "SDeMo",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/sdemo/" },
                        { text: "Models", link: "/reference/sdemo/models/" },
                        { text: "Ensembles", link: "/reference/sdemo/ensembles/" },
                        { text: "Saving", link: "/reference/sdemo/saving/" },
                        { text: "Cross-validation", link: "/reference/sdemo/crossvalidation/" },
                        { text: "Feature selection", link: "/reference/sdemo/features/" },
                        { text: "Explanations", link: "/reference/sdemo/explanations/" },
                        { text: "Changelog", link: "/reference/sdemo/CHANGELOG/" },
                    ]
                },
                {
                    text: "SimpleSDMDatasets",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/datasets/" },
                        { text: "Interface", link: "/reference/datasets/interface/" },
                        { text: "Types", link: "/reference/datasets/types/" },
                        { text: "Internal", link: "/reference/datasets/internals/" },
                        { text: "Changelog", link: "/reference/datasets/CHANGELOG/" },
                    ]
                },
                {
                    text: "SimpleSDMLayers",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/reference/layers/" },
                        { text: "Types", link: "/reference/layers/types/" },
                        { text: "Operations", link: "/reference/layers/operations/" },
                        { text: "Changelog", link: "/reference/layers/CHANGELOG/" },
                    ]
                },
                {
                    text: "Contribute",
                    items: [
                        { text: "Code of Conduct", link: "/reference/code-of-conduct/" },
                        { text: "Contribution guidelines", link: "/reference/contributing/" },
                        { text: "Discussions", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions" },
                        { text: "Good first issues", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22" },
                    ]
                }
            ]
        },
        editLink: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
        socialLinks: [
            { icon: 'github', link: 'REPLACE_ME_DOCUMENTER_VITEPRESS' }
        ],
        footer: {
            message: 'Made with <a href="https://luxdl.github.io/DocumenterVitepress.jl/dev/" target="_blank"><strong>DocumenterVitepress.jl</strong></a> by the <a href="https://poisotlab.io/" target="_blank">Computational Ecology Research Group</a><br>',
            copyright: `This documentation is released under the <a href="https://creativecommons.org/licenses/by/4.0/deed.en" target="_blank">CC-BY 4.0 licence</a> - ${new Date().getUTCFullYear()}`
        }
    }
})
