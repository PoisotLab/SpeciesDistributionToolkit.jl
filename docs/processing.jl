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
    @info "LOLOLOLOL"
    matcher = r"^`+$\n(?<table>(^\|.+\|$\n)+)\n`+$"m
    replacer = """
    \\g<table>
    """ |> SubstitutionString
    content = replace(content, matcher => replacer)
    return content
end
