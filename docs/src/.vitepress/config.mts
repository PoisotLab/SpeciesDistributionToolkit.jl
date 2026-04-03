import { defineConfig } from 'vitepress'
import mathjax3 from "markdown-it-mathjax3";

// https://vitepress.dev/reference/site-config
export default defineConfig({
    base: 'REPLACE_ME_DOCUMENTER_VITEPRESS',// TODO: replace this in makedocs!
    title: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
    description: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
    lastUpdated: true,
    cleanUrls: true,
    outDir: 'REPLACE_ME_DOCUMENTER_VITEPRESS', // This is required for MarkdownVitepress to work correctly...
    head: [['link', { rel: 'icon', href: 'favicon.ico' }]],
    ignoreDeadLinks: true,
    markdown: {
        math: true,
        config: (md) => {
            md.use(mathjax3)
        },
        image: {
            lazyLoading: true
        },
        theme: {
            light: "catppuccin-latte",
            dark: "catppuccin-macchiato"
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
            { text: "Manual", link: "/manual" },
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
            "/manual/": [
                {
                    text: "Manual",
                    items: [
                        {
                            text: "Use-cases",
                            collapsed: true,
                            items: [
                                { text: "Getting started", link: "/manual/usecases/getting-started/" },
                                { text: "Climate novelty", link: "/manual/usecases/climatenovelty/" },
                                { text: "Landcover consensus", link: "/manual/usecases/consensus/" },
                                { text: "Spatial boundaries", link: "/manual/usecases/spatial-boundaries/" },
                                { text: "Maxent", link: "/manual/usecases/maxent/" },
                                { text: "Predicting probabilities", link: "/manual/usecases/adaboost/" },
                                { text: "Shift and rotate", link: "/manual/usecases/shift-and-rotate/" },
                                { text: "Conformal prediction", link: "/manual/usecases/conformal/" },
                                { text: "Covariate shift", link: "/manual/usecases/covariate-shift/" },
                            ]
                        },
                        {
                            text: "Data retrieval",
                            collapsed: true,
                            items: [
                                { text: "GBIF API", link: "/manual/retrieval/gbif-api/" },
                                { text: "GBIF downloads", link: "/manual/retrieval/gbif-download/" },
                                { text: "Local GBIF files", link: "/manual/retrieval/gbif-local/" },
                                { text: "STAC catalogues", link: "/manual/retrieval/stac/" },
                                { text: "List raster layers", link: "/manual/retrieval/list-raster-layers/" },
                                { text: "List polygon information", link: "/manual/retrieval/list-polygon-information/" },
                            ]
                        },
                        {
                            text: "Operations on layers",
                            collapsed: true,
                            items: [
                                { text: "Arithmetic", link: "/manual/layers/layer-arithmetic/" },
                                { text: "Statistics", link: "/manual/layers/layer-statistics/" },
                                { text: "Multivariate transformations", link: "/manual/layers/multivariate/" },
                                { text: "Clustering", link: "/manual/layers/clustering/" },
                            ]
                        },
                        {
                            text: "Polygons and masking",
                            collapsed: true,
                            items: [
                                { text: "Masking layers", link: "/manual/polygons/masking-a-layer/" },
                                { text: "Masking with polygons", link: "/manual/polygons/masking-with-polygons/" },
                                { text: "Polygon operations", link: "/manual/polygons/operations/" },
                                { text: "Zonal statistics", link: "/manual/polygons/zonal-statistics/" },
                                { text: "Tessellation", link: "/manual/polygons/tessellation/" },
                            ]
                        },
                        {
                            text: "Data generation",
                            collapsed: true,
                            items: [
                                { text: "Neutral landscapes", link: "/manual/generation/neutral-landscapes/" },
                                { text: "Pseudo-absences", link: "/manual/generation/pseudoabsences/" },
                                { text: "Fauxcurrences", link: "/manual/generation/fauxcurrences/" },
                                { text: "Virtual species", link: "/manual/generation/virtual-species/" },
                                { text: "Occurrences from layers", link: "/manual/generation/occurrences-from-layer/"},
                            ]
                        },
                        {
                            text: "Data usage",
                            collapsed: true,
                            items: [
                                { text: "Bounding boxes", link: "/manual/usage/boundingbox/" },
                                { text: "Reading part of a layer", link: "/manual/usage/read-part-layer/" },
                                { text: "Splitting and tiling", link: "/manual/usage/tiling/" },
                                { text: "Coarsening layers", link: "/manual/usage/coarsening/" },
                                { text: "Sliding windows", link: "/manual/usage/sliding-windows/" },
                                { text: "Projection", link: "/manual/usage/projection/" },
                                { text: "Layers and occurrences", link: "/manual/usage/layers-occurrences/" },
                                { text: "Variograms", link: "/manual/usage/variogram/" },
                                { text: "Spatial cross-validation", link: "/manual/usage/spatial-crossvalidation/" },
                            ]
                        },
                        {
                            text: "Building models",
                            collapsed: true,
                            items: [
                                { text: "Pipeline", link: "/manual/sdm/pipeline/" },
                                { text: "Cross-validation", link: "/manual/sdm/crossvalidation/" },
                                { text: "Variable selection", link: "/manual/sdm/variableselection/" },
                                { text: "Feature importance", link: "/manual/sdm/featureimportance/" },
                                { text: "Hyper-parameters", link: "/manual/sdm/hyperparameters/" },
                                { text: "PR and ROC curves", link: "/manual/sdm/pr-roc/" },
                                { text: "Interpretability", link: "/manual/sdm/interpretability/" },
                                { text: "Counterfactuals", link: "/manual/sdm/counterfactuals/" },
                                { text: "Calibration", link: "/manual/sdm/calibration/" },
                                { text: "Conformal", link: "/manual/sdm/conformal/" },
                            ]
                        },
                        {
                            text: "Data visualization",
                            collapsed: true,
                            items: [
                                { text: "Layers", link: "/manual/dataviz/layers/" },
                                { text: "Occurrences", link: "/manual/dataviz/occurrences/" },
                                { text: "Polygons", link: "/manual/dataviz/polygons/" },
                                { text: "Models", link: "/manual/dataviz/models/" },
                                { text: "Projections", link: "/manual/dataviz/projections/" },
                                { text: "Graticules", link: "/manual/dataviz/graticules/" },
                                { text: "Bivariate", link: "/manual/dataviz/bivariate/" },
                                { text: "VSUP", link: "/manual/dataviz/vsup/" },
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
