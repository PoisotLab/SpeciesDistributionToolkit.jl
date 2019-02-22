import Base.show

"""
**Show an occurrence**
"""
function show(io::IO, o::GBIFRecord)
  println(io, "GBIF record $(o.key)\t$(o.taxon.name)\t($(o.country))")
end

"""
**Show several occurrences**
"""
function show(io::IO, o::GBIFRecords)
  println(io, "GBIF records: viewing $(length(o)) [out of $(o.count)]")
end

"""
**Show a taxonomic record**
"""
function show(io::IO, t::GBIFTaxon)
  println(io, "GBIF taxon -- $(t.name)")
end
