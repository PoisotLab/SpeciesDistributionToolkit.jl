
using GBIF


uk_birds_query = Dict(
  "taxonKey"=>5231190,
  "country"=>"GB",
  "hasCoordinate"=>true,
  "year"=>"2015")
uk_birds = occurrences(uk_birds_query)
println("There are ", uk_birds.count, " records available")


uk_birds.query["limit"] = 200


complete!(uk_birds)


using Plots


obs_dates = map(x -> x.date, uk_birds.occurrences)
by_month = Dates.month.(obs_dates)
histogram(by_month,
  xticks=([1,3,5,7,9,11],["Jan","Mar","May","Jul","Sep","Nov"]),
  c=:lightgrey, lab="", ylab="Number of occurrences")


latlon = map(x -> [x.longitude, x.latitude], uk_birds.occurrences)
x = hcat(latlon...)'
histogram2d(x[:,1], x[:,2], c=:YlGnBu, nbins=25, aspectratio=1)
scatter!(x[:,1], x[:,2], mc=by_month, ms=2, lab="")
xaxis!("Longitude")
yaxis!("Latitude")

