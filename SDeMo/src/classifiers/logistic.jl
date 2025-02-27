__sigmoid(z::Number) = 1.0 / (1.0 + exp(-z))
function __sigmoid!(store::Vector{<:AbstractFloat}, z::Vector{<:AbstractFloat})
    for i in eachindex(z)
        store[i] = __sigmoid(z[i])
    end
    return store
end    

@testitem "We get the correct response for a sigmoid" begin
    @test SDeMo.__sigmoid(0.0) == 0.5
    @test SDeMo.__sigmoid(-1e5) ≈ 0.0
    @test SDeMo.__sigmoid(1e5) ≈ 1.0
end

function __interactions(X)
    XiXi = X .^ 2
    nfeat = size(X, 1)
    intft = round(Int64, nfeat * (nfeat - 1) / 2)
    XiXj = zeros(eltype(X), intft, size(X, 2))
    cursor = 1
    for i in Base.OneTo(nfeat)
        for j in (i + 1):nfeat
            XiXj[cursor, :] = X[i, :] .* X[j, :]
            cursor += 1
        end
    end
    return XiXi, XiXj
end

function __makex(X, interactions)
    @assert interactions in [:all, :self, :none]
    X₀ = ones(size(X, 2))'
    Xᵢᵢ, Xᵢⱼ = SDeMo.__interactions(X)
    𝐗 = [X₀, X]
    if interactions == :self
        push!(𝐗, Xᵢᵢ)
    end
    if interactions == :all
        push!(𝐗, Xᵢᵢ)
        push!(𝐗, Xᵢⱼ)
    end
    return vcat(𝐗...)
end

function __maketheta(X, interactions)
    @assert interactions in [:all, :self, :none]
    θ₀ = zeros(1)
    nf = size(X, 1)
    θᵢ = zeros(nf)
    θᵢᵢ = zeros(nf)
    θᵢⱼ = zeros(round(Int64, nf * (nf - 1) / 2))
    θ = [θ₀, θᵢ]
    if interactions == :self
        push!(θ, θᵢᵢ)
    end
    if interactions == :all
        push!(θ, θᵢᵢ)
        push!(θ, θᵢⱼ)
    end
    return vcat(θ...)
end

"""
    Logistic

Logistic regression with default learning rate of 0.01, penalization (L2) of
0.1, and 2000 epochs. Note that interaction terms can be turned on and off
through the use of the `interactions` field. Possible values are `:all`
(default), `:self` (only squared terms), and `:none` (no interactions).

The `verbose` field (defaults to `false`) can be used to show the progress of
gradient descent, by showing the loss every 100 epochs, or to the value of the
`verbosity` field. Note that when doing cross-validation, the loss on the
validation data will be automatically reported.
"""
Base.@kwdef mutable struct Logistic <: Classifier
    λ::Float64 = 0.1 # Regularization
    η::Float64 = 0.01 # Learning rate
    epochs::Int64 = 2_000 # Epochs
    θ::Vector{Float64} = zeros(Float64, 2)
    interactions::Symbol = :all
    verbose::Bool = false
    verbosity::Int64 = 100
end

Base.zero(::Type{Logistic}) = 0.5

