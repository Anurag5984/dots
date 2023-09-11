require("staline").setup {
	sections = {
		left = {
			'▊', '', { '' }, '',
			{ 'StalineFile', 'file_name' }, ''
		},
		-- mid = {},
		mid = {
      -- { '  ', 'lsp_name' },
    },
		right = {
			{ 'StalineEnc', vim.bo.fileencoding:upper() }, '  ',  -- Example for custom section
      { 'StalineGit', 'lsp_name' },
			-- { 'StalineEnc', 'cool_symbol' }, ' ',                 -- the cool_symbol for your OS
			{ 'StalineGit', 'branch' }, ' ', '▊'                  -- Branch Name in different highlight
		}
	},
	defaults = {
		-- bg = "#202328",
		branch_symbol = " "
	},
	mode_colors = {
		n = "#38b1f0",
		i = "#9ece6a",       -- etc mode
	}
}
vim.cmd [[hi StalineEnc  guifg=#7d9955 ]]       -- Encoding Highlight
vim.cmd [[hi StalineGit  guifg=#8583b3 ]]       -- Branch Name Highlight
vim.cmd [[hi StalineFile guifg=#afafff ]]       -- File name Highlight

