"""
    _io_from_archive(path::AbstractString)

Open a compressed GBIF occurrence archive and return an `IOBuffer` for the
occurrence table. Supports both the GBIF "Simple" archive format and the "Darwin
Core" (DwC) archive download layout.

The `path` argument points to a (`.zip`) file. This function returns an
`IOBuffer`, an in-memory byte stream of the selected occurrence table.
"""
function _io_from_archive(path::AbstractString)::IOBuffer
    if ~isfile(path)
        throw(ArgumentError("The file $path does not exist"))
    end
    zip_archive = ZipRead(read(path))
    filenames = zip_names(zip_archive)
    entry_name = "occurrence.txt" in filenames ? "occurrence.txt" : filenames[1]
    entry = zip_readentry(zip_archive, entry_name)
    return IOBuffer(entry)
end

"""
    gbifarchive_csv(path::AbstractString) -> CSV.File

Parse a GBIF occurrence archive at `path` into a `CSV.File`. Internally, this
calls `_io_from_archive` to get the occurrences table from a "Simple" or "DwC"
archive.

This output can be passed to `DataFrame` if the package is loaded by the user.
"""
function _csv_from_archive(path::AbstractString)
    content = _io_from_archive(path)
    return CSV.File(content; delim = '\t')
end

"""
    localarchive(path::AbstractString)

Convert a GBIF occurrence archive into an `Occurrences` object. This function is
equivalent to `GBIF.download` but works from a _local_ copy of any archive.
"""
function localarchive(path::AbstractString)
    csv = _csv_from_archive(path)
    records = GBIF._materialize.(OccurrencesInterface.Occurrence, csv)
    return records
end