#=
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# Test layer
cntrs = getpolygon(PolygonData(NaturalEarth, Countries))
pol = cntrs["Kenya"]
P = SDMLayer(RasterData(WorldClim2, BioClim); resolution=2.5)
L = SDMLayer(RasterData(WorldClim2, BioClim); resolution=2.5, SDT.boundingbox(pol)...)
mask!(L, pol)

# Check the data
heatmap(L)

# Step 1 - get the coordinates
function lonlat(L::SDMLayer)
    E, N, K = eastings(L), northings(L), keys(L)
    xy = [(E[k[2]], N[k[1]]) for k in K]
    return xy
end

# Step 2 - plot the coordinates
scatter(lonlat(L))

"""
    _rotation_z(x, y, z, θ)

Rotation around the polar axis -- latitude is constant but longitude changes
"""
function _rotation_z(x, y, z, θ)
    x_rot = x * cos(θ) - y * sin(θ)
    y_rot = x * sin(θ) + y * cos(θ)
    z_rot = z
    return (x_rot, y_rot, z_rot)
end

"""
    _rotation_y(x, y, z, θ)

Rotation along the axis ending at the Bay of Bengal
"""
function _rotation_y(x, y, z, θ)
    x_rot = x * cos(θ) + z * sin(θ)
    y_rot = y
    z_rot = -x * sin(θ) + z * cos(θ)
    return (x_rot, y_rot, z_rot)
end

"""
    _rotation_x(x, y, z, θ)

Rotation along the axis ending at the Bay of Guinea
"""
function _rotation_x(x, y, z, θ)
    x_rot = x
    y_rot = y * cos(θ) - z * sin(θ)
    z_rot = y * sin(θ) + z * cos(θ)
    return (x_rot, y_rot, z_rot)
end

"""
    _spherical_rotation(xy, degrees, axis=1)

Rotation of the Earth alongside three axes, by a given angle in degrees.

Axis 1 - x rotation - rotates around the axis ending in the Bay of Guinea

Axis 2 - y rotation - rotates around the axis ending in the Gulf of Bengal

Axis 3 - z rotation - rotates around the axis ending at the North Pole
"""
function _spherical_rotation(xy, degrees, axis=1)
    # Convert degrees to radians
    θ = deg2rad(degrees)

    # Calculate centroid to determine rotation axis
    n = length(xy)
    cx = sum(p[1] for p in xy) / n  # centroid longitude
    cy = sum(p[2] for p in xy) / n  # centroid latitude

    # Rotation function
    rf = [_rotation_x, _rotation_y, _rotation_z][axis]

    rotated = []

    for (lon, lat) in xy
        # Convert spherical coordinates (lon, lat) to Cartesian (x, y, z)
        # Assuming unit sphere (radius = 1)
        lon_rad = deg2rad(lon)
        lat_rad = deg2rad(lat)

        x = cos(lat_rad) * cos(lon_rad)
        y = cos(lat_rad) * sin(lon_rad)
        z = sin(lat_rad)

        # Apply 3D rotation matrix based on specified axis
        x_rot, y_rot, z_rot = rf(x, y, z, θ)

        # Convert back to spherical coordinates
        new_lat = asin(z_rot)
        new_lon = atan(y_rot, x_rot)

        # Convert back to degrees
        new_lon_deg = rad2deg(new_lon)
        new_lat_deg = rad2deg(new_lat)

        push!(rotated, (new_lon_deg, new_lat_deg))
    end

    return rotated
end

"""
    _centroid_rotation(xy, degrees)

Rotates a group of points around their centroid by an angle given in degrees
"""
function _centroid_rotation(xy, degrees)
    # Calculate centroid
    n = length(xy)
    cx = sum(p[1] for p in xy) / n  # centroid longitude
    cy = sum(p[2] for p in xy) / n  # centroid latitude

    # Convert centroid to Cartesian coordinates for rotation axis
    cx_rad = deg2rad(cx)
    cy_rad = deg2rad(cy)

    # The rotation axis is the vector from Earth's center through the centroid
    axis_x = cos(cy_rad) * cos(cx_rad)
    axis_y = cos(cy_rad) * sin(cx_rad)
    axis_z = sin(cy_rad)

    θ = deg2rad(degrees)
    cos_θ = cos(θ)
    sin_θ = sin(θ)

    rotated = []

    for (lon, lat) in xy
        # Convert to Cartesian
        lon_rad = deg2rad(lon)
        lat_rad = deg2rad(lat)

        x = cos(lat_rad) * cos(lon_rad)
        y = cos(lat_rad) * sin(lon_rad)
        z = sin(lat_rad)

        # Rodrigues' rotation formula
        dot_product = axis_x * x + axis_y * y + axis_z * z

        x_rot = x * cos_θ + (axis_y * z - axis_z * y) * sin_θ + axis_x * dot_product * (1 - cos_θ)
        y_rot = y * cos_θ + (axis_z * x - axis_x * z) * sin_θ + axis_y * dot_product * (1 - cos_θ)
        z_rot = z * cos_θ + (axis_x * y - axis_y * x) * sin_θ + axis_z * dot_product * (1 - cos_θ)

        # Back to spherical coordinates
        new_lat = asin(clamp(z_rot, -1, 1))  # Clamp to handle numerical errors
        new_lon = atan(y_rot, x_rot)

        # Back to degrees
        new_lon_deg = rad2deg(new_lon)
        new_lat_deg = rad2deg(new_lat)

        push!(rotated, (new_lon_deg, new_lat_deg))
    end

    return rotated
end

function _rotate_latitudes(xy, degrees)

    # Calculate centroid for reference
    n = length(xy)
    cx = sum(p[1] for p in xy) / n
    cy = sum(p[2] for p in xy) / n

    align_angle = -cx  # Angle to rotate to 0° longitude

    aligned = _spherical_rotation(xy, align_angle, 3)
    shifted = _spherical_rotation(aligned, degrees, 2)
    return _spherical_rotation(shifted, -align_angle, 3)
end

shiftlongitudes(angle) = (xy) -> _spherical_rotation(xy, angle, 3)
shiftlatitudes(angle) = (xy) -> _rotate_latitudes(xy, -angle)
localrotation(angle) = (xy) -> _centroid_rotation(xy, angle)
shiftandrotate(longitude, latitude, rotation) = (xy) -> xy |> shiftlatitudes(latitude) |> shiftlongitudes(longitude) |> localrotation(rotation)

rangelat = LinRange(-10.0, 10.0, 40)
rangelon = LinRange(-10.0, 10.0, 40)
rangerot = LinRange(-45.0, 45.0, 200)

r = (rand(rangelat), rand(rangelon), rand(rangerot))
searching = true
while searching
    r = (rand(rangelat), rand(rangelon), rand(rangerot))
    trf = shiftandrotate(r...)
    u = [P[c...] for c in trf(lonlat(L))]
    if !any(isnothing, u)
        searching = false
    end
end

@info r
trf = shiftandrotate(r...)

f = Figure()
ax = Axis(f[1,1]; aspect=DataAspect())

heatmap!(ax, P)
scatter!(ax, lonlat(L))
scatter!(ax, trf(lonlat(L)))
xlims!(ax, extrema(first.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))
ylims!(ax, extrema(last.(vcat(lonlat(L), trf(lonlat(L))))) .+ (-1, 1))

Y = deepcopy(L)
SimpleSDMLayers.burnin!(Y, [P[c...] for c in trf(lonlat(L))])
ax2 = Axis(f[1,2]; aspect=DataAspect())
heatmap!(ax2, Y)

current_figure()
=#