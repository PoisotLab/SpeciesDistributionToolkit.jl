import Base.show

"""
**Show an occurrence**

    show(io::IO, o::GBIFRecord)

Displays the key, the taxon name, and the country of observation.
"""
function show(io::IO, o::GBIFRecord)
  println(io, "GBIF record $(o.key)\t$(o.taxon.name)\t($(o.country))")
end

"""
**Show several occurrences**

    show(io::IO, o::GBIFRecords)

Displays the total number, and the number of currently unmasked records.
"""
function show(io::IO, o::GBIFRecords)
  println(io, "GBIF records: viewing $(length(o)) [out of $(o.count)]")
end

"""
**Show a taxonomic record**

    show(io::IO, t::GBIFTaxon)

Displays the taxon name.
"""
function show(io::IO, t::GBIFTaxon)
  println(io, "GBIF taxon -- $(t.name)")
end
