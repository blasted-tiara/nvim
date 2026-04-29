return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = function()
            -- configuration
            require("nvim-treesitter-textobjects").setup {
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        -- ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
                move = {
                    -- whether to set jumps in the jumplist
                    set_jumps = true,
                },
            }

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`

            -- Text objects
            -- Functions
            vim.keymap.set({ "x", "o" }, "af", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end)
            -- Struct-like stuff (enums, structs, classes)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end)
            -- Local scope
            vim.keymap.set({ "x", "o" }, "as", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
            end)
            -- Function arguments
            vim.keymap.set({ "x", "o" }, "aa", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ia", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
            end)
            -- Numbers
            vim.keymap.set({ "x", "o" }, "in", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@number.inner", "textobjects")
            end)

            -- Swapping
            vim.keymap.set("n", "<leader>a", function()
                require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
            end)
            vim.keymap.set("n", "<leader>A", function()
                require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
            end)

            -- Movements
            -- -- Functions
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
            end)

            -- -- Class like constructs
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
            end)

            -- -- Loops
            -- You can also pass a list to group multiple queries.
            vim.keymap.set({ "n", "x", "o" }, "]o", function()
                require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[o", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start({"@loop.inner", "@loop.outer"}, "textobjects")
            end)

            -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
            vim.keymap.set({ "n", "x", "o" }, "]s", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
            end)
        end,
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

