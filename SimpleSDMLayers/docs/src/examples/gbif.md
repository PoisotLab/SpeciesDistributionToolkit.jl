# Working with GBIF data

In this example, we will see how we can make the packages `SimpleSDMLayers` and
`GBIF` interact. We will specifically plot the relationship between temperature
and precipitation for a few occurrences of the raccoon *Procyon lotor*.

```@example temp
using SimpleSDMLayers
using GBIF
temperature = worldclim(1)
precipitation = worldclim(12)
```

We can get some occurrences for the taxon of interest:

```@example temp
raccoon = GBIFTaxon("Procyon lotor")
raccoon_occ = occurrences(raccoon)
```

We can extract the temperature for the first occurrence:

```@example temp
temperature[raccoon_occ[1]]
```
