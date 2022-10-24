local Job = require "plenary.job"

local config = require "markdown-docs.config"

local M = {}

local generating = {}

function M.get_directory(doc)
  return ("%s/%s"):format(vim.fs.normalize(config.get "directory"), doc)
end

function M.doc_generate(doc, callback)
  local directory = M.get_directory(doc.name)

  if vim.fn.isdirectory(directory) == 0 then
    if not generating[doc.name] then
      generating[doc.name] = true

      Job:new({
        command = "git",
        args = {
          "clone",
          "-q",
          "-b",
          doc.branch,
          doc.git_url,
          directory,
        },
        on_exit = function()
          generating[doc.name] = nil
          if type(callback) == "function" then
            callback(doc)
          end
        end,
      }):start()
    end
  else
    M.doc_update(doc)
  end
end

function M.doc_update(doc)
  local directory = M.get_directory(doc.name)

  local function doc_update(local_doc)
    if not generating[local_doc.name] then
      generating[local_doc.name] = true

      Job:new({
        command = "git",
        args = {
          "pull",
        },
        cwd = directory,
        on_exit = function()
          generating[local_doc.name] = nil
        end,
      }):start()
    end
  end

  if vim.fn.isdirectory(directory) == 1 then
    doc_update(doc)
  else
    M.doc_generate(doc, doc_update)
  end
end

return M
