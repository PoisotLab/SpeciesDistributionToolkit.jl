import Base.length, Base.getindex, Base.iterate

function length(o::GBIFRecords)
  length(o.occurrences)
end

function iterate(o::GBIFRecords)
  next = findfirst(o.show)
  next_next = findfirst(o.show[(next+1):end])+next
  return (o[next], next_next)
end

function iterate(o::GBIFRecords, state::Int64)
  next = findfirst(o.show[(state+1):end])+state
  return (o[state], next)
end

function iterate(o::GBIFRecords, state::Nothing)
  return nothing
end

function getindex(o::GBIFRecords, i::Int64)
  o.occurrences[i]
end

function getindex(o::GBIFRecords, r::UnitRange{Int64})
  o.occurrences[r]
end
