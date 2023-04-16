module SSDImportModuleTest
using Test
using SimpleSDMDatasets

# This is not the cleanest test, but it is checking that the module works when called from
# within another module

module TestModule

_prefix = Main.SSDImportModuleTest.SimpleSDMDatasets
using Main.SSDImportModuleTest.SimpleSDMDatasets

function foo()
    _prefix.downloader(
        RasterData(WorldClim2, BioClim),
        layer="BIO7")
end
export foo
end

@info TestModule.foo()
@test isfile(first(TestModule.foo()))

end
