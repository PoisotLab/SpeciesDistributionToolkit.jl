"""
**Both latitude and longitude are present**
"""
function have_both_coordinates(o::Occurrence)
  !(isa(o.latitude, Void)&isa(o.latitude, Void))
end

"""
**Neither latitude nor longitude are 0.0**
"""
function have_neither_zero_coordinates(o::Occurrence)
  !((o.latitude==0.0)&(o.longitude==0.0))
end

"""
**At most one of latitude and longitude is 0.0**
"""
function have_no_zero_coordinates(o::Occurrence)
  !((o.latitude==0.0)|(o.longitude==0.0))
end

"""
**No known issues at all**
"""
function have_no_issues(o::Occurrence)
  length(o.issues) == 0
end

"""
**No coordinates issues except rounding and WGS84 assumption**
"""
function have_ok_coordinates(o::Occurrence)
  ok = true
  for i in o.issues
    if !(i in [:COORDINATE_ROUNDED, :GEODETIC_DATUM_ASSUMED_WGS84])
      ok = false
    end
  end
  return ok
end

"""
**Cleans a search output**

UPDATE
"""
function qualitycontrol!{T<:Function}(o::Occurrences; filters::Array{T,1}=[have_no_issues], verbose::Bool=true)
  keep = ones(Bool, length(o.raw))
  if verbose
    info("Starting quality control with ", length(o.raw), " records")
  end
  for f in filters
    keep_f = map(f, o.occurrences)
    keep = keep .* keep_f
    if verbose
      info(count(keep), " records left after ", f)
    end
  end
  o.show = keep
  update!(o)
end

"""
**Show all occurrences**

This function reverses the action of `qualitycontrol!`.
"""
function showall!(o::Occurrences)
  o.show = ones(Bool, length(o.raw))
  o.occurrences = view(o.raw, o.show)
end

"""
**Update the view of occurrences**
"""
function update!(o::Occurrences)
  o.occurrences = view(o.raw, o.show)
end
