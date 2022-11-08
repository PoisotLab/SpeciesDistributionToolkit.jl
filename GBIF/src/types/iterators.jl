import Base.length, Base.getindex, Base.iterate, Base.view, Base.size

function view(o::GBIFRecords)
    defined = filter(i -> isassigned(o.occurrences, i), eachindex(o.occurrences))
    view(o.occurrences, defined)
end

function size(o::GBIFRecords)
    length(o.occurrences)
end

function length(o::GBIFRecords)
    length(view(o))
end

function getindex(o::GBIFRecords, i::Int64)
    view(o)[i]
end

function getindex(o::GBIFRecords, r::UnitRange{Int64})
    view(o)[r]
end

function iterate(o::GBIFRecords)
    iterate(collect(view(o)))
end

function iterate(o::GBIFRecords, t::Union{Int64,Nothing})
    iterate(collect(view(o)), t)
end
