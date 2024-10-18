# Enumerated values

The GBIF API has a number of controlled vocabularies to perform queries (also called "enumerations"). In order to keep the API and the package in sync, when the package is loaded, we query the API to see what values are enumerable, and what values are acceptable for each of these categories.

```@docs
GBIF.enumerablevalues
GBIF.enumeratedvalues
```

These functions are *not* exported, and are only called once per session to populate
a dictionary with the accepted values. Note that at the moment, the only enumerated values
that we store are the one accepted as search argument by the occurrence search endpoint.
