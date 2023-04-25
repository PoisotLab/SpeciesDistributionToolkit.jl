# Integration with the Phylopic API

The `Phylopic.jl` package offers a simple wrapper on the [Phylopic](https://www.phylopic.org/) API, to collect silhouettes of species for plots. At the moment, it is a minimal viable product that allows to search for the UUID of images by taxonomic names, then to retrieve the vector file or the thumbnail associated to each image. It also provides the ability to store the credit information for all of the images used in a project.

## Finding images by names

```@docs
Phylopic.autocomplete
Phylopic.imagesof
```

## Retrieving images

```@docs
Phylopic.thumbnail
Phylopic.vector
Phylopic.twitterimage
Phylopic.source
```

## Additional functions

```@docs
Phylopic.attribution
```

## API interaction functions

```@docs
Phylopic.ping
Phylopic.build
```
