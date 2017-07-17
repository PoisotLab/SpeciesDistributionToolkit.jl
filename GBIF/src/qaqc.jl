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
**Cleans a search output**

By default, this removes all observations with issues -- which is going to
remove a lot of observations. Potentially *all* the observations, in fact.

Note that once a series of occurrences have been put through this function, it
is impossible to call `next!` or `complete!` on them. On the other hand,
`restart!` will work.

For this reason, it is recommended to create a copy of the `Occurrences` object
before applying quality control on it.
"""
function qualitycontrol!{T<:Function}(o::Occurrences; filters::Array{T,1}=[have_no_issues], verbose::Bool=true)
  if verbose
    info("Starting quality control with ", length(o.occurrences), " records")
  end
  for f in filters
    o.occurrences = filter(f, o.occurrences)
    if verbose
      info(length(o.occurrences), " records left after ", f)
    end
  end
  o.cleaned=true
end
