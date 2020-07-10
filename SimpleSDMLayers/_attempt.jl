using ArchGDAL
using Plots

d = ArchGDAL.read("test/assets/wc2.1_10m_bio_3.tif")
b = ArchGDAL.getband(d,1)
px_type = ArchGDAL.pixeltype(b)

b |>
    ArchGDAL.read |>
    m -> convert(Matrix{Union{Nothing,px_type}}, m) |>
    m -> m[m.==minimum(m)] .= NaN |>
    rotl90 |>
    m -> heatmap(m, c=:cividis)
