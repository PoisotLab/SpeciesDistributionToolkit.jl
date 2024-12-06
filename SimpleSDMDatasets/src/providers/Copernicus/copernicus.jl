provides(::Type{Copernicus}, ::Type{LandCover}) = true

url(::Type{Copernicus}) = "https://land.copernicus.eu/en/products/global-dynamic-land-cover"
blurb(::Type{Copernicus}) = md"""
The Global Dynamic Land Cover product offers annual global land cover maps and
cover fraction layers, providing a detailed view of land cover at three
classification levels. It uses modern data analysis techniques to ensure
temporal consistency and accuracy, with the latest version achieving 80%
accuracy at class level 1 on each continent. The product also includes
continuous field layers, or "fraction maps", that provide proportional estimates
for vegetation and ground cover for the land cover types. These features make it
a versatile tool for a wide range of applications, including forest monitoring,
rangeland management, crop monitoring, biodiversity conservation, climate
modelling, and urban planning.
"""