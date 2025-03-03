function VisvalingamWhyatt!(points, tolerance, minpoints)
    if length(points) <= minpoints
        return points
    end
    p = copy(points)
    A = zeros(length(p))
    push!(p, first(p))
    pushfirst!(p, last(p))
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