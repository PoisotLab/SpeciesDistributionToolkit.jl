Tables.istable(::Type{GBIFRecords}) = true
Tables.rowaccess(::Type{GBIFRecords}) = true
Tables.rows(records::GBIFRecords) = view(records)
