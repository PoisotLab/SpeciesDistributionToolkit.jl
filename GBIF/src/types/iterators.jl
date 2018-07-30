import Base.length, Base.getindex, Base.endof, Base.start, Base.done, Base.next

function length(o::GBIFRecords)
  length(o.occurrences)
end

function getindex(o::GBIFRecords, i::Int64)
  o.occurrences[i]
end

function getindex(o::GBIFRecords, r::UnitRange{Int64})
  o.occurrences[r]
end

function endof(o::GBIFRecords)
  endof(o.occurrences)
end

function start(o::GBIFRecords)
  start(o.occurrences)
end

function done(o::GBIFRecords, i::Any)
  done(o.occurrences, i)
end

function next(o::GBIFRecords, i::Any)
  next(o.occurrences, i)
end
