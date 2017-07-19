using Weave

tangle(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"))
weave(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"), out_path = Pkg.dir("GBIF", "docs", "index.md"), doctype = "pandoc")
weave(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"), out_path = Pkg.dir("GBIF", "README.md"), doctype = "pandoc")
