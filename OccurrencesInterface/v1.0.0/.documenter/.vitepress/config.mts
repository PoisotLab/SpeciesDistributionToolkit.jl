import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: '/SpeciesDistributionToolkit.jl/OccurrencesInterface/',// TODO: replace this in makedocs!
  title: 'OccurrencesInterface',
  description: 'Documentation for SpeciesDistributionToolkit.jl',
  lastUpdated: true,
  cleanUrls: true,
  outDir: '../final_site', // This is required for MarkdownVitepress to work correctly...
  
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
    
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav: [
{ text: 'An interface for occurrence data', link: '/index' }
]
,
    sidebar: [
{ text: 'An interface for occurrence data', link: '/index' }
]
,
    editLink: { pattern: "https://github.com/PoisotLab/SpeciesDistributionToolkit.jl/edit/main/docs/src/:path" },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/PoisotLab/SpeciesDistributionToolkit.jl' }
    ],
    footer: {
      message: 'Made with <a href="https://luxdl.github.io/DocumenterVitepress.jl/dev/" target="_blank"><strong>DocumenterVitepress.jl</strong></a><br>',
      copyright: `© Copyright ${new Date().getUTCFullYear()}.`
    }
  }
})
