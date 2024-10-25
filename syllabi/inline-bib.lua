-- Load bibliography into a table
local bib_entries = {}

function load_bib(bibfile)
    local bibtex = io.open(bibfile, "r")
    if not bibtex then
        error("Could not open bibliography file: " .. bibfile)
    end

    local entry = ""
    local citekey = nil
    for line in bibtex:lines() do
        if line:match("@%a+{") then
            if citekey then
                bib_entries[citekey] = entry
            end
            entry = line
            citekey = line:match("@%a+{([^,]+),")
        elseif citekey then
            entry = entry .. " " .. line
        end
    end
    if citekey then
        bib_entries[citekey] = entry
    end
    bibtex:close()
end

-- Load the bibliography at the start of the document
function Pandoc(doc)
    -- Adjust this path to point to your bibliography file
    local bibfile = "references.bib"
    load_bib(bibfile)
end

-- Replace citation with full bibliography entry inline
function Cite(el)
    local cite_key = el.citations[1].id
    local full_entry = bib_entries[cite_key]
    if full_entry then
        return pandoc.RawInline("html", full_entry)
    else
        return el
    end
end
