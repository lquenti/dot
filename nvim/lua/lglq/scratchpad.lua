-- Note: This is *fully* vibe coded, have barely read it.
-- Persistent floating scratchpad using native file handling
local M = {}

local scratch_bufnr = nil
local scratch_winid = nil
local scratch_path = vim.fn.expand("~/.buf.txt")

function M.toggle()
  -- If open: save and close
  if scratch_winid and vim.api.nvim_win_is_valid(scratch_winid) then
    vim.api.nvim_win_close(scratch_winid, true)
    scratch_winid = nil
    return
  end

  -- Create or load buffer
  if not scratch_bufnr or not vim.api.nvim_buf_is_valid(scratch_bufnr) then
    scratch_bufnr = vim.fn.bufadd(scratch_path)
    vim.fn.bufload(scratch_bufnr)
    vim.api.nvim_buf_set_option(scratch_bufnr, 'filetype', 'text')
    vim.api.nvim_buf_set_option(scratch_bufnr, 'bufhidden', 'hide')
  end

  -- Floating window layout
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
end

return M

