
import Base.show

"""
**Show an occurrence**
"""
function show(io::IO, o::GBIFRecord)
  println(io, "GBIF $(o.key)\t$(o.species)\t()$(o.country)")
end

"""
**Show several occurrences**
"""
function show(io::IO, o::GBIFRecords)
  println(io, "GBIF records: viewing $(length(o)) of $(length(o.raw)) out of $(o.count)")
end
