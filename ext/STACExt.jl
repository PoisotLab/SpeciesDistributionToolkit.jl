module STACExt

using SpeciesDistributionToolkit
using STAC
import Downloads

function SimpleSDMLayers.SDMLayer(asset::STAC.Asset; store::Bool=true, kwargs...)
    # Step 1 - get the asset url
    asset_url = asset.data.href
    # Step 2 - download the file if required
    filepath = tempname()
    if store
        savedir = joinpath(SimpleSDMDatasets._LAYER_PATH, "STAC", string(hash(asset_url)))
        if !ispath(savedir)
            mkpath(savedir)
        end
        fname = split(asset_url, "/")[end]
        filepath = joinpath(savedir, fname)
        if !isfile(filepath)
            Downloads.download(asset_url, filepath)
        end
    else
        Downloads.download(asset_url, filepath)
    end
    # Step 3 - load the file
    L = SDMLayer(filepath; kwargs...)
    # Return
    return L
end

# TODO layers method for a STACCatalog (or provides?)

# TODO layers method for a collection within a STAC

# TODO overload some SimpleSDMDatasets methods for times?

end