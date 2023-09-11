
local builtin = require('telescope.builtin')

-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader><Space>', builtin.find_files, {})
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ft', function()
	builtin.grep_string()
end)

vim.keymap.set('n', '<leader>fh', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, {})


