module TestPhylopicAutocomplete

using Test
using Phylopic

@test ~isempty(Phylopic.autocomplete("chiro"))

end
