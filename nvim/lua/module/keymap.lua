vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
vim.keymap.set("n", "gf", function()
  cfile = vim.fn.expand('<cfile>')
  if string.sub(cfile, 1, 2) == './' or string.sub(cfile, 1, 3) == '../' then
    cfile = vim.fn.expand('%:p:h') .. '/' .. cfile
  end

  return ':e ' .. cfile .. '<cr>'
end, { expr = true })

vim.cmd("cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))")
vim.cmd("cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))")
vim.cmd("cnoreabbrev <expr> X ((getcmdtype() is# ':' && getcmdline() is# 'X')?('x'):('X'))")

vim.keymap.set("n", "<leader>64", function()
  local current_line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local begin = col
  local ending = col

  -- Read to left
  for i = col + 1, 1, -1 do
    local c = current_line:sub(i, i)
    if not c:find('^[%u%l%d+/=]$') then
      break
    end
    begin = i
  end

  -- Read to right
  for i = begin, #current_line do
    local c = current_line:sub(i, i)
    if not c:find('^[%u%l%d+/=]$') then
      break
    end
    ending = i
  end

  local b64 = vim.base64.decode(current_line:sub(begin, ending))
  vim.api.nvim_buf_set_text(0, row - 1, begin - 1, row - 1, ending, {})
  vim.api.nvim_buf_set_text(0, row - 1, begin - 1, row - 1, begin - 1, { b64 })
end, { })
