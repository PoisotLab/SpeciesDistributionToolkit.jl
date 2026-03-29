# # Listing polygon properties

# This page gives an overview of the methods to get access to additional
# information stored in the polygon data.

using SpeciesDistributionToolkit

# We will select the `Countries` dataset from `NaturalEarth` as our example:

polydata = PolygonData(NaturalEarth, Countries)

# These data can be retrieved with `getpolygon`:

pol = getpolygon(polydata)

# This returns the complete dataset, which is almost always a lot more polygons
# that we want. To figure out which polygons are relevant, we need to inspect
# the properties attached to each:

keys(uniqueproperties(pol))

# Note that by default, the `Name` key can be used directly:

pol["Ghana"]

# We will look at which regions are available here:

uniqueproperties(pol)["Region"]

# Getting the countries for Africa is therefore:

pol["Region" => "Africa"]

# We can apply the `uniqueproperties` function to the object that is returned
# here, for example to list all available sub-regions:

uniqueproperties(pol["Region" => "Africa"])["Subregion"]

# We can now get all of the polygons in the region of Africa that are in the
# sub-region of Eastern Africa with:

eastern_afr = pol["Region" => "Africa"]["Subregion" => "Eastern Africa"]

# ## Related documentation

# ```@meta
# CollapsedDocStrings = true
# ```

# ```@docs; canonical=false
# uniqueproperties
# getpolygon
# PolygonData
# ```
