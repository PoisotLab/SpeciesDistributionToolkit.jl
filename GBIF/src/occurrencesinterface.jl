function OccurrencesInterface.entity(record::GBIFRecord)
    return record.taxon.name
end

function OccurrencesInterface.place(record::GBIFRecord)
    if ismissing(record.longitude) | ismissing(record.latitude)
        return missing
    end
    return (record.longitude, record.latitude)
end

function OccurrencesInterface.date(record::GBIFRecord)
    if ismissing(record.date)
        return missing
    end
    return record.date
end

function OccurrencesInterface.presence(record::GBIFRecord)
    return record.presence
end

function OccurrencesInterface.elements(records::GBIFRecords)
    return collect(GBIFRecord, records)
end
