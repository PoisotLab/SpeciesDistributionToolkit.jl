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
            light: "everforest-light",
            dark: "everforest-dark"
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
                    {text: "Tutorial", link: "/tutorials"},
                    {text: "How-to", link: "/howto"},
                    {text: "Reference", link: "/reference"}
                ]
            },
            {
                text: 'Datasets',
                items: [
                    { text: "CHELSA 1", link: "/datasets/CHELSA1" },
                    { text: "CHELSA 2", link: "/datasets/CHELSA2" },
                    { text: "WorldClim 2", link: "/datasets/WorldClim2" },
                    { text: "PaleoClim", link: "/datasets/PaleoClim" },
                    { text: "EarthEnv", link: "/datasets/EarthEnv" },
                    { text: "BiodiversityMapping", link: "/datasets/BiodiversityMapping" },
                ]
            },
            {
                text: "Ecosystem",
                items: [
                    {
                        text: "Core packages",
                        items: [
                            { text: "OccurrencesInterface.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/OccurrencesInterface/" },
                            { text: "GBIF.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/" },
                            { text: "Phylopic.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/" },
                            { text: "Fauxcurrences.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/" },
                            { text: "SimpleSDMLayers.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMLayers/" },
                            { text: "SimpleSDMDatasets.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/" },
                            { text: "SDeMo.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SDeMo/" },

                        ]
                    },
                    {
                        text: "Other packages",
                        items: [
                            { text: "BON.jl", link: "https://poisotlab.github.io/BiodiversityObservationNetworks.jl/dev/" },
                            { text: "SpatialBoundaries.jl", link: "https://poisotlab.github.io/SpatialBoundaries.jl/dev/" }
                        ]
                    }

                ]
            }
        ],
        sidebar: {
            "/howto/": [
                {
                    text: "How-to...",
                    items: [
                        {text: "... get GBIF data?", link: "/howto/get-gbif-data/"},
                        {text: "... interpolate data?", link: "/howto/interpolate/"},
                        {text: "... list provided layers?", link: "/howto/list-provided-layers/"},
                        {text: "... do arithmetic on layers?", link: "/howto/layer-arithmetic/"},
                        {text: "... mask a layer?", link: "/howto/mask-layer/"},
                        {text: "... mask with polygons", link: "/howto/mask-polygons/"},
                        {text: "... read part of a layer?", link: "/howto/read-part-layer/"},
                        {text: "... calculate statistics on layers?", link: "/howto/layer-statistics/"},
                        {text: "... calculate zonal statistics?", link: "/howto/zonal-statistics/"},
                        {text: "... generate pseudo-absences?", link: "/howto/pseudoabsences/"},
                        {text: "... split a layer in tiles?", link: "/howto/split-layer/"},
                        {text: "... plot using Makie?", link: "/howto/makie/"},
                        {text: "... index layers by occurrences?", link: "/howto/layer-occurrences/"},
                    ]
                }
            ],
            "/tutorials/": [
                {
                    text: "Tutorials",
                    items: [
                        {text: "Calculating climate novelty", link: "/tutorials/climatenovelty/"},
                        {text: "Building the BIOCLIM model", link: "/tutorials/bioclim/"},
                        {text: "Generating a landcover consensus", link: "/tutorials/consensus/"},
                        {text: "Generating fauxcurrences", link: "/tutorials/fauxcurrences/"},
                        {text: "Using wit the SDeMo package", link: "/tutorials/sdemo/"},
                    ]
                }
            ],
            "/reference/": [
                {
                    text: "GBIF",
                    items: [
                        {text: "Documentation", link: "/reference/gbif/"},
                        {text: "Types", link: "/reference/gbif/types/"},
                        {text: "Data", link: "/reference/gbif/data/"},
                        {text: "Enumerated values", link: "/reference/gbif/enumerated/"},
                        {text: "Internals", link: "/reference/gbif/internals/"},
                    ]
                },
                {
                    text: "Fauxcurrences",
                    items: [
                        {text: "Documentation", link: "/reference/fauxcurrences/"},
                    ]
                },
                {
                    text: "Contribute",
                    items: [
                        {text: "Contribution guidelines", link: "/reference/contributing/"},
                        {text: "Discussions", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/discussions"},
                        {text: "Good first issues", link: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22"},
                        {
                            text: "Changelogs",
                            items: [
                                {text: "SpeciesDistributionToolkit", link: "/reference/CHANGELOG/"},
                                {text: "GBIF", link: "/reference/gbif/CHANGELOG/"},
                                {text: "OccurrencesInterface", link: "/reference/occint/CHANGELOG/"},
                                {text: "Phylopic", link: "/reference/phylopic/CHANGELOG/"},
                                {text: "Fauxcurrences", link: "/reference/fauxcurrences/CHANGELOG/"},
                                {text: "SDeMo", link: "/reference/SDeMo/CHANGELOG/"},
                                {text: "SimpleSDMDatasets", link: "/reference/datasets/CHANGELOG/"},
                                {text: "SimpleSDMLayers", link: "/reference/layers/CHANGELOG/"},
                            ]
                        }
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
