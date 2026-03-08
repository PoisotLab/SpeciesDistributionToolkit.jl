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
        siteTitle: 'SDT.jl',
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
            { text: "Tutorials", link: "/tutorials" },
            { text: "How-to", link: "/howto" },
            {
                text: 'Datasets',
                items: [
                    {
                        text: "Raster data",
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
                        text: "Polygon data",
                        items: [
                            { text: "EPA", link: "/polygons/EPA" },
                            { text: "GADM", link: "/polygons/GADM" },
                            { text: "Natural Earth", link: "/polygons/NaturalEarth" },
                            { text: "One Earth", link: "/polygons/OneEarth" },
                            { text: "OpenStreetMap", link: "/polygons/OpenStreetMap" },
                            { text: "Resolve", link: "/polygons/Resolve" },
                            { text: "ESRI", link: "/polygons/ESRI" },
                        ]
                    }
                ]
            },
            {
                text: "Ecosystem",
                items: [
                    { text: "Internals", link: "/internals/" },
                    {
                        text: "Core packages",
                        items: [
                            { text: "Fauxcurrences.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/" },
                            { text: "GBIF.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/" },
                            { text: "OccurrencesInterface.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/OccurrencesInterface/" },
                            { text: "Phylopic.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/" },
                            { text: "PseudoAbsences.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/PseudoAbsences/" },
                            { text: "SDeMo.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SDeMo/" },
                            { text: "SimpleSDMDatasets.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/" },
                            { text: "SimpleSDMPolygons.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMPolygons/" },
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
                            text: "Data retrieval",
                            collapsed: true,
                            items: [
                                { text: "GBIF API", link: "/howto/retrieval/gbif-api/" },
                                { text: "GBIF downloads", link: "/howto/retrieval/gbif-download/" },
                                { text: "STAC catalogues", link: "/howto/retrieval/stac/" },
                                { text: "List raster layers", link: "/howto/retrieval/list-raster-layers/" },
                                { text: "List polygon information", link: "/howto/retrieval/list-polygon-information/" },
                            ]
                        },
                        {
                            text: "Operations on layers",
                            collapsed: true,
                            items: [
                                { text: "Arithmetic", link: "/howto/layers/layer-arithmetic/" },
                                { text: "Statistics", link: "/howto/layers/layer-statistics/" },
                                { text: "Multivariate transformations", link: "/howto/layers/multivariate/" },
                                { text: "Clustering", link: "/howto/layers/clustering/" },
                            ]
                        },
                        {
                            text: "Polygons and masking",
                            collapsed: true,
                            items: [
                                { text: "Masking layers", link: "/howto/polygons/masking-a-layer/" },
                                { text: "Masking with polygons", link: "/howto/polygons/masking-with-polygons/" },
                                { text: "Polygon operations", link: "/howto/polygons/operations/" },
                                { text: "Zonal statistics", link: "/howto/polygons/zonal-statistics/" },
                            ]
                        },
                        {
                            text: "Data generation",
                            collapsed: true,
                            items: [
                                { text: "Neutral landscapes", link: "/howto/generation/neutral-landscapes/" },
                                { text: "Pseudo-absences", link: "/howto/generation/pseudoabsences/" },
                            ]
                        },
                        {
                            text: "Data usage",
                            collapsed: true,
                            items: [
                                { text: "Bounding boxes", link: "/howto/usage/boundingbox/" },
                                { text: "Reading part of a layer", link: "/howto/usage/read-part-layer/" },
                                { text: "Splitting and tiling", link: "/howto/usage/tiling/" },
                                { text: "Coarsening layers", link: "/howto/usage/coarsening/" },
                                { text: "Sliding windows", link: "/howto/usage/sliding-windows/" },
                                { text: "Projection", link: "/howto/usage/projection/" },
                                { text: "Layers and occurrences", link: "/howto/usage/layers-occurrences/" },
                            ]
                        },
                        {
                            text: "Distribution models",
                            collapsed: true,
                            items: [
                                { text: "Cross-validation", link: "/howto/sdm/crossvalidation/" },
                                { text: "Variable selection", link: "/howto/sdm/variableselection/" },
                                { text: "Hyper-parameters", link: "/howto/sdm/hyperparameters/" },
                                { text: "PR and ROC curves", link: "/howto/sdm/pr-roc/" },
                                { text: "Interpretability", link: "/howto/sdm/interpretability/" },
                                { text: "Counterfactuals", link: "/howto/sdm/counterfactuals/" },
                                { text: "Calibration", link: "/howto/sdm/calibration/" },
                                { text: "Conformal", link: "/howto/sdm/conformal/" },
                            ]
                        },
                        {
                            text: "Data visualization",
                            collapsed: true,
                            items: [
                                { text: "Layers", link: "/howto/dataviz/layers/" },
                                { text: "Occurrences", link: "/howto/dataviz/occurrences/" },
                                { text: "Polygons", link: "/howto/dataviz/polygons/" },
                                { text: "Models", link: "/howto/dataviz/models/" },
                                { text: "Projections", link: "/howto/dataviz/projections/" },
                                { text: "Graticules", link: "/howto/dataviz/graticules/" },
                            ]
                        }
                    ]
                }
            ],
            "/tutorials/": [
                {
                    text: "Tutorials",
                    items: [
                        {
                            text: "Distribution models",
                            collapsed: false,
                            items: [
                                { text: "Building a model", link: "/tutorials/sdm/training/" },
                                { text: "Bagging", link: "/tutorials/sdm/bagging/" },
                                { text: "Boosting", link: "/tutorials/sdm/adaboost/" },
                                { text: "Conformal prediction", link: "/tutorials/sdm/conformal/" },
                            ]
                        },
                        {
                            text: "General use",
                            collapsed: false,
                            items: [
                                { text: "Climate novelty", link: "/tutorials/usage/climatenovelty/" },
                                { text: "Landcover consensus", link: "/tutorials/usage/consensus/" },
                                { text: "Fauxcurrences", link: "/tutorials/usage/fauxcurrences/" },
                                { text: "Virtual species", link: "/tutorials/usage/virtual-species/" },
                                { text: "Spatial boundaries", link: "/tutorials/usage/spatial-boundaries/" },
                            ]
                        }
                    ]
                }
            ],
            "/internals/": [
                {
                    text: "SpeciesDistributionToolkit",
                    collapsed: true,
                    items: [
                        { text: "Documentation", link: "/internals/" },
                        { text: "Utilities", link: "/internals/integration/utilities/" },
                        { text: "GBIF extension", link: "/internals/integration/gbif/" },
                    ]
                },
                {
                    text: "Interfaces",
                    collapsed: true,
                    items: [
                        { text: "Datasets", link: "/internals/interfaces/datasets/" },
                        { text: "Occurrences", link: "/internals/interfaces/occurrences/" },
                    ]
                },
                {
                    text: "Changelogs",
                    collapsed: true,
                    items: [
                        { text: "SpeciesDistributionToolkit", link: "/internals/changelog/SpeciesDistributionToolkit/" },
                        { text: "Fauxcurrences", link: "/internals/changelog/Fauxcurrences/" },
                        { text: "GBIF", link: "/internals/changelog/GBIF/" },
                        { text: "OccurrencesInterfaces", link: "/internals/changelog/OccurrencesInterface/" },
                        { text: "Phylopic", link: "/internals/changelog/Phylopic/" },
                        { text: "PseudoAbsences", link: "/internals/changelog/PseudoAbsences/" },
                        { text: "SDeMo", link: "/internals/changelog/SDeMo/" },
                        { text: "SimpleSDMDatasets", link: "/internals/changelog/SimpleSDMDatasets/" },
                        { text: "SimpleSDMLayers", link: "/internals/changelog/SimpleSDMLayers/" },
                    ]
                },
                {
                    text: "Contribute",
                    items: [
                        { text: "Code of Conduct", link: "/internals/code-of-conduct/" },
                        { text: "Contribution guidelines", link: "/internals/contributing/" },
                        { text: "Roadmap", link: "https://github.com/orgs/PoisotLab/projects/3" },
                        { text: "Discussions", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions" },
                        { text: "Good first issues", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues?q=is%3Aopen%20is%3Aissue%20label%3A%22%F0%9F%A4%97%20good%20first%20PR%22" },
                    ]
                }
            ]
        },
        editLink: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
        socialLinks: [
            { icon: 'github', link: 'REPLACE_ME_DOCUMENTER_VITEPRESS' }
        ],
        footer: {
            message: 'Made with <a href="https://luxdl.github.io/DocumenterVitepress.jl/dev/" target="_blank"><strong>DocumenterVitepress.jl</strong></a> by the <a href="https://epic-biodiversity.org/" target="_blank">Laboratoire d\'Écologie Prédictive et Interprétable pour la Crise de la Biodiversité</a><br>',
            copyright: `This documentation is released under the <a href="https://creativecommons.org/licenses/by/4.0/deed.en" target="_blank">CC-BY 4.0 licence</a> - ${new Date().getUTCFullYear()}`
        }
    }
})
