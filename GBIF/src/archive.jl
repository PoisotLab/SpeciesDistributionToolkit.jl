using DataFrames: DataFrame


"""
    gbifarchive_io(path::AbstractString) -> IOBuffer

Open a compressed GBIF occurrence archive and return an `IOBuffer` for the
occurrence table.

Supports both the GBIF "Simple" archive format and the "Darwin Core"
(DwC) archive download layout.

# Arguments
- `path`: Filesystem path to a `.zip` GBIF archive file.

# Returns
- `IOBuffer`: In-memory byte stream of the selected occurrence table.

# See also
[`gbifarchive_csv`](@ref), [`gbifarchive_df`](@ref), Darwin Core: <https://dwc.tdwg.org/>
"""
function gbifarchive_io(path::AbstractString)::IOBuffer
    return (
            path
            |> read
            |> ZipReader
            |> za -> (za, "occurrence.txt" in  zip_names(za) ? "occurrence.txt" : zip_names(za)[1])
            |> za_entry -> zip_readentry(za_entry[1], za_entry[2])
            |> source -> IOBuffer(source)
    )
end

"""
    gbifarchive_csv(path::AbstractString) -> CSV.File

Parse a GBIF occurrence archive at `path` into a `CSV.File`.

# Arguments
- `path`: Path to a GBIF `.zip` archive.

# Returns
- `CSV.File`: Streamable, table-compatible view of the occurrence data.

# See also
- [`gbifarchive_df`](@ref) for an eager `DataFrame`.
"""
function gbifarchive_csv(path::AbstractString)::CSV.File
    return (
        path
        |> gbifarchive_io
        |> source_io -> CSV.File(source_io; delim = '\t')
    )
end

"""
    gbifarchive_df(path::AbstractString) -> DataFrame

Read a GBIF occurrence archive at `path` into a `DataFrame`.

# Arguments
- `path`: Path to a GBIF `.zip` archive.

# Returns
- `DataFrame`: Eager tabular data of the occurrences.

# See also
- [`gbifarchive_csv`](@ref)
"""
function gbifarchive_df(path::AbstractString)::DataFrame
    path |> gbifarchive_csv |> DataFrame
end

"""
    gbifarchive_sdmt(path::AbstractString)
        -> OccurrencesInterface.Occurrences

Convert a GBIF occurrence archive into `OccurrencesInterface.Occurrences`
records suitable for use with
[SpeciesDistributionToolkit.jl](https://github.com/EcoJulia/SpeciesDistributionToolkit.jl).

# Arguments
- `path`: Path to a GBIF `.zip` archive.

# Returns
- `OccurrencesInterface.Occurrences`: A collection of occurrence records as
  materialized by `SpeciesDistributionToolkit.GBIF._materialize`.

# See also
- SpeciesDistributionToolkit.jl: <https://github.com/EcoJulia/SpeciesDistributionToolkit.jl>
"""
function gbifarchive_sdmt(path::AbstractString)::OccurrencesInterface.Occurrences
    return (
        path
        |> gbifarchive_csv
        |> csv -> SpeciesDistributionToolkit.GBIF._materialize.(OccurrencesInterface.Occurrence, csv)
        |> OccurrencesInterface.Occurrences
    )
end