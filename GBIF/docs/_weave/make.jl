using Weave

tangle(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"))
weave(Pkg.dir("GBIF", "docs", "_weave", "index.jmd"), out_path = Pkg.dir("GBIF", "docs", "index.md"), doctype = "pandoc")

tangle(Pkg.dir("GBIF", "docs", "_weave", "ukbirds.jmd"))
convert_doc(Pkg.dir("GBIF", "docs", "_weave", "ukbirds.jmd"), Pkg.dir("GBIF", "docs", "ukbirds.ipynb"))
