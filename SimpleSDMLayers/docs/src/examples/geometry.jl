# # Working with geometry objects

# The `SimpleSDMLayers` package uses `Point`s to represent coordinates, which
# allows to easily use `GeometryBasics` objects for masking. In this example, we
# will illustrate how we can get the temperature values around a given point:

using SimpleSDMLayers
using GeometryBasics
using Plots

temperature = convert(Float32, SimpleSDMPredictor(CHELSA, BioClim, 1; left=-76, right=-72, top=47., bottom=43.))

#-

plot(temperature)

# We will now define a center of 1 degree of radius centered on Montréal

area = Circle(Point(-73.56, 45.50), 1.0)

# The `temperature` layer is a predictor, which is immutable, so we can convert
# it into a response:

temperature = convert(SimpleSDMResponse, temperature)

# And now we can quite simply clip and update:

for xyz in temperature
    if !(xyz.first in area)
        temperature[xyz.first] = nothing
    end
end

# This should lead to a circular-ish area:

plot(temperature)

# This approach is useful if you want to mask according to a polygon, or if you
# want to restrict pseudo-absences to a certain distance away from points in
# SDMs.