import Base.length, Base.getindex, Base.iterate, Base.view

function view(o::GBIFRecords)
    view(o.occurrences, o.show)
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
