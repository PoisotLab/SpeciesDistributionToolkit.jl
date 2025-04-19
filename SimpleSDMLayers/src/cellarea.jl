"""
    cellarea(layer::T; R = 6371.0)

Returns the area of each cell in km², assuming a radius of the Earth or `R` (in
km). This is only returned for layers in WGS84, which can be forced with
`interpolate`.
"""
function cellarea(layer::T; R = 6371.0) where {T <: SDMLayer}
    @assert isequal("+proj=longlat +datum=WGS84 +no_defs")(layer.crs)
    lonstride, latstride = 2.0 .* stride(layer)
    cells_per_ribbon = 360.0 / lonstride
    latitudes_ranges = LinRange(layer.y..., length(northings(layer))+1)
    # We need to express the latitudes in gradients for the top and bottom of each row of
    # cell
    ϕ1 = deg2rad.(latitudes_ranges[1:(end - 1)])
    ϕ2 = deg2rad.(latitudes_ranges[2:end])
    # The difference between the sin of each is what we want to get the area
    Δ = abs.(sin.(ϕ1) .- sin.(ϕ2))
    A = 2π * (R^2.0) .* Δ
    cell_surface = A ./ cells_per_ribbon
    # We then reshape everything to a grid
    surface_grid = reshape(repeat(cell_surface, size(layer, 2)), size(layer))
    # And we return based on the actual type of the input
    S = similar(layer, eltype(surface_grid))
    S.grid .= surface_grid
    return S
end

@testitem "We can get the area of cells for a layer in WGS84" begin
    rawlayer = SimpleSDMLayers.__demodata(; reduced=true)
    layer = interpolate(rawlayer; dest="+proj=longlat +datum=WGS84 +no_defs")
    sarea = cellarea(layer)
    @test allequal(sarea.grid[200,:])
end