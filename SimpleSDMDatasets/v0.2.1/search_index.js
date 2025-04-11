var documenterSearchIndex = {"docs":
[{"location":"interface/#The-dataset-interface","page":"Interface","title":"The dataset interface","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"This page is meant for contributors to the package, and specifically provides information on the interface, what to overload, and why.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"All of the methods that form the interface have two versions: one for current data, and one for future data. The default behavior of the interface is for the version on future data to fall back to the version for current data (i.e. we assume that future data are provided with the same format as current data). This means that most of the functions will not need to be overloaded when adding a provider with support for future data.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"The interface is built around the idea that Julia will use the most specific version of a method first, and resort to the less generic ones when there are multiple matches. A good example is the BioClim dataset, provided by a number of sources, that often has different URLs and filenames. This is handled (in e.g. CHELSA2) by writing a method for the general case of any dataset RasterData{CHELSA2,T} (using a Union type), and then a specific method on RasterData{CHELSA2,BioClim}. In the case of CHELSA2, the general method handles all datasets except BioClim, which makes the code much easier to write and maintain.","category":"page"},{"location":"interface/#Compatibility-between-datasets-and-providers","page":"Interface","title":"Compatibility between datasets and providers","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"The inner constructor for RasterData involves a call to provides, which must return true for the type to be constructed. The generic method for provides returns false, so additional provider/dataset pairs must be overloaded to return true in order for the corresponding RasterData type to exist.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"In practice, especially when there are multiple datasets for a single provider, the easiest way is to define a Union type and overload based on membership to this union type, as touched upon earlier in this document.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.provides","category":"page"},{"location":"interface/#SimpleSDMDatasets.provides","page":"Interface","title":"SimpleSDMDatasets.provides","text":"provides(::Type{P}, ::Type{D}) where {P <: RasterProvider, D <: RasterDataset}\n\nThis is the core function upon which the entire interface is built. Its purpose is to specify whether a specific dataset is provided by a specific provider. Note that this function takes two arguments, as opposed to a RasterData argument, because it is called in the inner constructor of RasterData: you cannot instantiate a RasterData with an incompatible provider/dataset combination.\n\nThe default value of this function is false, and to allow the use of a dataset with a provider, it is required to overload it for this specific pair so that it returns true.\n\n\n\n\n\nprovides(::R, ::F) where {R <: RasterData, F <: Future}\n\nThis method for provides specifies whether a RasterData combination has support for the value of the Future (a combination of a FutureScenario and a FutureModel) given as the second argument. Note that this function is not called as part of the Future constructor (because models and scenarios are messy and dataset dependent), but is still called when requesting data.\n\nThe default value of this function is false, and to allow the use of a future dataset with a given provider, it is required to overload it so that it returns true.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Type-of-object-downloaded","page":"Interface","title":"Type of object downloaded","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"The specification about the format of downloaded files is managed by downloadtype. By default, we assume that a request to a usable dataset is returning a single file, but this can be overloaded for the providers who return an archive.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.downloadtype","category":"page"},{"location":"interface/#SimpleSDMDatasets.downloadtype","page":"Interface","title":"SimpleSDMDatasets.downloadtype","text":"downloadtype(::R) where {R <: RasterData}\n\nThis method returns a RasterDownloadType that is used internally to be more explicit about the type of object that is downloaded from the raster source. The supported values are _file (the default, which is an ascii, geotiff, NetCDF, etc. single file), and _zip (a zip archive containing files). This is a trait because we cannot trust file extensions.\n\n\n\n\n\ndownloadtype(data::R, ::F) where {R <: RasterData, F <: Future}\n\nThis method provides the type of the downloaded object for a combination of a raster source and a future scenario as a RasterDownloadType.\n\nIf no overload is given, this will default to downloadtype(data), as we can assume that the type of downloaded object is the same for both current and future scenarios.\n\n\n\n\n\n","category":"function"},{"location":"interface/","page":"Interface","title":"Interface","text":"The return type of the downloadtype must be one of the RasterDownloadType enum, which can be extended if adding a new provider requires a new format for the download.","category":"page"},{"location":"interface/#Type-of-object-stored","page":"Interface","title":"Type of object stored","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"The specification about the format of the information contained in the downloaded type is managed by filetype. By default, we assume that a request to a usable dataset is returning a tiff, but this can be overloaded for the providers who return data in another format. Note that if the download type is an archive, the file type describes the format of the files within the archive.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.filetype","category":"page"},{"location":"interface/#SimpleSDMDatasets.filetype","page":"Interface","title":"SimpleSDMDatasets.filetype","text":"filetype(::R) where {R <: RasterData}\n\nThis method returns a RasterFileType that represents the format of the raster data. RasterFileType is an enumerated type. This overload is particularly important as it will determine how the returned file path should be read.\n\nThe default value is _tiff.\n\n\n\n\n\nfiletype(data::R, ::F) where {R <: RasterData, F <: Future}\n\nThis method provides the format of the stored raster for a combination of a raster source and a future scenario as a RasterFileType.\n\nIf no overload is given, this will default to filetype(data), as we can assume that the raster format is the same for both current and future scenarios.\n\n\n\n\n\n","category":"function"},{"location":"interface/","page":"Interface","title":"Interface","text":"The return type of the filetype must be one of the RasterFileType enum, which can be extended if adding a new provider requires a new format for the download.","category":"page"},{"location":"interface/#Available-resolutions","page":"Interface","title":"Available resolutions","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.resolutions","category":"page"},{"location":"interface/#SimpleSDMDatasets.resolutions","page":"Interface","title":"SimpleSDMDatasets.resolutions","text":"resolutions(::R) where {R <: RasterData}\n\nThis method controls whether the dataset has a resolution, i.e. a grid size. If this is nothing (the default), it means that the dataset is only given at a set resolution.\n\nAn overload of this method is required when there are multiple resolutions available, and must return a Dict with numeric keys (for the resolution) and string values (giving the textual representation of these keys, usually in the way that is usable to build the url).\n\nAny dataset with a return value that is not nothing must accept the resolution keyword.\n\n\n\n\n\nresolutions(data::R, ::F) where {R <: RasterData, F <: Future}\n\nThis methods control the resolutions for a future dataset. Unless overloaded, it will return resolutions(data).\n\n\n\n\n\n","category":"function"},{"location":"interface/#Available-layers","page":"Interface","title":"Available layers","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"layers\nlayerdescriptions","category":"page"},{"location":"interface/#SimpleSDMDatasets.layers","page":"Interface","title":"SimpleSDMDatasets.layers","text":"layers(::R) where {R <: RasterData}\n\nThis method controls whether the dataset has named layers. If this is nothing (the default), it means that the dataset will have a single layer.\n\nAn overload of this method is required when there are multiple layers available, and must return a Vector, usually of String. Note that by default, the layers can also be accessed by using an Integer, in which case layer=i will be the i-th entry in layers(data).\n\nAny dataset with a return value that is not nothing must accept the layer keyword.\n\n\n\n\n\n","category":"function"},{"location":"interface/#SimpleSDMDatasets.layerdescriptions","page":"Interface","title":"SimpleSDMDatasets.layerdescriptions","text":"layerdescriptions(data::R) where {R <: RasterData}\n\nHuman-readable names the layers. This must be a dictionary mapping the layer names (as returned by layers) to a string explaining the contents of the layers.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Available-months","page":"Interface","title":"Available months","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.months","category":"page"},{"location":"interface/#SimpleSDMDatasets.months","page":"Interface","title":"SimpleSDMDatasets.months","text":"months(::R) where {R <: RasterData}\n\nThis method controls whether the dataset has monthly layers. If this is nothing (the default), it means that the dataset is not accessible at a monthly resolution.\n\nAn overload of this method is required when there are multiple months available, and must return a Vector{Dates.Month}.\n\nAny dataset with a return value that is not nothing must accept the month keyword.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Available-years","page":"Interface","title":"Available years","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.timespans","category":"page"},{"location":"interface/#SimpleSDMDatasets.timespans","page":"Interface","title":"SimpleSDMDatasets.timespans","text":"timespans(data::R, ::F) where {R <: RasterData, F <: Future}\n\nFor datasets with a Future scenario, this method should return a Vector of Pairs, which are formatted as\n\nYear(start) => Year(end)\n\nThere is a method working on a single RasterData argument, defaulting to returning nothing, but it should never be overloaded.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Additional-keyword-arguments","page":"Interface","title":"Additional keyword arguments","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.extrakeys","category":"page"},{"location":"interface/#SimpleSDMDatasets.extrakeys","page":"Interface","title":"SimpleSDMDatasets.extrakeys","text":"extrakeys(::R) where {R <: RasterData}\n\nThis method controls whether the dataset has additional keys. If this is nothing (the default), it means that the dataset can be accessed using only the default keys specified in this interface.\n\nAn overload of this method is required when there are additional keywords needed to access the data (e.g. full=true for the EarthEnv land-cover data), and must return a Dict, with Symbol keys and Tuple arguments, where the key is the keyword argument passed to downloader and the tuple lists all accepted values.\n\nAny dataset with a return value that is not nothing must accept the keyword arguments specified in the return value.\n\n\n\n\n\n","category":"function"},{"location":"interface/#URL-for-the-data-to-download","page":"Interface","title":"URL for the data to download","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.source","category":"page"},{"location":"interface/#SimpleSDMDatasets.source","page":"Interface","title":"SimpleSDMDatasets.source","text":"source(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset}\n\nThis method specifies the URL for the data. It defaults to nothing, so this method must be overloaded.\n\n\n\n\n\n","category":"function"},{"location":"interface/#Path-to-the-data-locally","page":"Interface","title":"Path to the data locally","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"SimpleSDMDatasets.destination","category":"page"},{"location":"interface/#SimpleSDMDatasets.destination","page":"Interface","title":"SimpleSDMDatasets.destination","text":"destination(::RasterData{P, D}; kwargs...) where {P <: RasterProvider, D <: RasterDataset}\n\nThis method specifies where the data should be stored locally. By default, it is the _LAYER_PATH, followed by the provider name, followed by the dataset name.\n\n\n\n\n\n","category":"function"},{"location":"#SimpleSDMDatasets","page":"Index","title":"SimpleSDMDatasets","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"The purpose of this package is to get raster datasets for use in biogeography work, retrieve them from online locations, and store them in a central location to avoid data duplication. Datasets are downloaded upon request, and only the required files are downloaded.","category":"page"},{"location":"","page":"Index","title":"Index","text":"The package is built around two \"pillars\":","category":"page"},{"location":"","page":"Index","title":"Index","text":"An interface based on traits, which specifies where the data live (remotely and locally), what the shape of the data is, and which keyword arguments are usable to query the data.\nA type system to identify which datasets are accessible through various providers, and which future scenarios are available.","category":"page"},{"location":"","page":"Index","title":"Index","text":"The combination of the interface and the type system means that adding a new dataset is relatively straightforward, and in particular that there is no need to write dataset-specific code to download the files (beyond specifying where the data live).","category":"page"},{"location":"","page":"Index","title":"Index","text":"The purpose of the documentation is to (i) provide a high-level overview of how to get data from a user point of view, (ii) list the datasets that are accessible for users through the package alongside their most important features and (iii) give a comprehensive overview of the way the interface works, to facilitate the addition of new data sources.","category":"page"},{"location":"internals/#What-happens-when-the-user-requests-a-dataset?","page":"Internals","title":"What happens when the user requests a dataset?","text":"","category":"section"},{"location":"internals/#The-downloader","page":"Internals","title":"The downloader","text":"","category":"section"},{"location":"internals/","page":"Internals","title":"Internals","text":"SimpleSDMDatasets.downloader","category":"page"},{"location":"internals/#SimpleSDMDatasets.downloader","page":"Internals","title":"SimpleSDMDatasets.downloader","text":"SimpleSDMDatasets.downloader\n\n...\n\n\n\n\n\n","category":"function"},{"location":"internals/#The-keychecker","page":"Internals","title":"The keychecker","text":"","category":"section"},{"location":"internals/","page":"Internals","title":"Internals","text":"SimpleSDMDatasets.keychecker","category":"page"},{"location":"internals/#SimpleSDMDatasets.keychecker","page":"Internals","title":"SimpleSDMDatasets.keychecker","text":"SimpleSDMDatasets.keychecker(data::R; kwargs...) where {R <: RasterData}\n\nChecks that the keyword arguments passed to a downloader are correct, i.e. the data provider / source being retrieved supports them.\n\n\n\n\n\n","category":"function"},{"location":"types/#Type-system-for-datasets","page":"Types","title":"Type system for datasets","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"Note that all datasets must be a direct subtype of RasterDataset, all providers must be a direct subtype of RasterProvider, all scenarios must be a direct subtype of FutureScenario, and all models must be a direct subtype of FutureModel. If you need to aggregate multiple models within a type (e.g. CMIP6Scenarios), use a Union type. The reason for this convention is that in interactive mode, subtype will let users pick the data combination they want.","category":"page"},{"location":"types/#Type-system-overview","page":"Types","title":"Type system overview","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"RasterData\nRasterDataset\nRasterProvider","category":"page"},{"location":"types/#SimpleSDMDatasets.RasterData","page":"Types","title":"SimpleSDMDatasets.RasterData","text":"RasterData{P <: RasterProvider, D <: RasterDataset}\n\nThe RasterData type is the main user-facing type for SimpleSDMDatasets. Specifically, this is a singleton parametric type, where the two parameters are the type of the RasterProvider and the RasterDataset. Note that the inner constructor calls the provides method on the provider/dataset pair to check that this combination exists.\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.RasterDataset","page":"Types","title":"SimpleSDMDatasets.RasterDataset","text":"RasterDataset\n\nThis is an abstract type to label something as being a dataset. Datasets are given by RasterProviders, and the same dataset can have multiple providers.\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.RasterProvider","page":"Types","title":"SimpleSDMDatasets.RasterProvider","text":"RasterProvider\n\nThis is an abstract type to label something as a provider of RasterDatasets. For example, WorldClim2 and CHELSA2 are RasterProviders.\n\n\n\n\n\n","category":"type"},{"location":"types/#List-of-datasets","page":"Types","title":"List of datasets","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"BioClim\nElevation\nMinimumTemperature\nMaximumTemperature\nAverageTemperature\nPrecipitation\nSolarRadiation\nWindSpeed\nWaterVaporPressure\nLandCover\nHabitatHeterogeneity\nTopography\nBirdRichness\nMammalRichness\nAmphibianRichness","category":"page"},{"location":"types/#SimpleSDMDatasets.BioClim","page":"Types","title":"SimpleSDMDatasets.BioClim","text":"BioClim\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.Elevation","page":"Types","title":"SimpleSDMDatasets.Elevation","text":"Elevation\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.MinimumTemperature","page":"Types","title":"SimpleSDMDatasets.MinimumTemperature","text":"MinimumTemperature\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.MaximumTemperature","page":"Types","title":"SimpleSDMDatasets.MaximumTemperature","text":"MaximumTemperature\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.AverageTemperature","page":"Types","title":"SimpleSDMDatasets.AverageTemperature","text":"AverageTemperature\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.Precipitation","page":"Types","title":"SimpleSDMDatasets.Precipitation","text":"Precipitation\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.SolarRadiation","page":"Types","title":"SimpleSDMDatasets.SolarRadiation","text":"SolarRadiation\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.WindSpeed","page":"Types","title":"SimpleSDMDatasets.WindSpeed","text":"WindSpeed\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.WaterVaporPressure","page":"Types","title":"SimpleSDMDatasets.WaterVaporPressure","text":"WaterVaporPressure\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.LandCover","page":"Types","title":"SimpleSDMDatasets.LandCover","text":"LandCover\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.HabitatHeterogeneity","page":"Types","title":"SimpleSDMDatasets.HabitatHeterogeneity","text":"HabitatHeterogeneity\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.Topography","page":"Types","title":"SimpleSDMDatasets.Topography","text":"Topography\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.BirdRichness","page":"Types","title":"SimpleSDMDatasets.BirdRichness","text":"BirdRichness\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.MammalRichness","page":"Types","title":"SimpleSDMDatasets.MammalRichness","text":"MammalRichness\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.AmphibianRichness","page":"Types","title":"SimpleSDMDatasets.AmphibianRichness","text":"AmphibianRichness\n\n\n\n\n\n","category":"type"},{"location":"types/#List-of-providers","page":"Types","title":"List of providers","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"WorldClim2\nEarthEnv\nCHELSA1\nCHELSA2\nBiodiversityMapping\nPaleoClim","category":"page"},{"location":"types/#SimpleSDMDatasets.WorldClim2","page":"Types","title":"SimpleSDMDatasets.WorldClim2","text":"WorldClim2\n\nThis provider offers access to the version 2 of the WorldClim data, accessible from http://www.worldclim.com/version2.\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.EarthEnv","page":"Types","title":"SimpleSDMDatasets.EarthEnv","text":"EarthEnv\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.CHELSA1","page":"Types","title":"SimpleSDMDatasets.CHELSA1","text":"CHELSA1\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.CHELSA2","page":"Types","title":"SimpleSDMDatasets.CHELSA2","text":"CHELSA2\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.BiodiversityMapping","page":"Types","title":"SimpleSDMDatasets.BiodiversityMapping","text":"BiodiversityMapping\n\nGlobal biodiveristy data from https://biodiversitymapping.org/ - see this website for citation information\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.PaleoClim","page":"Types","title":"SimpleSDMDatasets.PaleoClim","text":"PaleoClim\n\nPaleoclimate data from http://www.paleoclim.org/ - see this website for citation information\n\n\n\n\n\n","category":"type"},{"location":"types/#List-of-projections","page":"Types","title":"List of projections","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"Projection\nSimpleSDMDatasets.CMIP5Scenario","category":"page"},{"location":"types/#SimpleSDMDatasets.Projection","page":"Types","title":"SimpleSDMDatasets.Projection","text":"Future{S <: FutureScenario, M <: FutureModel}\n\nThis type is similar to RasterData but describes a combination of a scenario and a model. Note that unlike RasterData, there is no type check in the inner constructor; instead, the way to check that a provider/dataset/scenario/model combination exists is to overload the provides method for a dataset and future.\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.CMIP5Scenario","page":"Types","title":"SimpleSDMDatasets.CMIP5Scenario","text":"CMIP5Scenario\n\nThese scenarios are part of CMIP5. They can be RCP26 to RCP85 (with RCPXX the scenario).\n\n\n\n\n\n","category":"type"},{"location":"types/#List-of-enumerated-types","page":"Types","title":"List of enumerated types","text":"","category":"section"},{"location":"types/","page":"Types","title":"Types","text":"SimpleSDMDatasets.RasterDownloadType\nSimpleSDMDatasets.RasterFileType\nSimpleSDMDatasets.RasterCRS","category":"page"},{"location":"types/#SimpleSDMDatasets.RasterDownloadType","page":"Types","title":"SimpleSDMDatasets.RasterDownloadType","text":"RasterDownloadType\n\nThis enum stores the possible types of downloaded files. They are listed with instances(RasterDownloadType), and are currently limited to _file (a file, can be read directly) and _zip (an archive, must be unzipped).\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.RasterFileType","page":"Types","title":"SimpleSDMDatasets.RasterFileType","text":"RasterFileType\n\nThis enum stores the possible types of returned files. They are listed with instances(RasterFileType).\n\n\n\n\n\n","category":"type"},{"location":"types/#SimpleSDMDatasets.RasterCRS","page":"Types","title":"SimpleSDMDatasets.RasterCRS","text":"RasterCRS\n\nThis enum stores the possible coordinate representation system of returned files. They are listed with instances(RasterProjection).\n\n\n\n\n\n","category":"type"}]
}
