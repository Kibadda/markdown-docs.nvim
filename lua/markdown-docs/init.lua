local config = require "markdown-docs.config"
-- local pickers = require "markdown-docs.pickers"
-- local util = require "markdown-docs.util"

local M = {}

function M.setup(opts)
  config.setup(opts)
end

-- function M.debug()
--   local doc = config.get("docs")[1]
--   util.doc_generate(doc, function()
--     pickers.picker {
--       doc = config.get("docs")[1],
--     }
--   end)
-- end

return M
