import Base.length, Base.getindex, Base.iterate, Base.view, Base.count

function view(o::GBIFRecords)
    defined = filter(i -> isassigned(o.occurrences, i), eachindex(o.occurrences))
    return view(o.occurrences, defined)
end

function count(o::GBIFRecords)
    return length(o.occurrences)
end

function length(o::GBIFRecords)
    return length(view(o))
end

function getindex(o::GBIFRecords, i::Int64)
    return view(o)[i]
end

function getindex(o::GBIFRecords, r::UnitRange{Int64})
    return view(o)[r]
end

@testitem "Occurrences have a length and a typeof" begin
    set = occurrences()
    @test typeof(set[1]) == GBIFRecord
    @test length(set[1:4]) == 4
end

function iterate(o::GBIFRecords)
    return iterate(collect(view(o)))
end

function iterate(o::GBIFRecords, t::Union{Int64, Nothing})
    return iterate(collect(view(o)), t)
end

@testitem "We can iterate over records" begin
    set = occurrences()
    @test iterate(set) == (set[1], 2)
    @test iterate(set, 2) == (set[2], 3)
end

@testitem "We can iterate over records made with a non-empty query" begin
    plotor = taxon("Procyon lotor")
    plotor_occ = occurrences(plotor)
    occurrences!(plotor_occ)
    for o in plotor_occ
        @test typeof(o) <: GBIFRecord
        @test o.taxon.species.second == plotor.species.second
    end
end

# Tables.jl interface
Tables.istable(::Type{GBIFRecords}) = true
Tables.rowaccess(::Type{GBIFRecords}) = true
Tables.rows(records::GBIFRecords) = view(records)

@testitem "We can convert records to a data frame" begin
    using DataFrames
    
    df = DataFrame(occurrences())
    @test typeof(df) <: DataFrame
end