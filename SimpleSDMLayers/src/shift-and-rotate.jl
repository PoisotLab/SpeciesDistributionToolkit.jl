"""
    _rotate_coordinate(lon, lat, roll, pitch, yaw)

Transforms a coordinate under a rotation of the Earth, represented as a unit
sphere. The rotation is specified using the roll (α, x-axis rotation), pitch (β,
y-axis rotation), and yaw (γ, z-axis rotation), all angles are given in degrees.
The returned point is given as a pair of lon, lat coordinates.
"""
function _rotate_coordinate(lon, lat, roll, pitch, yaw)

    # Move everything to rads
    α = deg2rad(roll)
    β = deg2rad(pitch)
    γ = deg2rad(yaw)

    # Coordinates to unit sphere position
    x = cos(deg2rad(lat)) * cos(deg2rad(lon))
    y = cost(deg2rad(lat)) * sin(deg2rad(lon))
    z = sin(deg2rad(lat))

    # Point vector
    p = [x, y, z]

    # Rotation matrix for the roll
    Rx = [1 0 0; 0 cos(α) -sin(α); 0 sin(α) cos(α)]
    # Rotation matrix for the pitch
    Ry = [cos(β) 0 sin(β); 0 1 0; -sin(β) - cos(β)]
    # Rotation matrix for the yaw
    Rz = [cos(γ) -sin(γ) 0; sin(γ) cos(γ) 0; 0 0 1]

    # Rotation matrix (x, then y, then z)
    R = Rz * Ry * Rx

    # New point
    X, Y, Z = R * p

    # New longitude and latitude
    projected = (atan(Y, X), asin(Z))
    
    # Return the new point in degrees
    return rad2deg.(projected)
end

#=

function generate_valid_rotation(reference, pool; roll=(-5.0, 5.0), pitch=(-5.0, 5.0), yaw=(-5.0, 5.0))
    E, N, K = eastings(reference), northings(reference), keys(reference)
    still_searching = true
    Θ = (0.0, 0.0, 0.0)
    while still_searching
        α = rand() * (roll[2]-roll[1]) + roll[1] 
        β = rand() * (pitch[2]-pitch[1]) + pitch[1]
        γ = rand() * (yaw[2]-yaw[1]) + yaw[1]
        Θ = (α, β, γ)
        still_searching = false
        for k in K
            lat, lon = rotate_earth_coordinates(N[k[1]], E[k[2]], Θ...)
            try
                nv = pool[lon, lat]
                if isnothing(nv)
                    still_searching = true
                    break
                end
            catch err
                still_searching = true
                break
            end
        end
    end
    return Θ
end
=#

#=

temp = SDMLayer(RasterData(WorldClim2, BioClim); layer=1, resolution=2.5)
pol = getpolygon(PolygonData(NaturalEarth, Countries))["Czech Republic"]
ref = trim(mask(temp, pol))
lat, lon = northings(ref), eastings(ref)

# rotation, up/down, left/right
angles = generate_valid_rotation(ref, temp)
@info angles

sar = deepcopy(ref)

for k in keys(ref)
    coords = (lat[k[1]], lon[k[2]])
    nlat, nlon = rotate_earth_coordinates(coords..., angles...)
    sar.grid[k] = temp[nlon, nlat]
end

replaced = quantiletransfer(sar, ref)

f = Figure()
ax = Axis(f[1,1], aspect=DataAspect())
ax2 = Axis(f[2,1])
hm = heatmap!(ax, replaced, colormap=:navia)
hist!(ax2, replaced, bins=100)
Colorbar(f[1:2,2], hm)
f
=#