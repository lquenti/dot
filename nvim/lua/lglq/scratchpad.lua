-- Note: This is *fully* vibe coded, have barely read it.
local M = {}

local scratch_bufnr = nil
local scratch_winid = nil
local scratch_path = vim.fn.expand("~/.buf.txt")

local function read_file(path)
  local lines = {}
  local f = io.open(path, "r")
  if f then
    for line in f:lines() do
      table.insert(lines, line)
    end
    f:close()
  end
  return lines
end

local function write_file(bufnr, path)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local f = io.open(path, "w")
  if f then
    for _, line in ipairs(lines) do
      f:write(line .. "\n")
    end
    f:close()
  end
end

function M.toggle()
  if scratch_winid and vim.api.nvim_win_is_valid(scratch_winid) then
    write_file(scratch_bufnr, scratch_path)
    vim.api.nvim_win_close(scratch_winid, true)
    scratch_winid = nil
    return
  end

  if not scratch_bufnr or not vim.api.nvim_buf_is_valid(scratch_bufnr) then
    scratch_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(scratch_bufnr, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(scratch_bufnr, 'filetype', 'markdown')
    vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, false, read_file(scratch_path))
  end

  local height = math.floor(vim.o.lines * 0.3)
  local width = math.floor(vim.o.columns * 0.9)

  scratch_winid = vim.api.nvim_open_win(scratch_bufnr, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = vim.o.lines - height - 2,
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
  })

  vim.cmd('startinsert')
end

return M