function SDeMo.train!(lreg::Logistic, y::Vector{Bool}, X::Matrix{T}; kwargs...) where {T <: Number}
    # Get the validation data if relevant
    Xt = get(kwargs, :Xt, nothing)
    yt = get(kwargs, :yt, nothing)
    validation_data = !(isnothing(Xt)|isnothing(yt))
    # Prepare interaction terms for validation data
    Xv = validation_data ? SDeMo.__makex(Xt, lreg.interactions) : nothing
    Xvt = validation_data ? permutedims(Xv) : nothing
    #
    𝐗 = SDeMo.__makex(X, lreg.interactions)
    𝐗t = transpose(𝐗)
    lreg.θ = SDeMo.__maketheta(X, lreg.interactions)

    for epoch in 1:(lreg.epochs)
        z = 𝐗t * lreg.θ
        __sigmoid!(z, z)
        gradient = (1 / length(lreg.θ)) * 𝐗 * (z - y) + (lreg.λ / length(lreg.θ)) * lreg.θ
        lreg.θ -= lreg.η * gradient
        if lreg.verbose & iszero(epoch % lreg.verbosity)
            validation_loss = nothing
            if validation_data
                zv = Xvt * lreg.θ
                __sigmoid!(zv, zv)
                validation_loss = -mean(yt .* log.(zv) .+ (1 .- yt) .* log.(1 .- zv)) + (lreg.λ / (2 * length(lreg.θ))) * sum(lreg.θ[2:end] .^ 2)
            end
            z = clamp.(z, eps(), 1 - eps())
            loss =
                -mean(y .* log.(z) .+ (1 .- y) .* log.(1 .- z)) +
                (lreg.λ / (2 * length(lreg.θ))) * sum(lreg.θ[2:end] .^ 2)
            # Percent done
            prct = lpad(round(Int64, (epoch / lreg.epochs) * 100), 3, " ")
            infostr = "[$(prct)%] LOSS: training ≈ $(rpad(round(loss; digits=4), 6, " "))"
            if validation_data
                infostr *= " validation ≈ $(rpad(round(validation_loss; digits=4), 6, " "))"
                loss_prct = lpad(round(Int64, (validation_loss / loss) * 100), 3, " ")
                infostr *= " ($(loss_prct)%)"
            end
            @info infostr
        end
    end

    return lreg
end

function StatsAPI.predict(lreg::Logistic, x::Vector{T}) where {T <: Number}
    return predict(lreg, reshape(x, :, 1))
end

function StatsAPI.predict(lreg::Logistic, X::Matrix{T}) where {T <: Number}
    𝐗 = __makex(X, lreg.interactions)
    z = transpose(𝐗) * lreg.θ
    return __sigmoid!(z, z)
end

function __extract_coefficients(sdm::SDM)
    @assert sdm.classifier isa Logistic
    nf = length(variables(sdm))
    Θ = sdm.classifier.θ
    Θ₀ = Θ[1]
    Θᵢ = Θ[2:(nf + 1)]
    C = [Θ₀, Θᵢ]
    if sdm.classifier.interactions == :self
        Θᵢᵢ = Θ[(nf + 2):(2nf + 1)]
        push!(C, Θᵢᵢ)
    end
    if sdm.classifier.interactions == :all
        Θᵢᵢ = Θ[(nf + 2):(2nf + 1)]
        Θᵢⱼ = Θ[(2nf + 2):end]
        push!(C, Θᵢᵢ)
        push!(C, Θᵢⱼ)
    end
    return tuple(C...)
end

__subscript(i) = join(Char(0x2080 + d) for d in reverse!(digits(i)))

function __equation(sdm::SDM; digits = 2)
    function __printer(n, t)
        rn = round(n; digits = digits)
        return rn != 0 ? "$(rn) × $(t)" : ""
    end
    @assert sdm.classifier isa Logistic
    C = __extract_coefficients(sdm)
    terms = String[]
    # Intercept
    push!(terms, __printer(C[1], ""))
    # Coefficients
    for (i, c) in enumerate(C[2])
        pr = __printer(c, "𝐱$(__subscript(i))")
        if !isempty(pr)
            push!(terms, pr)
        end
    end
    # Squares
    if length(C) >= 3
        for (i, c) in enumerate(C[3])
            pr = __printer(c, "(𝐱$(__subscript(i)))²")
            if !isempty(pr)
                push!(terms, pr)
            end
        end
    end
    # Non-self interactions
    if length(C) == 4
        cursor = 1
        for i in Base.OneTo(length(C[2]))
            for j in (i + 1):length(C[2])
                pr = __printer(C[4][cursor], "(𝐱$(__subscript(i))⋅𝐱$(__subscript(j)))")
                if !isempty(pr)
                    push!(terms, pr)
                end
                cursor += 1
            end
        end
    end
    return replace(join(terms, " + "), "+ -" => "- ", "×  " => "")
end

@testitem "We can run a Logistic model" begin
    X, y = SDeMo.__demodata()
    sdm = SDM(ZScore(), Logistic(), 0.5, X, y, [1,2,12])
    folds = holdout(sdm)
    classifier(sdm).verbose = true
    classifier(sdm).η = 1e-3
    classifier(sdm).verbosity = 10
    train!(sdm; training=folds[1])
end