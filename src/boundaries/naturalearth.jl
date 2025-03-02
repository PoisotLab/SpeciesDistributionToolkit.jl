function __ne_url(filename)
    root = "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/refs/heads/master/geojson/"
    return root * filename
end

function __ne_file(filename)
    json_path = joinpath(SimpleSDMDatasets._LAYER_PATH, "NaturalEarth")
    if !ispath(json_path)
        mkpath(json_path)
    end
    if !isfile(joinpath(json_path, filename))
        Downloads.download(__ne_url(filename), joinpath(json_path, filename))
    end
    return GeoJSON.read(joinpath(json_path, filename))
end

function naturalearth(country::String; resolution=110)
    @assert resolution in [10, 50, 110]
    @assert length(country) == 3
    json_file = "ne_$(resolution)m_admin_0_countries.geojson"
    limits = __ne_file(json_file)
    idx = findfirst(country .== limits.ISO_A3_EH)
    return limits[idx]
end

function naturalearth(country::String, region::String; resolution=110)
    @assert resolution in [10, 50, 110]
    @assert length(country) == 3
    json_file = "ne_$(resolution)m_admin_1_states_provinces.geojson"
    limits = __ne_file(json_file)
    # Limit to country
    limits = limits[findall(limits.adm0_a3 .== country)]
    # Find place
    idx = findfirst(r -> r.region == region, limits)
    return limits[idx]
end
