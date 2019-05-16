function worldclim(layers::Vector{Int64}; resolution::AbstractString="10", path::AbstractString="assets")
    @assert all(1 .≤ layers .≤ 19)
    isdir(path) || mkdir(path)
    @assert resolution ∈ ["2.5", "5", "10"]
    codes = [lpad(code, 2, "0") for code in layers]
    paths = [joinpath(path, "wc2.0_bio_$(resolution)m_$(code).tif") for code in codes]

    #=
    Download the files if they are missing. In order of preference, this function
    will extract from the zip file if found, and download the zip file if not.
    =#
    missing_files = !all(isfile.(paths))
    zip_file = "wc2.0_bio$(resolution)m.zip"
    missing_zip_file = !isfile(joinpath(path, zip_file))
    if missing_files
        if missing_zip_file
            @info "Downloading $(zip_file)"
            download("http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_$(resolution)m_bio.zip", joinpath(pwd(), path, zip_file))
        end
        zf = ZipFile.Reader(joinpath(pwd(), path, zip_file))
        for rf in zf.files
            if joinpath(path, rf.name) in paths
                if !isfile(joinpath(path, rf.name))
                    @info "Downloading layer $(rf.name)"
                    write(joinpath(path, rf.name), read(rf))
                end
            end
        end
    end

    data_layers = geotiff.(paths)

    return SimpleSDMPredictor.(data_layers, -180.0, 180.0, -90.0, 90.0)

end

worldclim(layer::Int64; x...) = worldclim([layer]; x...)[1]
