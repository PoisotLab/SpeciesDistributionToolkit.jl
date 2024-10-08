function _document_layers(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.layers(data))
        text = "\n::: details Keyword argument `layer`\n\n"
        text *= "\n\n"
        text *= "| Layer code | Description |\n"
        text *= "|------------|-------------|\n"
        for (k, v) in SimpleSDMDatasets.layerdescriptions(data)
            text *= "| `$(k)` | $(v) |\n"
        end
        text *= "\n:::\n\n"
        return text
    end
    return ""
end

function _document_extrakeys(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    exk = SimpleSDMDatasets.extrakeys(data)
    if !isnothing(exk)
        text = ""
        for (k,v) in exk
            text *= "\n\n::: details Keyword argument `$(k)`\n\n"
            for (val,def) in v
                text *= "\n\n$(def) - `$(val)`\n\n"
            end
            text *= "\n:::\n\n"
        end
        return text
    end
    return ""
end

function _document_resolutions(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.resolutions(data))
        text = "\n::: details Keyword argument `resolution`\n\n"
        for (k, v) in SimpleSDMDatasets.resolutions(data)
            text *= "\n\n$(v) - `$(k)`\n\n"
        end
        text *= "\n:::\n\n"
        return text
    end
    return ""
end

function _document_months(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.months(data))
        text = "\n::: details Keyword argument `month`\n\n"
        text *= "\nThis dataset can be accessed monthly, using the `month` keyword argument. You can list the available months using `SimpleSDMDatasets.months($(typeof(data)))`.\n\n"
        text *= "\n:::\n\n"
        return text
    end
    return ""
end

function _document_scenarios(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    text = ""
    for S in subtypes(FutureScenario)
        models = []
        spans = []
        for M in subtypes(FutureModel)
            F = Projection(S, M)
            if SimpleSDMDatasets.provides(data, F)
                push!(models, "`$(M)`")
                if ~isnothing(SimpleSDMDatasets.timespans(data, F))
                    append!(spans, SimpleSDMDatasets.timespans(data, F))
                end
            end
        end
        if ~isempty(models)
            text *= "\n::: details Projections for $(S)\n\n"
            text *= "Note that the future scenarios support the *same* keyword arguments as the contemporary data.\n\n"
            text *= "**Models**: $(join(models, ", ", " and "))\n\n"
            if ~isempty(spans)
                text *= "**Timespans**: $(join(unique(spans), ", ", " and "))\n\n"
            end
            text *= "\n:::\n\n"
        end
    end
    text *= "\n\n"
    return text
end

function report(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset}
    # Name of the provider
    _header = "## $(D)"
    # Short description
    _description = """

    ~~~julia
    using SpeciesDistributionToolkit
    layer = SDMLayer(RasterData($(P), $(D)))  # [!code focus]
    ~~~

    $(SimpleSDMDatasets.blurb(RasterData(P, D)))

    For more information about this dataset: $(SimpleSDMDatasets.url(RasterData(P, D)))

    """
    # Prepare and return
    full_text = """$(_header)

    $(_description)

    $(_document_layers(RasterData(P, D)))

    $(_document_resolutions(RasterData(P, D)))

    $(_document_extrakeys(RasterData(P, D)))

    $(_document_months(RasterData(P, D)))

    $(_document_scenarios(RasterData(P, D)))
    """
    return Markdown.parse(full_text)
end

# Make sure the path is therethemes
dataset_catalogue_path = joinpath("docs", "src", "datasets")
if ~ispath(dataset_catalogue_path)
    mkpath(dataset_catalogue_path)
end

for P in subtypes(RasterProvider)
    cardfile = joinpath(dataset_catalogue_path, "$(P).md")
    open(
        cardfile,
        "w",
    ) do io
        print(io, "# $(P) \n\n")
        print(io, "\n\n")
        print(io, "$(SimpleSDMDatasets.blurb(P))")
        print(io, "\n\n")
        print(io, "For more information about this provider: $(SimpleSDMDatasets.url(P))")
        print(io, "\n\n")
    end
    # Run the report for each dataset
    for D in subtypes(RasterDataset)
        if SimpleSDMDatasets.provides(P, D)
            open(
                cardfile,
                "a",
            ) do io
                print(io, report(P, D))
                print(io, "\n\n")
            end
        end
    end
end
