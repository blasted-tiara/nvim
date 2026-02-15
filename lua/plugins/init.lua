return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim"
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
            -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>") -- Live grep with args
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
            vim.keymap.set("n", "<leader>fr", function()
                require("telescope.builtin").lsp_references()
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>fp", function()
                require("telescope.builtin").planets({
                    show_pluto = true,
                    show_moon = true,
                })
            end, { desc = "Telescope help tags" })

            local telescope = require("telescope")
            local lga_actions = require("telescope-live-grep-args.actions")
            local actions = require("telescope.actions")

            telescope.setup {
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                ["<A-W>"] = actions.delete_buffer,
                            },
                            n = {
                                ["<A-W>"] = actions.delete_buffer,
                            }
                        }
                    },
                },
                extensions = {
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --iglob '*.ts'" }),
                                ["<C-s>"] = lga_actions.quote_prompt({ postfix = " --iglob '*.ts' --iglob '!**/*.spec.ts'" }),
                                ["<C-r>"] = lga_actions.quote_prompt({ postfix = " --iglob '*.rs'" }),
                                ["<C-x>"] = lga_actions.quote_prompt({ postfix = " --iglob '*.tsx'" }),
                                ["<C-space>"] = lga_actions.to_fuzzy_refine,
                            }
                        },
                    }
                }
            }

            -- Load the extension
            telescope.load_extension("live_grep_args")
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 25,
                    side = "left",
                    preserve_window_proportions = true,
                },
                renderer = {
                    group_empty = true
                },
                filters = {
                    dotfiles = false
                },
                git = {
                    enable = true
                },
            })
            vim.keymap.set("n", "<leader>re", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>rr", ":NvimTreeFocus<CR>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>rf", ":NvimTreeFindFile<CR>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>rc", ":NvimTreeCollapse<CR>", {noremap = true, silent = true})
        end,
    },
    -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        }
    },
    {
        'tpope/vim-sleuth',
        event = 'VeryLazy'
    },
    {
        "rmagatti/auto-session",
        lazy = false,

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            -- log_level = 'debug',
        },
    }
}

