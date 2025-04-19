"""
    reclassify(L::SDMLayer, rules::Pair...)

Returns a layer where the cells are updated as a function of rules, given as
`(function) => value`, where the function must return a `Bool` value. For
example, `reclassify(layer, (x -> abs(x)<=1)=>true)` will set a value of `true`
to all cells with values in -1;1, and maks all other cells. You can use multiple
rules, in which case they are applied sequentially (a later rule can overwrite
an earlier one).
"""
function reclassify(L::SDMLayer, rules::Pair...)
    # First - output layer
    out = similar(L, typeof(rules[1].second))

    # Second we set all positions to invisible
    out.indices .= false

    # Then we loop over the rules
    for rule in rules
        # We only work on the values that are not excluded by the rule
        t = nodata(L, !rule.first)
        # We we unmask and update the value
        out.indices[findall(t.indices)] .= true
        out.grid[findall(t.indices)] .= rule.second
    end
    return out
end

@testitem "We can apply the re-classify function" begin
    using Statistics
    L = SimpleSDMLayers.__demodata(; reduced = true)
    q1, q2 = quantile(L, [0.4, 0.6])
    out = reclassify(L, (x -> x > q2) => 3, (x -> q1 <= x <= q2) => 2, (x -> x < q1) => 1)
    @test all(sort(unique(values(out))) .== [1,2,3])
end