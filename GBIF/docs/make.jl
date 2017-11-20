push!(LOAD_PATH, "../src/")

using Documenter, GBIF

makedocs(
    modules = [GBIF]
)

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math", "mkdocs-cinder"),
    repo = "github.com/EcoJulia/GBIF.jl.git",
    julia = "0.6",
    osname = "linux"
)
