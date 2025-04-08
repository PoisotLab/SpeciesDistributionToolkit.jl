"""
    OccurrencesInterface.__demodata()

This dataset has 2150 observations of bigfoot from the Bigfoot Field Researchers
Organization, a community science project on cryptids.
"""
function __demodata()
    datapath = joinpath(dirname(dirname(pathof(OccurrencesInterface))), "data")
    return OccurrencesInterface.load(joinpath(datapath, "demodata.json"))
end

@testitem "We can load the demo data" begin
    bigfoot = OccurrencesInterface.__demodata()
    @test bigfoot isa Occurrences
    @test bigfoot[1] isa Occurrence
    @test length(elements(bigfoot)) == 2150
    for occ in elements(bigfoot)
        @test !ismissing(place(occ))
        @test entity(occ) == "Sasquatch"
        @test presence(occ)
    end
end