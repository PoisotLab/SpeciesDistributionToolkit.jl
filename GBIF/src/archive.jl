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
    zip_archive = ZipArchives.ZipReader(read(path))
    filenames = ZipArchives.zip_names(zip_archive)
    entry_name = "occurrence.txt" in filenames ? "occurrence.txt" : filenames[1]
    entry = ZipArchives.zip_readentry(zip_archive, entry_name)
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
    localarchive(path::AbstractString, ::Type)

Convert a GBIF occurrence archive into an object. This function is equivalent to
`GBIF.download` but works from a _local_ copy of any archive. The second
argument is a type, which defaults to `Occurrences`. Currently, `CSV.File` is
also supported, to read into a `DataFrame`.
"""
function localarchive(path::AbstractString, T::Type=OccurrencesInterface.Occurrences)
    csv = _csv_from_archive(path)
    records = GBIF._materialize(T, csv)
    return records
end