import Base.show

_strfmt(str::T) where {T}  = str
_strfmt(::Nothing) = "<nothing>"

"""
**Show an occurrence**

    show(io::IO, o::GBIFRecord)

Displays the key, the taxon name, and the country of observation.
"""
function show(io::IO, o::GBIFRecord)
  println(io, "GBIF record $(_strfmt(o.key))\t$(_strfmt(o.taxon.name))\t($(_strfmt(o.country)))")
end

"""
**Show several occurrences**

    show(io::IO, o::GBIFRecords)

Displays the total number, and the number of currently unmasked records.
"""
function show(io::IO, o::GBIFRecords)
  println(io, "GBIF records: downloaded $(length(o)) out of $(count(o))")
end

"""
**Show a taxonomic record**

    show(io::IO, t::GBIFTaxon)

Displays the taxon name.
"""
function show(io::IO, t::GBIFTaxon)
  println(io, "GBIF taxon -- $(_strfmt(t.name))")
end
