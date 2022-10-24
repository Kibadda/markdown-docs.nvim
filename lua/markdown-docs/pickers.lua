local telescope_pickers = require "telescope.pickers"
local telescope_finders = require "telescope.finders"
local telescope_conf = require("telescope.config").values
local telescope_actions = require "telescope.actions"
local telescope_action_state = require "telescope.actions.state"

local Job = require "plenary.job"

local finders = require "markdown-docs.finders"
local config = require "markdown-docs.config"

local M = {}

function M.picker(opts)
  opts = opts or {}

  telescope_pickers
    .new(opts, {
      prompt_title = opts.doc.name,
      finder = telescope_finders.new_table {
        results = finders.find_doc_files(opts.doc),
        entry_maker = function(entry)
          return {
            entry = entry,
            display = entry.name,
            ordinal = entry.name,
            path = entry.path,
          }
        end,
      },
      sorter = telescope_conf.generic_sorter(opts),
      previewer = config.get "preview" and telescope_conf.file_previewer {} or nil,
      attach_mappings = function(prompt_bufnr)
        telescope_actions.select_default:replace(function()
          local selection = telescope_action_state.get_selected_entry().entry

          telescope_actions.close(prompt_bufnr)

          Job:new({
            command = config.get "command",
            args = {
              selection.url,
            },
          }):start()
        end)

        return true
      end,
    })
    :find()
end

return M
