function _document_layers(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if isnothing(SimpleSDMDatasets.layers(data))
        return """
        ## Layers

        This dataset has no support for layers.
        """
    end
    text = "\n## Layers\n\n"
    text *= "The following layers are accessible through the `layer` keyword:\n\n"
    text *= "| Layer code | Description |\n"
    text *= "|------------|-------------|\n"
    for (k, v) in SimpleSDMDatasets.layerdescriptions(data)
        text *= "| `$(k)` | $(v) |\n"
    end
    return text
end

function _document_extrakeys(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if isnothing(SimpleSDMDatasets.extrakeys(data))
        return """
        ## Additional keyword arguments

        This dataset has no non-standard keywords arguments.
        """
    end
    text = "\n## Additional keyword arguments\n\n"
    text *= "The following keyword arguments can be used with this dataset:\n\n"
    for (k, v) in SimpleSDMDatasets.extrakeys(data)
    text *= "**$(String(k))**: $(join(v, ", ", " and "))\n\n"
    end
    return text
end

function _document_resolutions(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if isnothing(SimpleSDMDatasets.resolutions(data))
        return """
        ## Resolutions

        This dataset is provided in a single resolution
        """
    end
    text = "\n## Resolutions\n\n"
    text *= "The following resolutions are accessible through the `resolution` keyword argument:\n\n"
    text *= "| Resolution | Key |\n"
    text *= "|------------|-------------|\n"
    for (k, v) in SimpleSDMDatasets.resolutions(data)
        text *= "| `$(v)` | $(k) |\n"
    end
    text *= "\nYou can also list the resolutions using `SimpleSDMDatasets.resolutions($(typeof(data)))`.\n\n"
    return text
end

function _document_months(
    data::RasterData{P, D},
) where {P <: RasterProvider, D <: RasterDataset}
    if isnothing(SimpleSDMDatasets.months(data))
        return """
        ## Months

        This dataset is not indexed by months
        """
    end
    text = "\n## Months\n\n"
    text *= "This dataset can be accessed monthly, using the `month` keyword argument.\n\n"
    text *= "You can list the available months using `SimpleSDMDatasets.months($(typeof(data)))`.\n\n"
    return text
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
            text *= "## Support for future scenario $(S)\n\n"
            text *= "Note that the future scenarios support the *same* keyword arguments as the contemporary data.\n\n"
            text *= "**Models**: $(join(models, ", ", " and "))\n\n"
            if ~isempty(spans)
                text *= "**Timespans**: $(join(unique(spans), ", ", " and "))\n\n"
            end
        end
    end
    text *= "\n\n"
    return text
end

function report(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset}
    # Name of the provider
    _header = "# $(D)"
    # Short description
    _description = """
    The `$(D)` dataset is provided as part of the `$(P)` provider. For more information about this dataset, please refer to: $(SimpleSDMDatasets.url(RasterData(P, D)))

    To access this dataset:

    ~~~julia
    using SpeciesDistributionToolkit
    layer = SDMLayer(RasterData($(P), $(D))) # You will probably need keyword arguments here
    ~~~

    The remainder of this page will list the keywords you can use to retrieve specific months, layers, etc.
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

_dataset_catalogue = []

for P in subtypes(RasterProvider)
    # Create the path if it doesn't exist
    if ~ispath(joinpath(dataset_catalogue_path, string(P)))
        mkpath(joinpath(dataset_catalogue_path, string(P)))
    end
    this_cat = []
    # Run the report for each dataset
    for D in subtypes(RasterDataset)
        if SimpleSDMDatasets.provides(P, D)
            cardfile = joinpath(dataset_catalogue_path, string(P), "$(D).md")
            push!(this_cat, string(D) => joinpath(splitpath(cardfile)[3:end]))
            open(
                cardfile,
                "w",
            ) do io
                return print(io, report(P, D))
            end
        end
    end
    push!(_dataset_catalogue, string(P) => this_cat)
end
