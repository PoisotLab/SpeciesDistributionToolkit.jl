"""
    lonlat(L::SDMLayer)

Returns a vector of longitudes and latitudes for a layer. This will handle the
CRS of the layer correctly. Note that only the positions that are valued (_i.e._
using `keys`) will be returned. The values are given in an order suitable for
use in `burnin!`.
"""
function lonlat(L::SDMLayer)
    E, N, K = eastings(L), northings(L), keys(L)
    prj = SimpleSDMLayers.Proj.Transformation(L.crs, "+proj=longlat +datum=WGS84 +no_defs"; always_xy=true)
    xy = [prj(E[k[2]], N[k[1]]) for k in K]    
    return xy
end

roll(angle) = (xy) -> _spherical_rotation(xy, angle, 1)
pitch(angle) = (xy) -> _spherical_rotation(xy, angle, 2)
yaw(angle) = (xy) -> _spherical_rotation(xy, angle, 3)

"""
    shiftlongitudes(angle)

Shifts the longitudes of a group of points by performing a rotation alonside the
yaw axis (going through the Nort pole). This preserves the latitudes of all
points exactly and does not deform the shape.
"""
shiftlongitudes(angle) = (xy) -> _spherical_rotation(xy, angle, 3)

"""
    shiftlatitudes(angle)
    
Returns a function to move coordinates up or down in latitudes by a given angle
in degree. Note that this accounts for the curvature of the Earth, and therefore
requires three distinct operations. First, the points are moved so that their
centroid has a longitude of 0; then, the points are shifted in latitute by
performing a rotation along the pitch axis by the desired angle; finally, the
centroid of the points is brought back to its original longitude. For this
reason, and because the rotation along the pitch axis accounts for the curvature
of the Earth, this function will deform the shape, and specifically change the
range of longitudes covered.
"""
shiftlatitudes(angle) = (xy) -> _rotate_latitudes(xy, -angle)

"""
    localrotation(angle)
    
Returns a function to create a rotation of coordinates around their centroids.
"""
localrotation(angle) = (xy) -> _centroid_rotation(xy, angle)

"""
    rotator(longitude::T, latitude::T, rotation::T) where T <: Number

Returns a function to transform a vector of lon,lat points according to three
operations done in order:

    - a shift of the longitudes
    - a shift of the latitudes (the order of these two operations is actually irrelevant)
    - a local rotation around the centroid

All the angles are given in degrees. The output of this function is a function
that takes a vector of coordinates to transform. The transformations do account
for the curvature of the Earth. For this reason, rotations and changes in the
latitudes will deform the points, but shift in the longitudes will not.
"""
function rotator(longitude::T, latitude::T, rotation::T) where T <: Number
    return shiftlongitudes(longitude) ∘ shiftlatitudes(latitude) ∘ localrotation(rotation)
end

"""
    findrotation(L, P; longitudes=-10:0.1:10, latitudes=-10:0.1:10, rotations=-10:0.1:10, maxiter=10_000)

Find a possible rotation for the `shiftandrotate` function, by attempting to
move a target layer `L` until all of the shifted and rotated coordinates are
valid coordinates in the layer `P`. The range of angles to explore is given as
keywords, and the function accepts a `maxiter` argument after which, if no
rotation is found, it returns `nothing`.

The output of this method is either `nothing` (no valid rotation found), or a
rotator function (see the documentation for `rotator`).

Note that it is almost always a valid strategy to look for shifts and rotations
on a raster at a coarser resolution.
"""
function findrotation(L::SDMLayer, P::SDMLayer; longitudes=-10:0.1:10, latitudes=-10:0.1:10, rotations=-10:0.1:10, maxiter=10_000)
    iter = 1
    r = (rand(longitudes), rand(latitudes), rand(rotations))
    while iter < maxiter
        iter += 1
        r = (rand(longitudes), rand(latitudes), rand(rotations))
        trf = rotator(r...)
        u = [P[c...] for c in trf(lonlat(L))]
        if !any(isnothing, u)
            trf
        end
    end
    return nothing
end

"""
    shiftandrotate!(L::SDMLayer, P::SDMLayer, rotator)

Returns the output of shifting and rotating the layer `L` on the layer `P`,
according to a `rotator` function, obtained with for example `findrotation`.
This function overwrites `L`.
"""
function shiftandrotate!(L::SDMLayer, P::SDMLayer, rotator)
    SimpleSDMLayers.burnin!(L, [P[c...] for c in rotator(lonlat(L))])
    return L
end

"""
    shiftandrotate(L::SDMLayer, P::SDMLayer, rotator)

Returns the output of shifting and rotating the layer `L` on the layer `P`,
according to a `rotator` function, obtained with for example `findrotation`.
This function generates a copy of `L`.
"""
function shiftandrotate(L::SDMLayer, P::SDMLayer, rotator)
    Y = similar(L)
    shiftandrotate!(Y, P, rotator)
    return Y
end