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
      light: "github-light",
      dark: "github-dark"}
  },
  themeConfig: {
    outline: 'deep',
    logo: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav: [
        {text: 'Index', link:'/index'},
        {text: 'Getting started', link:'/getting_started'},
        {
                text: 'Datasets',
                items : [
                    {
                        text: "CHELSA 1",
                        items: [
                            {text: "MinimumTemperature", link: "/datasets/CHELSA1/MinimumTemperature"},
                            {text: "AverageTemperature", link: "/datasets/CHELSA1/AverageTemperature"},
                            {text: "MaximumTemperature", link: "/datasets/CHELSA1/MaximumTemperature"},
                            {text: "Precipitation", link: "/datasets/CHELSA1/Precipitation"},
                            {text: "BioClim", link: "/datasets/CHELSA1/BioClim"},
                        ]
                    },
                    {
                        text: "CHELSA 2",
                        items: [
                            {text: "MinimumTemperature", link: "/datasets/CHELSA2/MinimumTemperature"},
                            {text: "AverageTemperature", link: "/datasets/CHELSA2/AverageTemperature"},
                            {text: "MaximumTemperature", link: "/datasets/CHELSA2/MaximumTemperature"},
                            {text: "Precipitation", link: "/datasets/CHELSA2/Precipitation"},
                            {text: "BioClim", link: "/datasets/CHELSA2/BioClim"},
                        ]
                    },
                    {
                        text: "WorldClim 2",
                        items: [
                            {text: "MinimumTemperature", link: "/datasets/WorldClim2/MinimumTemperature"},
                            {text: "AverageTemperature", link: "/datasets/WorldClim2/AverageTemperature"},
                            {text: "MaximumTemperature", link: "/datasets/WorldClim2/MaximumTemperature"},
                            {text: "Precipitation", link: "/datasets/WorldClim2/Precipitation"},
                            {text: "SolarRadiation", link: "/datasets/WorldClim2/SolarRadiation"},
                            {text: "WaterVaporPressure", link: "/datasets/WorldClim2/WaterVaporPressure"},
                            {text: "WindSpeed", link: "/datasets/WorldClim2/WindSpeed"},
                            {text: "BioClim", link: "/datasets/WorldClim2/BioClim"},
                        ]
                    },
                    {
                        text: "PaleoClim",
                        items: [
                            {text: "BioClim", link: "/datasets/PaleoClim/BioClim"},
                        ]
                    },
                    {
                        text: "BiodiversityMapping",
                        items: [
                            {text: "AmphibianRichness", link: "/datasets/BiodiversityMapping/AmphibianRichness"},
                            {text: "BirdRichness", link: "/datasets/BiodiversityMapping/BirdRichness"},
                            {text: "MammalRichness", link: "/datasets/BiodiversityMapping/MammalRichness"},
                        ]
                    },
                    {
                        text: "EarthEnv",
                        items: [
                            {text: "LandCover", link: "/datasets/EarthEnv/LandCover"},
                            {text: "HabitatHeterogeneity", link: "/datasets/EarthEnv/HabitatHeterogeneity"},
                        ]
                    }
                ]
        },
        {
            text: "Ecosystem",
            items: [
                {text: "GBIF.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/GBIF/dev/"},
                {text: "Phylopic.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Phylopic/dev/"},
                {text: "Fauxcurrences.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/Fauxcurrences/dev/"},
                {text: "SimpleSDMLayers.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMLayers/dev/"},
                {text: "SimpleSDMDatasets.jl", link: "https://poisotlab.github.io/SpeciesDistributionToolkit.jl/SimpleSDMDatasets/dev/"}
            ]
        }
    ],
    sidebar: 'REPLACE_ME_DOCUMENTER_VITEPRESS',
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