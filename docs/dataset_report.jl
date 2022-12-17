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

function report(data::RasterData{P, D}) where {P <: RasterProvider, D <: RasterDataset}
    for S in subtypes(FutureScenario)
        models = []
        for M in subtypes(FutureModel)
            if SimpleSDMDatasets.provides(data, Projection(S, M))
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

function report(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset}
    # Name of the provider
    _header = "# $(D)"
    # Short description
    _description = """
    The `$(D)` dataset is provided as part of the `$(P)` provider. For more information about this dataset, please refer to: $(SimpleSDMDatasets.url(RasterData(P, D)))

    To access this dataset:

    ~~~julia
    using SpeciesDistributionToolkit
    layer = SimpleSDMPredictor(RasterData($(P), $(D)))
    ~~~

    The remainder of this page will list the keywords you can use to retrieve specific months, layers, etc.
    """
    # Prepare and return
    full_text = """$(_header)

    $(_description)

    $(_document_layers(RasterData(P, D)))

    $(_document_resolutions(RasterData(P, D)))

    $(_document_months(RasterData(P, D)))
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
