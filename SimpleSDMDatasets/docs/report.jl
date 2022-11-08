function report(data::RasterData{P, D}) where {P <: RasterProvider, D <: RasterDataset}
    text = "## $(D)\n"
    if ~isnothing(SimpleSDMDatasets.layers(data))
        text *= "**Support for layers** - list with `SimpleSDMDatasets.layers($(typeof(data)))`"
    end
    text *= "\n\n"
    if ~isnothing(SimpleSDMDatasets.months(data))
        text *= "**Support for months** - list with `SimpleSDMDatasets.months($(typeof(data)))`"
    end
    text *= "\n\n"
    if ~isnothing(SimpleSDMDatasets.resolutions(data))
        text *= "**Support for resolutions** - list with `SimpleSDMDatasets.resolutions($(typeof(data)))`"
    end
    text *= "\n\n"
    text *= "**Downloaded** as `$(SimpleSDMDatasets.downloadtype(data))`, **data stored** as `$(SimpleSDMDatasets.filetype(data))`\n"
    text *= "\n\n"
    # Supported futures?
    for S in subtypes(FutureScenario)
        models = []
        for M in subtypes(FutureModel)
            if SimpleSDMDatasets.provides(data, Future(S, M))
                push!(models, "`$(M)`")
            end
        end
        if ~isempty(models)
            text *= "**Future scenario `$(S)` supported** with models $(join(models, ", ", " and "))"
            text *= "\n\n"
        end
    end
    text *= "\n\n"
    return text
end

function report(::Type{P}) where {P <: RasterProvider}
    # Name of the provider
    _header = "# $(P)"
    # List of supported datasets
    _datasets = [
        report(RasterData(P, D)) for
        D in subtypes(RasterDataset) if SimpleSDMDatasets.provides(P, D)
    ]

    # Prepare and return
    full_text = """$(_header)

    $(reduce(*, _datasets))
    """
    return Markdown.parse(full_text)
end

for P in subtypes(RasterProvider)
    open(joinpath(@__DIR__, "src", "usr", "$(P).md"), "w") do io
        print(io, report(P))
    end
end