# Performance pitfalls

```@example trace
using Traceur
using GBIF
```

## Taxon

```@example trace
@trace taxon("Boops boops")
```

## Occurrences

### No query

```@example trace
@trace occurrences()
```

### With query

```@example trace
@trace occurrences("year" => (2000, 2002))
```

### Paging

```@example trace
o = occurrences()
@trace occurrences!(o)
```

### Paging with query

```@example trace
p = occurrences("year" => (2000, 2002))
@trace occurrences!(p)
```
