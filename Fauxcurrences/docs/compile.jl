# This file will compile the `README.jl` file to `README.md`, which will then be
# deployed to github pages (on the appropriate branch). This will also create a
# notebook without the code executed, if people are into that sort of things.

using Literate

config = Dict(
    :md => Dict(
        "execute" => true,
        "flavor" => Literate.CommonMarkFlavor(),
        "credit" => false,
        "name" => "index"
    ),
    :ipynb => Dict(
        "execute" => true,
        "credit" => false,
        "name" => "fauxcurrences_demo"
    )
)

Literate.markdown(joinpath(pwd(), "README.jl"); config=config[:md])
Literate.notebook(joinpath(pwd(), "README.jl"); config=config[:ipynb])