import Downloads

# Download the bibliography from paperpile public URL
const bibfile = joinpath(docpath, "src", "references.bib")
const paperpile_url = "https://paperpile.com/eb/nimbzsGosN"
if isfile(bibfile)
    rm(bibfile)
end

# This is the actual download of the bibliography. Note that we FORCE the
# download at ever build, so that it is kept up to date (and it's also not
# stored locally).
Downloads.download(paperpile_url, bibfile)

# Cleanup the bibliography file to make DocumenterCitations happy despite their
# refusal to acknowledge modern field names. The people will party like it's
# 1971 and they will like it.
lines = readlines(bibfile)
open(bibfile, "w") do bfile
    for line in lines
        if contains(line, "journaltitle")
            println(bfile, replace(line, "journaltitle" => "journal"))
        elseif contains(line, "date")
            yrmatch = match(r"{(\d{4})", line)
            if !isnothing(yrmatch)
                println(bfile, "year = {$(yrmatch[1])},")
            end
            println(bfile, line)
        else
            println(bfile, line)
        end
    end
end
# Look how they massacred my boy

# This is what we return - the bibliography for the entire package documentation
const bib = CitationBibliography(
    bibfile;
    style = :authoryear,
)