# Benchmarking

```@example trace
using BenchmarkTools
using GBIF
```

## Taxon

```@example trace
@benchmark taxon("Boops boops")
```

## Occurrences

### No query

```@example trace
@benchmark occurrences()
```

### With query

```@example trace
@benchmark occurrences("year" => (2000, 2002))
```

### Paging

```@example trace
@benchmark occurrences!(o) setup=(o = occurrences())
```

### Paging with query

```@example trace
@benchmark occurrences!(p) setup=(p=occurrences("year" => (2000, 2002)))
```
