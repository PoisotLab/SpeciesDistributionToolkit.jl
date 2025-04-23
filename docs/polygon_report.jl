function _document_uniqueproperties(
    data::PolygonData{P, D},
) where {P <: PolygonProvider, D <: PolygonDataset}
    return ""
    # exk = uniqueproperties(data)
    # if !isnothing(exk)
    #     text = ""
    #     for (k,v) in exk
    #         text *= "\n\n::: details Possible values for `$(k)`\n\n"
    #         for (val,def) in v
    #             text *= "\n\n$(def) - `$(val)`\n\n"
    #         end
    #         text *= "\n:::\n\n"
    #     end
    #     return text
    # end
    return ""
end

function report(::Type{P}, ::Type{D}) where {P <: PolygonProvider, D <: PolygonDataset}
    # Name of the provider
    _header = "## $(D)"
    # Short description
    _description = """

    ~~~julia
    using SpeciesDistributionToolkit
    polys = getpolygon(PolygonData($(P), $(D)))  # [!code focus]
    ~~~

    """
    # Prepare and return
    full_text = """$(_header)

    $(_description)

    $(_document_uniqueproperties(PolygonData(P, D)))
    """
    return Markdown.parse(full_text)
end

# Make sure the path is therethemes
polygon_catalogue_path = joinpath("docs", "src", "polygons")
if ~ispath(polygon_catalogue_path)
    mkpath(polygon_catalogue_path)
end

for P in subtypes(PolygonProvider)
    cardfile = joinpath(polygon_catalogue_path, "$(P).md")
    open(
        cardfile,
        "w",
    ) do io
        print(io, "# $(P) \n\n")
        print(io, "\n\n")
        # print(io, "$(SimpleSDMDatasets.blurb(P))")
        # print(io, "\n\n")
        # print(io, "For more information about this provider: $(SimpleSDMDatasets.url(P))")
        # print(io, "\n\n")
    end
    # Run the report for each dataset
    for D in subtypes(PolygonDataset)
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
