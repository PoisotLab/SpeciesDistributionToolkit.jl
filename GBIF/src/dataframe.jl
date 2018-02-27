import DataFrames.DataFrame
import Missings.missing

"""
**Export the occurrences as a data frame**

This function will loop through all the fields in occurrences, and aggregate
them in a dataframe. In the case where a value is not specified for a given
field, the `missing` value/type will be used.
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
