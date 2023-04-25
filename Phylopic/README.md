# Phylopic.jl

This package is a *thin* wrapper around the Phylopic API, which is currently not covering
the entire API.

~~~julia
using Phylopic
import Downloads

# Get a series of UUIDs from a name
org_uuid = Phylopic.imagesof("chiroptera"; items=1)

# We can query the thumbnails for this UUID
thumb_url = Phylopic.thumbnail(org_uuid)

# We can download the thumbnail (to a temp file)
thumb_file = Downloads.download(first(thumb_url))
~~~
