#! /usr/bin/env julia

## gbarchive
##
## - Low-level library for reading GBIF archive files.
## - Endpoint API design following: [paleobioDB](https://github.com/ropensci/paleobioDB).
## - Client code is expected to handle issues with bad, missing, malformed, invalid,
##   etc. archives.
##
## Copyright (c) 2025 Jeet Sukumaran
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.
##

using CSV
using ZipArchives: ZipReader, zip_names, zip_readentry
using DataFrames: DataFrame
using SpeciesDistributionToolkit

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

"""
    gbifarchive_locations(path::AbstractString)
        -> Vector{Tuple{Float64, Float64}}

    gbifarchive_locations(csv_file::CSV.File)
        -> Vector{Tuple{Float64, Float64}}

Extract `(lon, lat)` coordinate pairs from a GBIF archive or from a `CSV.File`.

# Arguments
- `path`: Path to a GBIF `.zip` archive; the occurrence table is parsed internally.
- `csv_file`: A `CSV.File` already pointing at occurrence rows.

# Returns
- `Vector{Tuple{Float64,Float64}}`: Longitude–latitude pairs.

# Interoperability
The returned vector is a drop-in replacement for a table of coordinates accepted
by [SpeciesDistributionModels.jl](https://github.com/tiemvanderdeure/SpeciesDistributionModels.jl).
"""
function gbifarchive_locations(path::AbstractString)::Vector{Tuple{Float64, Float64}}
    path |> gbifarchive_csv |> gbifarchive_locations
end

function gbifarchive_locations(csv_file::CSV.File)::Vector{Tuple{Float64, Float64}}
    map(csv_file) do csv_row
        return (csv_row.decimalLongitude, csv_row.decimalLatitude)
    end
end
