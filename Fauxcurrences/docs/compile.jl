# This file will compile the `README.jl` file to `README.md`, which will then be
# deployed to github pages (on the appropriate branch). This will also create a
# notebook without the code executed, if people are into that sort of things.

using Literate

config = Dict(
    :md => Dict(
        "execute" => true,
        "flavor" => Literate.CommonMarkFlavor(),
        "credit" => false,
        "name" => joinpath("docs", "README.md")
    ),
    :ipynb => Dict(
        "execute" => true,
        "credit" => false,
        "name" => joinpath("docs", "fauxcurrences_demo.ipynb")
    )
)

Literate.markdown(joinpath(pwd(), "docs", "README.jl"); config=config[:md])
Literate.notebook(joinpath(pwd(), "docs", "README.jl"); config=config[:ipynb])