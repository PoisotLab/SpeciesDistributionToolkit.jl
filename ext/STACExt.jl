module STACExt

using SpeciesDistributionToolkit
using STAC
import Downloads

# TODO SDMLayer from STACCatalog asset

ghmts = catalog["ghmts"].items["GHMTS"].assets["GHMTS"]
f = Downloads.download(ghmts.data.href)
SDMLayer(f)

# TODO layers method for a STACCatalog (or provides?)

# TODO layers method for a collection within a STAC

# TODO overload some SimpleSDMDatasets methods for times?

end