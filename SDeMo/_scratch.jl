using Revise
using BenchmarkTools
using CairoMakie
using Statistics
using SDeMo

samples = ceil.(Int64, logrange(10, 25_000, 10))

l_tms = similar(samples, Float64)
l_alc = similar(samples, Float64)
l_mem = similar(samples, Float64)

n_tms = similar(samples, Float64)
n_alc = similar(samples, Float64)
n_mem = similar(samples, Float64)

d_tms = similar(samples, Float64)
d_alc = similar(samples, Float64)
d_mem = similar(samples, Float64)

for (i,s) in enumerate(samples)
    @info "$(s) samples"

    l_bench = @benchmark train!(SDM(ZScore(), Logistic(), 0.5, $(rand(Float64, 20, s)), $(rand(Bool, s)), collect(1:20)))
    n_bench = @benchmark train!(SDM(ZScore(), NaiveBayes(), 0.5, $(rand(Float64, 20, s)), $(rand(Bool, s)), collect(1:20)))
    d_bench = @benchmark train!(SDM(ZScore(), DecisionTree(), 0.5, $(rand(Float64, 20, s)), $(rand(Bool, s)), collect(1:20)))

    l_tms[i] = 1e-9median(l_bench.times)
    l_mem[i] = l_bench.memory
    l_alc[i] = l_bench.allocs

    n_tms[i] = 1e-9median(n_bench.times)
    n_mem[i] = n_bench.memory
    n_alc[i] = n_bench.allocs

    d_tms[i] = 1e-9median(d_bench.times)
    d_mem[i] = d_bench.memory
    d_alc[i] = d_bench.allocs

end

f = Figure(; size=(600, 600))
ax1 = Axis(f[1,1], xscale=log10, yscale=log10, ylabel="Time")
ax2 = Axis(f[2,1], xscale=log10, ylabel="Memory")
ax3 = Axis(f[3,1], xscale=log10, ylabel="Allocations")
scatterlines!(ax1, samples, l_tms, label="Logistic")
scatterlines!(ax1, samples, n_tms, label="Naive Bayes")
scatterlines!(ax1, samples, d_tms, label="Decision Tree")
scatterlines!(ax2, samples, l_mem)
scatterlines!(ax2, samples, n_mem)
scatterlines!(ax2, samples, d_mem)
scatterlines!(ax3, samples, l_alc)
scatterlines!(ax3, samples, n_alc)
scatterlines!(ax3, samples, d_alc)
axislegend(ax1, position=:lt, nbanks=2)
f
