function pre!(content)
    return content |> pre_collapse_figure
end

function post!(content)
    return content |> post_extract_table
end

function pre_collapse_figure(content)
    fig_hash = string(hash(rand(100)))

    matcher = r"""^# fig-(?<title>[\w-]+)$
    (?<code>(?>^[^#].*$\n){1,})^current_figure\(\) #hide$"""m

    replacement_template = """
    # ![](HASH-\\g<title>.png)


    # ::: details Code for the figure

    \\g<code>save("HASH-\\g<title>.png", current_figure()); #hide

    # :::
    """
    replacer = SubstitutionString(replace(replacement_template, "HASH" => fig_hash))
    content = replace(content, matcher => replacer)
    return content
end

function post_extract_table(content)
    matcher = r"^`+$\n(?<table>(^\|.+\|$\n)+)\n`+$"m
    replacer = """
    \\g<table>
    """ |> SubstitutionString
    content = replace(content, matcher => replacer)
    return content
end

# Render the tutorials and how-to using Literate
for folder in ["howto", "tutorials"]
    fpath = joinpath(@__DIR__, "src", folder)
    files_to_build = filter(endswith(".jl"), readdir(fpath; join = true))
    for docfile in files_to_build
        if ~isfile(replace(docfile, r".jl$" => ".md"))
            Literate.markdown(
                docfile, fpath;
                flavor = Literate.DocumenterFlavor(),
                config = Dict("credit" => false, "execute" => true),
                preprocess = pre!,
                postprocess = post!,
            )
        end
    end
end
