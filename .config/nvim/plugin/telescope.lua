
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader><Space>', builtin.find_files, {desc = 'Find Files'})
vim.keymap.set('n', '<leader>fh', builtin.keymaps, {desc = 'Help Key'})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {desc = 'Recient Files'})
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {desc = 'Buffer Search'})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, {desc = 'Color Scheme'})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {desc = 'Git Files'})
vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, {desc = 'Spell'})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {desc = 'Search Word'})
vim.keymap.set('n', '<leader>fG', require('telescope.builtin').live_grep, {desc = 'Grep Search'})
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, {desc = 'Diagnostics'})

