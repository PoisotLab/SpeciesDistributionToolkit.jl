"""
**Both latitude and longitude are present**

This filter will only retain occurrences that have *both* a latitude and a
longitude field.
"""
function have_both_coordinates(o::Occurrence)
  !(isa(o.latitude, Void)&isa(o.latitude, Void))
end

"""
**Neither latitude nor longitude are 0.0**

This filter will only retain occurrences that are *not* at the (0,0) coordinate.
"""
function have_neither_zero_coordinates(o::Occurrence)
  !((o.latitude==0.0)&(o.longitude==0.0))
end

"""
**At most one of latitude and longitude is 0.0**

This filter will only retain occurrences that have *at most* one coordinate
being exactly 0.0.
"""
function have_no_zero_coordinates(o::Occurrence)
  !((o.latitude==0.0)|(o.longitude==0.0))
end

"""
**No known issues at all**

This filter will retain no observation. At least not in theory, but it is very
rare to have GBIF records with absolutely no issues. Its use is discouraged.

By design, it is the default argument for `qualitycontrol!` -- it's your job to
decide precisely which filters you need to use.
"""
function have_no_issues(o::Occurrence)
  length(o.issues) == 0
end

"""
**No coordinates issues except rounding and WGS84 assumption**

This filter will retain observations that have no issues, with the exception of
assuming WGS84 projection (which a large number of GBIF records do), and rounded
coordinates (same thing). It is a reasonable filter for most use cases.
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

This function reverses the action of `qualitycontrol!`. It will unmask all
records that have been removed under the current filters.
"""
function showall!(o::Occurrences)
  o.show = ones(Bool, length(o.raw))
  o.occurrences = view(o.raw, o.show)
end

"""
**Update the view of occurrences**

This function is used internally by `qualitycontrol!` to act on the view.
"""
function update!(o::Occurrences)
  o.occurrences = view(o.raw, o.show)
end
