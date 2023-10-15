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
    DistanceToEvent

Generates a weight for the pseudo-absences based on the distance to cells with a `true` value
"""
struct DistanceToEvent <: PseudoAbsenceGenerator
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

    
    y, x = size(presences) # axes returned by size are flipped 
    bbox = boundingbox(presences)
    Δx = (bbox[:right] - bbox[:left])/ x   # how much a raster cell is in long
    Δy = (bbox[:top] - bbox[:bottom])/ y   # how much a raster cell is in lat
    
    # It's reasonable to use the centroid of the raster as a basis and use the
    # same sliding mask for each point.
    centroid = [0.5(bbox[:right]+bbox[:left]), 0.5(bbox[:bottom]+bbox[:top])]

    # However, if the extent is large enough, this assumption might break down
    # and the size of the sliding window should be calculated for each
    # occurrence (or for some subbdivision of the raster into subsections).

    # The slowest (but most accurrate) version would create an offset mask for
    # each occurrence. This is still likely faster than the current version
    # method of filtering coordinates, but may be significantly slower than the
    # simpler methods.  

    _, lat = SpeciesDistributionToolkit._known_point(centroid, distance, 0)
    lon, _ = SpeciesDistributionToolkit._known_point(centroid, distance, π/2)

    # magnitude of the maximum offset in lon/lat from raster centroid in each direction 
    max_offset_x, max_offset_y =  Int32.(floor.([(lon-centroid[1]) / Δx, (lat-centroid[2]) / Δy])) 

    radius_mask = OffsetArrays.OffsetArray(
        ones(Bool, 2max_offset_x+1, 2max_offset_y+1), 
        -max_offset_x:max_offset_x, 
        -max_offset_y:max_offset_y
    ) 
    for i in CartesianIndices(radius_mask)
        long_offset, lat_offset = abs.([i[1], i[2]]) .* [Δx, Δy]
        total_dist = sqrt(long_offset^2 + lat_offset^2)
        radius_mask[i] = total_dist <= min(lon-centroid[1], lat-centroid[2])  
    end

    # Mask radius around each presence point 
    offsets = CartesianIndices((-max_offset_x:max_offset_x, -max_offset_y:max_offset_y))

    # 3 states 
    # State 1: unseen
    # State 2: seen, still a candidate bg point
    # State 3: seen, no longer a cnadidate bg point
    UNSEEN, CANDIDATE, UNAVAILABLE = 1, 2, 3 

    background = similar(presences, Int32)
    background.grid[findall(!isnothing, background.grid)] .= UNSEEN

    for occ_idx in presence_idx
        within_radius_idx = offsets .+ occ_idx

        for (i, cartesian_idx) in enumerate(within_radius_idx)
            if _check_bounds(background, cartesian_idx) && !isnothing(background.grid[cartesian_idx])
                if background.grid[cartesian_idx] != UNAVAILABLE && !radius_mask[offsets[i]] 
                    background.grid[cartesian_idx] = CANDIDATE
                else
                    background.grid[cartesian_idx] = UNAVAILABLE
                end 
            end
        end 
    end
    
    background.grid[findall(isequal(CANDIDATE), background.grid)] .= true
    background.grid[findall(isequal(UNAVAILABLE), background.grid)] .= false

    return convert(Bool, background)
end

"""
    pseudoabsencemask(::Type{RandomSelection}, presence::T) where {T <: SimpleSDMLayer}

Generates a mask for pseudo-absences using the random selection method. Candidate
cells for the pseudo-absence mask are (i) within the bounding box of the _layer_
(use `SurfaceRangeEnvelope` to use the presences bounding box), and (ii) valued in the
layer.
"""
function pseudoabsencemask(::Type{RandomSelection}, presences::T) where {T <: SimpleSDMLayer}
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
function pseudoabsencemask(::Type{SurfaceRangeEnvelope}, presences::T) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    presence_only = mask(presences, presences)
    background = replace(similar(presences, Bool), false => true)
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
    pseudoabsencemask(::Type{DistanceToEvent}, presence::T; f=minimum) where {T <: SimpleSDMLayer}

Generates a mask for pseudo-absences using the distance to event method.
Candidate cells are weighted according to their distance to a known observation,
with far away places being more likely. Depending on the distribution of
distances, it may be a very good idea to flatten this layer using `log` or an
exponent. The `f` function is used to determine which distance is reported
(minimum by default, can also be mean or median).
"""
function pseudoabsencemask(::Type{DistanceToEvent}, presences::T; f=minimum) where {T <: SimpleSDMLayer}
    _layer_works_for_pseudoabsence(presences)
    background = similar(presences, Float64)
    presence_only = mask(presences, presences)
    d = SpeciesDistributionToolkit.Fauxcurrences._distancefunction

    points = keys(presence_only)

    for k in keys(background)    
        background[k] = f([d(k, ko) for ko in points])
    end
    
    return background
end

"""
    backgroundpoints(layer::T, n::Int; replace::Bool=false, kwargs...) where {T <: SimpleSDMLayer}

Generates background points based on a layer that gives either the location of
possible points (`Bool`) or the weight of each cell in the final sample
(`Number`). Note that the default value is to draw without replacement, but this
can be changed using `replace=true`. The additional keywors arguments are passed
to `StatsBase.sample`, which is used internally.
"""
function backgroundpoints(layer::T, n::Int; replace::Bool=false, kwargs...) where {T <: SimpleSDMLayer}
    background = similar(layer, Bool)
    selected_points = StatsBase.sample(keys(layer), StatsBase.Weights(values(layer)), n; replace=replace, kwargs...)
    for sp in selected_points
        background[sp] = true
    end
    return background
end
