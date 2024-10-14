Tables.istable(::Type{Occurrences}) = true
Tables.rowaccess(::Type{Occurrences}) = true
Tables.rows(occ::Occurrences) = elements(occ)
