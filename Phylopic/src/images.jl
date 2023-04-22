
function images(; filter_license_by=false, filter_license_nc=false, filter_license_sa=false, filter_name="")
    query_parameters = ""
    if filter_license_by
        query_parameters *= "filter_license_by=$(filter_license_by)"
    end
    if filter_license_nc
        query_parameters *= "filter_license_nc=$(filter_license_nc)"
    end
    if filter_license_sa
        query_parameters *= "filter_license_sa=$(filter_license_sa)"
    end
    if ~isempty(filter_name)
        query_parameters *= "filter_name=$(lowercase(filter_name))"
    end
    req = HTTP.get(Phylopic.api * "images?" * replace(query_parameters, " " => "%20"))
    if isequal(200)(req.status)
        @info JSON.parse(String(req.body))
    end
end

