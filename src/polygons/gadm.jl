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

"""
    gadm(code::String)

Returns the `GeoJSON` object associated to a the alpha-3 code defined by
[ISO](https://www.iso.org/obp/ui/#search/code/).
"""
gadm(code::String) = _get_gadm_file(code, 0)

"""
    gadm(code::String, places::String...)

Returns all polygons nested within an arbitrary sequence of areas according to
GADM. For example, getting all counties in Oklahoma is achieved with the
arguments `"USA", "Oklahoma"`.
"""
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

"""
    gadm(code::String, level::Integer)

Returns all areas within the top-level territory `code`, at the level `level`.
For example, getting all *départements* in France is done with the arguments
`"FRA", 2`.
"""
function gadm(code::String, level::Integer)
    avail = _get_gadm_file(code, level)
    return avail.geometry
end

"""
    gadm(code::String, level::Integer, places::String...)

Returns all areas within the `places` within a country defined by `code` at a
specific level. For example, the *districts* in the French region of Bretagne
are obtained with the arguments `"FRA", 3, "Bretagne"`.
"""
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

"""
    gadmlist(code::String)

Returns all top-level divisions of the territory defined by its `code`.
"""
gadmlist(code::String) = getproperty(_get_gadm_file(code, 1), :NAME_1)

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

"""
    gadmlist(code::String, level::Integer)

Returns all `level` divisions of the territory defined by its `code`, regardless
of which higher-level divisions they belong to.
"""
function gadmlist(code::String, level::Integer)
    avail = _get_gadm_file(code, level)
    return getproperty(avail, Symbol("NAME_$(level)"))
end

"""
    gadmlist(code::String, level::Integer, places::String...)

Returns all `level` divisions of the territory defined by its `code`, that
belong to the hierarchy defined by `places`.
"""
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