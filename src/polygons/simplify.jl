"""
    simplify(mp::V; tolerance=1e-5) where V<:Union{Polygon,MultiPolygon} 

Modifies the polygon (currently using the ArchGDAL `simplify` implementation) to
reduce its complexity.
"""
function simplify(mp::V; tolerance=1e-5) where V<:Union{Polygon,MultiPolygon} 
    spoly = SimpleSDMPolygons.AG.simplify(mp.geometry, tolerance)
    T = SimpleSDMPolygons.GI.trait(spoly) isa SimpleSDMPolygons.GI.PolygonTrait ? Polygon : MultiPolygon
    T(spoly)
end 

simplify(f::Feature; kw...) = Feature(simplify(f.geometry; kw...), f.properties)
simplify(fc::FeatureCollection; kw...) = FeatureCollection(simplify.(fc.features; kw...))


@testitem "We can simplify a polygon" begin
    POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Paris")
    SPOL = SpeciesDistributionToolkit.simplify(POL)
    prelength = SimpleSDMPolygons.GI.coordinates(POL[1].geometry.geometry)[1][1] |> length
    postlength = SimpleSDMPolygons.GI.coordinates(SPOL[1].geometry.geometry)[1] |> length

    @test prelength >= postlength
end

@testitem "We can mask with a simplified polygon" begin
    POL = getpolygon(PolygonData(OpenStreetMap, Places), place="Paris")
    L = SDMLayer(RasterData(CHELSA1, MinimumTemperature); SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)...)
    Lc = count(L)
    SpeciesDistributionToolkit.simplify(POL)
    mask!(L, POL)
    @test typeof(L) <: SDMLayer
    @test count(L) <= Lc
end