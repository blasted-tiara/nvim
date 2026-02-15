vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.lazy')

-- General editor settings
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '●',
            [vim.diagnostic.severity.WARN] = '●',
            [vim.diagnostic.severity.INFO] = '●',
            [vim.diagnostic.severity.HINT] = '●',
        },
    },
})

-- Buffer navigation keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<A-w>", ":bdelete<CR>", opts)


vim.api.nvim_create_user_command('PrintLine', function()
    local line = vim.api.nvim_get_current_line()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local file_name = vim.fn.expand("%:t")

    -- Create the debug log statement that prints the current line
    local debug_line = string.format('console.log("[ENVR | %s:%d] >>> %s");', 
        file_name, line_num, line)

    -- Insert the debug line below current line
    vim.api.nvim_put({debug_line}, 'l', true, true)
end, {})

vim.keymap.set('n', '<leader>pl', ':PrintLine<CR>', { desc = 'Print current line as debug log' })

