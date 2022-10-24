local util = require "markdown-docs.util"

local M = {}

function M.find_doc_files(doc)
  local directory = util.get_directory(doc.name)

  local results = {}

  local files = vim.fs.find(function(file)
    return string.match(file, ".md$") ~= nil
  end, {
    path = directory,
    type = "file",
    limit = math.huge,
  })

  for _, file in ipairs(files) do
    local slug = vim.split(vim.fn.fnamemodify(file, ":t"), ".", { plain = true })[1]

    local split = vim.split(slug, "-", { plain = true })
    for i, part in ipairs(split) do
      split[i] = string.gsub(part, "^%l", string.upper)
    end

    table.insert(results, {
      slug = slug,
      name = table.concat(split, " "),
      path = file,
      url = ("%s/%s"):format(doc.url, slug),
    })
  end

  return results
end

return M
