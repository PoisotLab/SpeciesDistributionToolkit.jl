function __demodata()
    datapath = joinpath(dirname(dirname(pathof(OccurrencesInterface))), "data")
    return OccurrencesInterface.load(joinpath(datapath, "demodata.json"))
end

@testitem "We can load the demo data" begin
    bigfoot = OccurrencesInterface.__demodata()
    @test bigfoot isa Occurrences
    @test bigfoot[1] isa Occurrence
    @test length(elements(bigfoot)) == 2150
end