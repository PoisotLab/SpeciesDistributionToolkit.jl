using Weave
weave(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"), out_path = Pkg.dir("GBIF", "docs", "index.md"), doctype = "pandoc")
