function _get_gadm_file(code, level)
    # Prepare to store the data
    gadm_root = joinpath(SimpleSDMDatasets._LAYER_PATH, "GADM", code)
    if !ispath(gadm_root)
        mkpath(gadm_root)
    end
    # Get the URL for the file
    fname = "gadm41_$(code)_$(level).json"
    if level > 0
        fname *= ".zip"
    end
    url = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/$(fname)"
    # Download the file
    if ~isfile(joinpath(gadm_root, fname))
        try
            Downloads.download(url, joinpath(gadm_root, fname))
        catch
            return nothing
        end
    end
    # Read the file in GeoJSON
    gadm_file = joinpath(gadm_root, fname)
    if level > 0
        gadm_zip = ZipFile.Reader(gadm_file)
        for f in gadm_zip.files
            if f.name == replace(fname, ".zip" => "")
                out = open(joinpath(gadm_root, f.name), "w")
                write(out, read(f, String))
                close(out)
            end
        end
    end
    # Return
    return GeoJSON.read(replace(gadm_file, ".zip" => ""))
end

gadm(code::String) = _get_gadm_file(code, 0)

function gadm(code::String, places::String...)
    level = length(places)
    avail = _get_gadm_file(code, level)
    position = only(
        reduce(
            intersect,
            [
                findall(
                    isequal(replace(places[i], " " => "")),
                    getproperty(avail, Symbol("NAME_$(i)")),
                )
                for
                i in 1:level
            ],
        ),
    )
    return avail.geometry[position]
end

gadmlist(code::String) = getproperty(_get_gadm_file(code, 1), :NAME_1)
gadmlist(code::String, level::Integer) =
    getproperty(_get_gadm_file(code, level), Symbol("NAME_$(level)"))
function gadmlist(code::String, places::String...)
    level = length(places) + 1
    avail = _get_gadm_file(code, level)
    position = reduce(
        intersect,
        [
            findall(
                isequal(replace(places[i], " " => "")),
                getproperty(avail, Symbol("NAME_$(i)")),
            ) for
            i in 1:(level - 1)
        ],
    )
    return getproperty(avail, Symbol("NAME_$(level)"))[position]
end

function gadm(code::String, level::Integer, places::String...)
    level = max(length(places), level)
    avail = _get_gadm_file(code, level)
    position = reduce(
        intersect,
        [
            findall(
                isequal(replace(p, " " => "")),
                getproperty(avail, Symbol("NAME_$(i)")),
            )
            for
            (i, p) in enumerate(places)
        ],
    )
    return avail.geometry[position]
end

function gadmlist(code::String, level::Integer, places::String...)
    level = max(length(places), level)
    avail = _get_gadm_file(code, level)
    position = reduce(
        intersect,
        [
            findall(
                isequal(replace(p, " " => "")),
                getproperty(avail, Symbol("NAME_$(i)")),
            )
            for
            (i, p) in enumerate(places)
        ],
    )
    return getproperty(avail, Symbol("NAME_$(level)"))[position]
end