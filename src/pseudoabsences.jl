"""
    PseudoAbsenceGenerator

Abstract type to which all of the pseudo-absences generator types belong. Note
that the pseudo-absence types are *singleton* types, and the arguments are
passed when generating the pseudo-absence mask.
"""
abstract type PseudoAbsenceGenerator end

"""
    WithinRadius

Generates pseudo-absences within a set radius (in kilometers) around each
occurrence
"""
struct WithinRadius <: PseudoAbsenceGenerator
end

"""
    SurfaceRangeEnvelope

Generates pseudo-absences at random within the geographic range covered by
actual occurrences
"""
struct SurfaceRangeEnvelope <: PseudoAbsenceGenerator
end

"""
    RandomSelection

Generates pseudo-absences at random within the layer
"""
struct RandomSelection <: PseudoAbsenceGenerator
end

"""
    _random_point(ref, d; R = 6371.0)

This function is used _internally_ to create a random point located within a distance `d` of point `ref`, assuming that the radius of the Earth is `R`. All it does is to generate a random angle in degrees, and the using the `_known_point` method to generate the new point.
"""
function _random_point(ref, d; R = 6371.0)
    α = deg2rad(rand() * 360.0)
    return _known_point(ref, d, α; R = R)
end

"""
    _known_point(ref, d, α; R = 6371.0)

This function will generate a new point set at a distance `d` and angle `α` from the `ref` point, assuming the radius of the Earth is `R`.
"""
function _known_point(ref, d, α; R = 6371.0)
    # Convert the coordinates from degrees to radians
    λ, φ = deg2rad.(ref)
    # Get the angular distance
    δ = d / R
    # Get the new latitude
    φ2 = asin(sin(φ) * cos(δ) + cos(φ) * sin(δ) * cos(α))
    # Get the new longitude
    λ2 = λ + atan(sin(α) * sin(δ) * cos(φ), cos(δ) - sin(φ) * sin(φ2))
    # Return the coordinates in degree
    return rad2deg.((λ2, φ2))
end

function _layer_works_for_pseudoabsence(layer::T) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    n_occ = sum(layer)
    return iszero(n_occ) && throw(ArgumentError("The presences layer is empty"))
end

function pseudoabsencemask(
    ::Type{WithinRadius},
    presences::T;
    distance::Number = 100.0,
) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)

    function _check_bounds(template, i)
        sz = size(template)
        i[1] <= 0 && return false
        i[2] <= 0 && return false
        i[1] > sz[1] && return false
        i[2] > sz[2] && return false
        return true
    end

    presence_only = mask(presences, presences)
    presence_idx = findall(x->x==1,presence_only.grid)

    background = similar(presences, Bool)
    background.grid .= true

    y, x = size(presences) # axes returned by size are flipped 
    bbox = boundingbox(presences)
    Δx = (bbox[:right] - bbox[:left])/ x   # how much a raster cell is in long
    Δy = (bbox[:top] - bbox[:bottom])/ y   # how much a raster cell is in lat
    
    lon = zeros(Float64, 2)
    lat = zeros(Float64, 2)
    for (i, angl) in enumerate((0:1) / 4)
        α = deg2rad(360.0angl)
        lon[i], lat[i] = SpeciesDistributionToolkit._known_point([0.0, 0.0], distance, α)
    end

    # total offset from origin in each direction 
    max_cells_x, max_cells_y =  Int32.(floor.([lon[2] / Δx, lat[1] / Δy])) 

    radius_mask = OffsetArrays.OffsetArray(ones(Bool, 2max_cells_x+1, 2max_cells_y+1), -max_cells_x:max_cells_x, -max_cells_y:max_cells_y) 

    for i in CartesianIndices(radius_mask)
        long_offset, lat_offset = abs.([i[1], i[2]]) .* [Δx, Δy]
        total_dist = sqrt(long_offset^2 + lat_offset^2)
        radius_mask[i] = total_dist <= max(lon[2], lat[1])  # there consequence of using min here are fewer cells are PAs, so why not take the upper bound
    end

    # Mask radius around each presence point 
    for occ_idx in presence_idx
        offsets = CartesianIndices((-max_cells_x:max_cells_x, -max_cells_y:max_cells_y))
        within_radius_idx = offsets .+ occ_idx

        # very clear var names here:
        for (i, cartesian_idx) in enumerate(within_radius_idx)
            if _check_bounds(background, cartesian_idx) && radius_mask[offsets[i]]
                background[cartesian_idx] = false
            end 
        end 
    end
    
    return background
end

"""
    pseudoabsencemask(::Type{RandomSelection}, presence::T) where {T <: SimpleSDMLayer}

Generates a mask for pseudo-absences using the random selection method. Candidate
cells for the pseudo-absence mask are (i) within the bounding box of the _layer_
(use `SurfaceRangeEnvelope` to use the presences bounding box), and (ii) valued in the
layer.
"""
function pseudoabsencemask(
    ::Type{RandomSelection},
    presences::T) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = replace(similar(presences, Bool), false => true)
    for occupied_cell in keys(presence_only)
        background[occupied_cell] = false
    end
    return background
end

"""
    pseudoabsencemask( ::Type{SurfaceRangeEnvelope}, presences::T) where {T <: SimpleSDMLayer}

Generates a mask from which pseudo-absences can be drawn, by picking cells that
are (i) within the bounding box of occurrences, (ii) valued in the layer, and
(iii) not already occupied by an occurrence
"""
function pseudoabsencemask(
    ::Type{SurfaceRangeEnvelope},
    presences::T) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = similar(presences, Bool)
    lon = extrema([k[1] for k in keys(presence_only)])
    lat = extrema([k[2] for k in keys(presence_only)])
    for occupied_cell in keys(presences)
        if lon[1] <= occupied_cell[1] <= lon[2]
            if lat[1] <= occupied_cell[2] <= lat[2]
                if ~(presences[occupied_cell])
                    background[occupied_cell] = true
                end
            end
        end
    end
    return background
end

"""
    sample(layer::T, n::Integer = 1; kwargs...) where {T <: SimpleSDMLayer}

Sample a series of background points from a Boolean layer. The `kwargs`
arguments are passed to `StatsBase.sample`. This method returns a Boolean layer
where the values of `true` correspond to a background point.
"""
function sample(layer::T, n::Integer = 1; kwargs...) where {T <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    pseudoabs = similar(layer, Bool)
    for k in StatsBase.sample(keys(replace(layer, false => nothing)), n; kwargs...)
        pseudoabs[k] = true
    end
    return pseudoabs
end

"""
    sample( layer::T, weights::T2, n::Integer = 1; kwargs..., ) where {T <: SimpleSDMLayer, T2 <: SimpleSDMLayer}

Sample a series of background points from a Boolean layer, where each point has
a probability of being included in the background given by the second layer.
This methods works like (and is, in fact, a wrapper around) `StatsBase.sample`,
where the cell values in the weight layers are transformed into weights.
"""
function sample(
    layer::T,
    weights::T2,
    n::Integer = 1;
    kwargs...,
) where {T <: SimpleSDMLayer, T2 <: SimpleSDMLayer}
    @assert SimpleSDMLayers._inner_type(layer) <: Bool
    @assert SimpleSDMLayers._inner_type(weights) <: Number
    pseudoabs = similar(layer, Bool)
    void = replace(layer, false => nothing)
    vals = weights[keys(void)]
    for k in StatsBase.sample(keys(void), StatsBase.Weights(vals), n; kwargs...)
        pseudoabs[k] = true
    end
    return pseudoabs
end
