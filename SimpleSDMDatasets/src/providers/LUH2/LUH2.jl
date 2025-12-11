provides(::Type{LUH2}, ::Type{LandCover}) = true

url(::Type{LUH2}) = "https://luh.umd.edu/data.shtml"
blurb(::Type{LUH2}) = md"""
The goal of the Land-Use Harmonization (LUH2) project is to prepare a harmonized
set of land-use scenarios that smoothly connects the historical reconstructions
of land-use with the future projections in the format required for ESMs. The
land-use harmonization strategy estimates the fractional land-use patterns,
underlying land-use transitions, and key agricultural management information,
annually for the time period 850-2100 at 0.25 x 0.25 resolution, while
minimizing the differences at the transition between the historical
reconstruction ending conditions and IAM initial conditions, and working to
preserve changes depicted by the IAMs in the future. 
"""