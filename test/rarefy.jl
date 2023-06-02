@testitem "Rarefy returns the correct number of points" begin

    random_layer = SimpleSDMResponse(rand(Bool, (20, 30)))
    
    rarefied_layer = rarefy(random_layer, 100)
    replace!(rarefied_layer, false => nothing)
    @info rarefied_layer

end
