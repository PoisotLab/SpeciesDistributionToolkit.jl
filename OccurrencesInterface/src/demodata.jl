_is_valid_latlon(lon, lat) = -180 <= lon <= 180 && -90 <= lat <= 90
_is_valid_latlon(occ::AbstractOccurrence) = _is_valid_latlon(place(occ)...)

"""
    OccurrencesInterface.__demodata()

This dataset has 2147 observations of bigfoot from the Bigfoot Field Researchers
Organization, a community science project on cryptids.
"""
function __demodata()
    datapath = joinpath(dirname(dirname(pathof(OccurrencesInterface))), "data")
    all_occ = OccurrencesInterface.load(joinpath(datapath, "demodata.json"))
    return Occurrences(filter(OccurrencesInterface._is_valid_latlon, elements(all_occ)))
end

@testitem "We can load the demo data" begin
    bigfoot = OccurrencesInterface.__demodata()
    @test bigfoot isa Occurrences
    @test bigfoot[1] isa Occurrence
    @test length(elements(bigfoot)) == 2147
    for occ in elements(bigfoot)
        @test !ismissing(place(occ))
        @test entity(occ) == "Sasquatch"
        @test presence(occ)
    end
end