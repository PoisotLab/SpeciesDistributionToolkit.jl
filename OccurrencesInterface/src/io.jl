function save(file, occ::Occurrences, args...)
    return save(file, elements(occ), args...)
end

function save(file, occ::Vector{Occurrence}, args...)
    open(file, "w") do f
        JSON.print(f, occ, args...)
    end
    return file
end

@testitem "We can save a series of occurrences" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), (rand(), rand()), Dates.now()) for i in 1:100]
    occs = Occurrences(occ)
    jsonfile = OccurrencesInterface.save(tempname(), occs, 4)
    @test isfile(jsonfile)
end

function _kwargs_from_occdict(d)
    kw = []
    for fn in fieldnames(Occurrence)
        if string(fn) in keys(d)
            val = d[string(fn)]
            if !isnothing(val)
                if fn == :where
                    val = tuple(float.(val)...)
                end
                if fn == :when
                    val = DateTime(val)
                end
                push!(kw, fn => val)
            end
        end
    end
    return kw
end

function load(file)
    @assert isfile(file)
    records = JSON.parsefile(file)
    return Occurrences([Occurrence(; _kwargs_from_occdict(r)...) for r in records])
end

@testitem "We can load a series of occurrences" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), (rand(), rand()), Dates.now()) for i in 1:20]
    occs = Occurrences(occ)
    jsonfile = OccurrencesInterface.save(tempname(), occs, 4)
    @test isfile(jsonfile)
    newoccs = OccurrencesInterface.load(jsonfile)
    for i in eachindex(elements(newoccs))
        @test elements(newoccs)[i].when == elements(occs)[i].when
        @test elements(newoccs)[i].where == elements(occs)[i].where
        @test elements(newoccs)[i].presence == elements(occs)[i].presence
    end
end

@testitem "We can load a series of occurrences with no locations" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), missing, Dates.now()) for i in 1:20]
    occs = Occurrences(occ)
    jsonfile = OccurrencesInterface.save(tempname(), occs, 4)
    @test isfile(jsonfile)
    newoccs = OccurrencesInterface.load(jsonfile)
    for i in eachindex(elements(newoccs))
        @test elements(newoccs)[i].when == elements(occs)[i].when
        @test elements(newoccs)[i].where === elements(occs)[i].where
        @test elements(newoccs)[i].presence == elements(occs)[i].presence
    end
end

@testitem "We can load a series of occurrences with no dates" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), missing, missing) for i in 1:20]
    occs = Occurrences(occ)
    jsonfile = OccurrencesInterface.save(tempname(), occs, 4)
    @test isfile(jsonfile)
    newoccs = OccurrencesInterface.load(jsonfile)
    for i in eachindex(elements(newoccs))
        @test elements(newoccs)[i].when === elements(occs)[i].when
        @test elements(newoccs)[i].where === elements(occs)[i].where
        @test elements(newoccs)[i].presence == elements(occs)[i].presence
    end
end

@testitem "We can load a series of occurrences with partial dates" begin
    using Dates
    occ = [Occurrence("speciessp",rand(Bool), missing, Dates.DateTime(Dates.Year(rand(1999:2025)))) for i in 1:20]
    occs = Occurrences(occ)
    jsonfile = OccurrencesInterface.save(tempname(), occs, 4)
    @test isfile(jsonfile)
    newoccs = OccurrencesInterface.load(jsonfile)
    for i in eachindex(elements(newoccs))
        @test elements(newoccs)[i].when === elements(occs)[i].when
        @test elements(newoccs)[i].where === elements(occs)[i].where
        @test elements(newoccs)[i].presence == elements(occs)[i].presence
    end
end