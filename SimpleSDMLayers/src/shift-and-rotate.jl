function _shift_coordinates(points::Vector{Tuple{Float64, Float64}}, angle_lon::Float64, angle_lat::Float64)
    shifted_points = Vector{Tuple{Float64, Float64}}()
    rotation_angle_lon = deg2rad(angle_lon)
    rotation_angle_lat = deg2rad(angle_lat)

    for (lon, lat) in points
        # Convert longitude and latitude to radians
        lon_rad = deg2rad(lon)
        lat_rad = deg2rad(lat)

        # Perform rotation using spherical trigonometry
        new_lon_rad = lon_rad + rotation_angle_lon * cos(lat_rad)
        new_lat_rad = lat_rad + rotation_angle_lat * cos(lon_rad)

        # Convert back to degrees
        new_lon = rad2deg(new_lon_rad)
        new_lat = rad2deg(new_lat_rad)

        # Ensure longitude stays within [-180, 180]
        new_lon = mod(new_lon + 180, 360) - 180

        # Ensure latitude stays within [-90, 90]
        new_lat = max(min(new_lat, 90), -90)

        # Append the rotated point to the result
        push!(shifted_points, (new_lon, new_lat))
    end

    return shifted_points
end

function _rotate_coordinates(points::Vector{Tuple{Float64, Float64}}, angle::Float64)
    # Compute the centroid of the points
    centroid_lon = mean(map(p -> p[1], points))
    centroid_lat = mean(map(p -> p[2], points))

    # Convert centroid to radians
    centroid_lon_rad = deg2rad(centroid_lon)
    centroid_lat_rad = deg2rad(centroid_lat)

    # Convert angle to radians
    rotation_angle = deg2rad(angle)

    rotated_points = Vector{Tuple{Float64, Float64}}()

    for (lon, lat) in points
        # Convert point to radians
        lon_rad = deg2rad(lon)
        lat_rad = deg2rad(lat)

        # Convert to Cartesian coordinates
        x = cos(lat_rad) * cos(lon_rad)
        y = cos(lat_rad) * sin(lon_rad)
        z = sin(lat_rad)

        # Compute centroid in Cartesian coordinates
        cx = cos(centroid_lat_rad) * cos(centroid_lon_rad)
        cy = cos(centroid_lat_rad) * sin(centroid_lon_rad)
        cz = sin(centroid_lat_rad)

        # Rotate around the centroid using Rodrigues' rotation formula
        kx, ky, kz = cx, cy, cz
        dot_product = x * kx + y * ky + z * kz
        new_x = x * cos(rotation_angle) + (ky * z - kz * y) * sin(rotation_angle) + kx * dot_product * (1 - cos(rotation_angle))
        new_y = y * cos(rotation_angle) + (kz * x - kx * z) * sin(rotation_angle) + ky * dot_product * (1 - cos(rotation_angle))
        new_z = z * cos(rotation_angle) + (kx * y - ky * x) * sin(rotation_angle) + kz * dot_product * (1 - cos(rotation_angle))

        # Convert back to spherical coordinates
        new_lon_rad = atan(new_y, new_x)
        new_lat_rad = atan(new_z, sqrt(new_x^2 + new_y^2))

        # Convert back to degrees
        new_lon = rad2deg(new_lon_rad)
        new_lat = rad2deg(new_lat_rad)

        # Ensure longitude stays within [-180, 180]
        new_lon = mod(new_lon + 180, 360) - 180

        # Ensure latitude stays within [-90, 90]
        new_lat = max(min(new_lat, 90), -90)

        # Append the rotated point to the result
        push!(rotated_points, (new_lon, new_lat))
    end

    return rotated_points
end
