import DataFrames.DataFrame

"""
**Export the occurrences as a data frame**
"""
function DataFrame(o::Occurrences)
  d = DataFrame()
  for f in fieldnames(Occurrence)
    _tmp = map(x -> getfield(x, f) == nothing ? missing : getfield(x, f), o)
    d[Symbol(f)] = _tmp
  end
  return d
end

import Base.convert

"""
**Convert a series of occurrences into a DataFrame**
"""
function convert(::Type{DataFrame}, o::Occurrences)
  return DataFrame(o)
end
