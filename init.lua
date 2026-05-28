require("vim._core.ui2").enable({})

-- Options
vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.winborder = "rounded"
vim.opt.completeopt = "menuone,noinsert,preselect,fuzzy,nosort,preview"
vim.opt.clipboard:append("unnamedplus")
vim.g.clipboard = "win32yank"

-- Define LSP servers to enable
local servers = { "lua_ls", "pyright", "ts_ls", "gopls" }

-- Plugins setup
vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/romus204/tree-sitter-manager.nvim",
    "https://github.com/akinsho/toggleterm.nvim",
})

require("tree-sitter-manager").setup({
    ensure_installed = { "lua", "python", "tsx", "go" },
    auto_install = true,
    highlight = true,
})

require("which-key").setup()

require("gitsigns").setup({ attach_to_untracked = true })

require("toggleterm").setup({
    open_mapping = [[<c-t>]],
    direction = "float",
})

require("mini.pick").setup()
require("mini.completion").setup()
require("mini.pairs").setup()
require("mini.files").setup()
require("mini.cmdline").setup()
require("mini.icons").setup()
require("mini.git").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require('mini.bufremove').setup()
require('mini.comment').setup({
    mappings = {
        comment_line = '<leader>/',
        comment_visual = '<leader>/',
    },
})

vim.cmd.colorscheme("tokyonight-night")

-- Keymaps
vim.keymap.set("n", "<leader>f", ":Pick files<CR>", { desc = "Pick files by name" })
vim.keymap.set("n", "<leader>h", ":Pick help<CR>", { desc = "Pick help doc" })
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>", { desc = "Grep word in workspace" })
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>", { desc = "Pick buffers by name" })

vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })

vim.keymap.set('n', '<leader>x', function()
    require('mini.bufremove').delete(0, false)
end, { desc = 'Close current buffer' })
vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })

-- LSP
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

require("mason").setup()

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "fm", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "mpv" } },
        },
    },
})
