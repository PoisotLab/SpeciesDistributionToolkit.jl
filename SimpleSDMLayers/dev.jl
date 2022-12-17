using Revise
using SimpleSDMLayers

# Generate a simple example for testing
layer = SimpleSDMResponse(Matrix(reshape(1:12, (4, 3))))
layer.grid[1, 3] = nothing
layer.grid[4, 2] = nothing
layer.grid[3, 3] = nothing

@info eltype(layer)

f = (x) -> x <= 6
lf = f.(layer)

g = (x) -> x >= 3
lg = g.(layer)

(lf .& lg).grid

layer .+ 2

layer .+ layer

2layer