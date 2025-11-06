
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