local M = {}

---@class Options
---@field next_file_key string|nil example: "<M-i>"
---@field prev_file_key string|nil example: "<M-o>"
---@field max_history number|nil default: 100
---@field remove_duplicates boolean|nil default: false

---@type table<number, string[]>
local history_per_window = {}

---@type table<number, number>
local position_per_window = {}

---@type Options
local config = {}

---@return string[], number
local function get_history_and_position()
  local window_id = vim.api.nvim_get_current_win()
  local history = history_per_window[window_id] or {}
  local position = position_per_window[window_id] or 0

  return history, position
end

local function update_history()
  local window_id = vim.api.nvim_get_current_win()
  local history, position = get_history_and_position()

  local path = vim.fn.expand("%:p")
  if not vim.startswith(path, "/") then
    return
  end

  if history[position] == path then
    return
  end

  -- Truncate history if it exceeds the max_history
  local max_history = config.max_history or 100
  if #history >= max_history then
    for _ = 1, #history - max_history + 1 do
      table.remove(history, 1)
    end
  end

  -- Remove all entries after the current position
  for _ = position + 1, #history do
    table.remove(history, position + 1)
  end

  --- Remove duplicates if enabled
  if config.remove_duplicates then
    for i = #history, 1, -1 do
      if history[i] == path then
        table.remove(history, i)
      end
    end
  end

  --- Insert the new path
  table.insert(history, path)

  --- Update the history and position
  history_per_window[window_id] = history
  position_per_window[window_id] = #history
end

function M.next_file()
  local history, position = get_history_and_position()
  local window_id = vim.api.nvim_get_current_win()

  if position < #history then
    position_per_window[window_id] = position + 1
    M.stop_observing()
    vim.cmd(string.format("e %s", history[position + 1]))
    M.observe()
  end
end

function M.prev_file()
  local history, position = get_history_and_position()
  local window_id = vim.api.nvim_get_current_win()

  if position > 1 then
    position_per_window[window_id] = position - 1
    M.stop_observing()
    vim.cmd(string.format("e %s", history[position - 1]))
    M.observe()
  end
end

function M.stop_observing()
  vim.api.nvim_del_augroup_by_name("filenav.nvim")
end

function M.observe()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = vim.api.nvim_create_augroup("filenav.nvim", { clear = true }),
    pattern = "*",
    callback = update_history,
  })
end

---@param opts Options|nil
function M.setup(opts)
  config = opts or {}
  M.observe()

  if config.next_file_key then
    vim.api.nvim_set_keymap("n", config.next_file_key, "", {
      noremap = true,
      silent = true,
      callback = M.next_file,
    })
  end

  if config.prev_file_key then
    vim.api.nvim_set_keymap("n", config.prev_file_key, "", {
      noremap = true,
      silent = true,
      callback = M.prev_file,
    })
  end

  vim.api.nvim_create_user_command("FilenavNext", M.next_file, { nargs = 0 })
  vim.api.nvim_create_user_command("FilenavPrev", M.prev_file, { nargs = 0 })
end

return M
