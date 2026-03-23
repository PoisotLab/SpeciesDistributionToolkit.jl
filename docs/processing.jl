function pre!(content)
    return content |> pre_collapse_figure |> pre_no_revise |> pre_makie_hidpi |> pre_add_random
end

function post!(content)
    return content |> post_extract_table
end

function pre_collapse_figure(content)
    fig_hash = string(hash(rand(100)))

    matcher = r"""^#figure (?<title>[\w-]+)$
    (?<code>(?>^[^#].*$\n)+?)^current_figure\(\) #hide$"""m

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

function pre_no_revise(content)
    content = replace(content, "using Revise" => "")
    return content
end

function pre_makie_hidpi(content)
    content = replace(content, "using CairoMakie" => """
    using CairoMakie
    CairoMakie.activate!(; type = "png", px_per_unit = 2) #hide
    """)
    return content
end

function pre_add_random(content)
    content = """
    import Random #hide
    Random.seed!(12345) #hide
    """ * content
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
