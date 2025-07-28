#=
using SpeciesDistributionToolkit
const SDT = SpeciesDistributionToolkit
using CairoMakie

# Test layer
cntrs = getpolygon(PolygonData(NaturalEarth, Countries))
pol = cntrs["Italy"]
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

function _spherical_rotation(xy, degrees, axis=:z)
    # Convert degrees to radians
    θ = deg2rad(degrees)
    
    # x = cos(lat) * cos(lon)  [points toward 0°N, 0°E (Gulf of Guinea)]
    # y = cos(lat) * sin(lon)  [points toward 0°N, 90°E (Bay of Bengal)]  
    # z = sin(lat)             [points toward North Pole 90°N]
    #
    # ROTATION EFFECTS:
    # :z rotation (around North Pole axis): 
    #   - Keeps latitude CONSTANT, changes longitude
    #   - Pure east-west movement along parallels
    #   - Like spinning a globe around its axis
    #
    # :x rotation (around 0°N, 0°E axis):
    #   - Changes both lat and lon
    #   - 0°E meridian stays fixed, other meridians move
    #   - Creates north-south arc motion for most points
    #
    # :y rotation (around 0°N, 90°E axis):
    #   - Changes both lat and lon  
    #   - 90°E meridian stays fixed, other meridians move
    #   - Creates different north-south arc motion
    
    # Calculate centroid to determine rotation axis
    n = length(xy)
    cx = sum(p[1] for p in xy) / n  # centroid longitude
    cy = sum(p[2] for p in xy) / n  # centroid latitude
    
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
        if axis == :z  # Rotation around z-axis (through poles)
            x_rot = x * cos(θ) - y * sin(θ)
            y_rot = x * sin(θ) + y * cos(θ)
            z_rot = z
        elseif axis == :y  # Rotation around y-axis
            x_rot = x * cos(θ) + z * sin(θ)
            y_rot = y
            z_rot = -x * sin(θ) + z * cos(θ)
        elseif axis == :x  # Rotation around x-axis
            x_rot = x
            y_rot = y * cos(θ) - z * sin(θ)
            z_rot = y * sin(θ) + z * cos(θ)
        else
            error("Axis must be :x, :y, or :z")
        end
        
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

# Function to rotate around an arbitrary axis passing through the centroid
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
        
        # Rodrigues' rotation formula for rotation around arbitrary axis
        # R = I + sin(θ)[K] + (1-cos(θ))[K]²
        # where [K] is the skew-symmetric matrix of the rotation axis
        
        dot_product = axis_x * x + axis_y * y + axis_z * z
        
        x_rot = x * cos_θ + (axis_y * z - axis_z * y) * sin_θ + axis_x * dot_product * (1 - cos_θ)
        y_rot = y * cos_θ + (axis_z * x - axis_x * z) * sin_θ + axis_y * dot_product * (1 - cos_θ)
        z_rot = z * cos_θ + (axis_x * y - axis_y * x) * sin_θ + axis_z * dot_product * (1 - cos_θ)
        
        # Convert back to spherical coordinates
        new_lat = asin(clamp(z_rot, -1, 1))  # Clamp to handle numerical errors
        new_lon = atan(y_rot, x_rot)
        
        # Convert back to degrees
        new_lon_deg = rad2deg(new_lon)
        new_lat_deg = rad2deg(new_lat)
        
        push!(rotated, (new_lon_deg, new_lat_deg))
    end
    
    return rotated
end

# Function for complex chained rotation attempting longitude preservation
function _longitude_preservation(xy, latitude_shift_degrees)
    # APPROACH 4: Multi-step rotation chain
    # This attempts to use rotations to achieve latitude-only change
    
    # Calculate centroid for reference
    n = length(xy)
    cx = sum(p[1] for p in xy) / n
    cy = sum(p[2] for p in xy) / n
    
    # Strategy: Rotate to align with a preferred meridian, shift, then rotate back
    align_angle = -cx  # Angle to rotate to 0° longitude
    
    # Step 1: Rotate to align centroid with 0° meridian (Z-axis rotation)
    aligned = rotate_sphere(xy, align_angle, :z)
    
    # Step 2: Apply X-axis rotation (which preserves 0° meridian)
    shifted = rotate_sphere(aligned, latitude_shift_degrees, :y)
    
    # Step 3: Rotate back to original longitude position
    return rotate_sphere(shifted, -align_angle, :z)
end

shiftlatitude(angle) = (xy) -> _spherical_rotation(xy, angle, :z)
shiftlongitude(angle) = (xy) -> _longitude_preservation(xy, angle)
centroidrotation(angle) = (xy) -> _centroid_rotation(xy, angle)
shiftandrotate(lon, lat, cntr) = (xy) -> xy |> shiftlatitude(lat) |> shiftlongitude(lon) |> centroidrotation(cntr)

rangelat = LinRange(-20.0, 20.0, 40)
rangelon = LinRange(-20.0, 20.0, 40)
rangerot = LinRange(-20.0, 20.0, 200)

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

Y = deepcopy(L)
SimpleSDMLayers.burnin!(Y, [P[c...] for c in trf(lonlat(L))])
heatmap(Y)
=#