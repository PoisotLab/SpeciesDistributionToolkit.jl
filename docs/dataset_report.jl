function _document_layers(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.layers(data))
        text = "\n### Layers\n\n"
        text *= "The following layers are accessible through the `layer` keyword:\n\n"
        text *= "| Layer code | Description |\n"
        text *= "|------------|-------------|\n"
        for (k, v) in SimpleSDMDatasets.layerdescriptions(data)
            text *= "| `$(k)` | $(v) |\n"
        end
        return text
    end
    return ""
end

function _document_extrakeys(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.extrakeys(data))
        text = "\n::: details Additional keywords\n\n"
        text *= "The following keyword arguments can be used with this dataset:\n\n"
        for (k, v) in SimpleSDMDatasets.extrakeys(data)
            text *= "**$(String(k))**: $(join(v, ", ", " and "))\n\n"
        end
        text *= "\n:::\n\n"
        return text
    end
    return ""
end

function _document_resolutions(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.resolutions(data))
        text = "\n::: details Spatial resolution\n\n"
        text *= "The following resolutions are accessible through the `resolution` keyword argument:\n\n"
        text *= "| Resolution | Key |\n"
        text *= "|------------|-------------|\n"
        for (k, v) in SimpleSDMDatasets.resolutions(data)
            text *= "| `$(v)` | $(k) |\n"
        end
        text *= "\nYou can also list the resolutions using `SimpleSDMDatasets.resolutions($(typeof(data)))`.\n\n"
        text *= "\n:::\n\n"
        return text
    end
    return ""
end

function _document_months(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if !isnothing(SimpleSDMDatasets.months(data))   
        text = "\n::: details Indexed by months\n\n"
        text *= "This dataset can be accessed monthly, using the `month` keyword argument.\n\n"
        text *= "You can list the available months using `SimpleSDMDatasets.months($(typeof(data)))`.\n\n"
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
    For more information about this dataset, please refer to: $(SimpleSDMDatasets.url(RasterData(P, D)))

    To access this dataset:

    ~~~julia
    using SpeciesDistributionToolkit
    layer = SDMLayer(RasterData($(P), $(D)))
    ~~~

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
