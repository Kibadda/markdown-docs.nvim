local M = {}

local config = {
  preview = true,
  command = "xdg-open",
  directory = "$HOME/.cache",
  docs = {},
}

function M.setup(user_config)
  user_config = user_config or {}

  vim.validate {
    config = { user_config, "table" },
  }

  vim.validate {
    preview = { user_config.preview, "boolean", true },
    command = { user_config.command, "string", true },
    directory = { user_config.directory, "string", true },
    docs = { user_config.docs, "table", true },
  }

  for _, doc in ipairs(user_config.docs) do
    if type(doc) == "table" then
      vim.validate {
        name = { doc.name, "string" },
        git_url = { doc.git_url, "string" },
        url = { doc.url, "string" },
        branch = { doc.branch, "string" },
      }
    end
  end

  config = vim.tbl_deep_extend("force", config, user_config)
end

function M.get(key)
  return config[key]
end

return M
