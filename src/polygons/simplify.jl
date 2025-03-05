function _heal_polygon!(pol)
    f = first(pol)
    if pol[end] != f
        push!(pol, f)
    end
    return pol
end

function VisvalingamWhyatt!(points, tolerance, minpoints)
    if length(points) <= minpoints
        return points
    end
    _heal_polygon!(points)
    p = copy(points)
    A = zeros(length(p))
    # Make sure that we pad the array with the correct first and last values
    f, l = first(p), last(p)
    push!(p, f)
    pushfirst!(p, l)
    # We now iterate over all points, using the CORRECT index in the original set of points
    for n in axes(points, 1)
        i = n+1
        S = p[i-1][1]*p[i][2] + p[i][1]*p[i+1][2] + p[i+1][1]*p[i-1][2]-p[i-1][1]*p[i+1][2]-p[i][1]*p[i-1][2]-p[i+1][1]*p[i][2]
        A[n] = abs(S)/2
    end
    if minimum(A) <= tolerance
        to_delete = findall(A .== minimum(A))
        if (length(points) - length(to_delete)) <= minpoints
            return points
        end
        deleteat!(points, to_delete)
        return VisvalingamWhyatt!(points, tolerance, minpoints)
    end
    _heal_polygon!(points)
    return points
end

"""
    simplify!(mpol::GeoJSON.MultiPolygon; tolerance=1e-5, minpoints=100)

Modifies the polygon (currently using the Visvalingam-Whyatt algorithm) to
reduce its complexity. The tolerance and minimum number of points can be
changed.
"""
function simplify!(mpol::GeoJSON.MultiPolygon; tolerance=1e-5, minpoints=100)
    for i in Base.OneTo(length(mpol))
        for j in Base.OneTo(length(mpol[i]))
            SpeciesDistributionToolkit.VisvalingamWhyatt!(mpol[i][j], tolerance, minpoints)
        end
    end
    return mpol
end

"""
    simplify(pol, args...; kwargs...)

Non-mutating version of `simplify!`.
"""
function simplify(pol, args...; kwargs...)
    cpol = deepcopy(pol)
    return simplify!(cpol, args...; kwargs...)
end

@testitem "We can simplify a polygon" begin
    POL = SpeciesDistributionToolkit.openstreetmap("Paris")
    MPOL = SpeciesDistributionToolkit.simplify(POL)
    @test typeof(MPOL) == typeof(POL)
    @test length(POL[1][1]) >= length(MPOL[1][1])
end

@testitem "We can mask with a simplified polygon" begin
    POL = SpeciesDistributionToolkit.openstreetmap("Paris")
    L = SDMLayer(RasterData(CHELSA1, MinimumTemperature); SpeciesDistributionToolkit.boundingbox(POL; padding=1.0)...)
    Lc = count(L)
    SpeciesDistributionToolkit.simplify!(POL)
    mask!(L, POL)
    @test typeof(L) <: SDMLayer
    @test count(L) <= Lc
end