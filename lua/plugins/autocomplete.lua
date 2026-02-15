return {
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",    -- LSP completions
            "hrsh7th/cmp-buffer",      -- buffer completions
            "hrsh7th/cmp-path",        -- file path completions
            "saadparwaiz1/cmp_luasnip",-- snippet completions
            "L3MON4D3/LuaSnip",        -- snippet engine
            "rafamadriz/friendly-snippets", -- common snippets
        },
        opts = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            local defaults = require("cmp.config.default")()
            local auto_select = true
            local kind_icons = {
                Array         = " ",
                Boolean       = "󰨙 ",
                Class         = " ",
                Codeium       = "󰘦 ",
                Color         = " ",
                Control       = " ",
                Collapsed     = " ",
                Constant      = "󰏿 ",
                Constructor   = " ",
                Copilot       = " ",
                Enum          = " ",
                EnumMember    = " ",
                Event         = " ",
                Field         = " ",
                File          = " ",
                Folder        = " ",
                Function      = "󰊕 ",
                Interface     = " ",
                Key           = " ",
                Keyword       = " ",
                Method        = "󰊕 ",
                Module        = " ",
                Namespace     = "󰦮 ",
                Null          = " ",
                Number        = "󰎠 ",
                Object        = " ",
                Operator      = " ",
                Package       = " ",
                Property      = " ",
                Reference     = " ",
                Snippet       = "󱄽 ",
                String        = " ",
                Struct        = "󰆼 ",
                Supermaven    = " ",
                TabNine       = "󰏚 ",
                Text          = " ",
                TypeParameter = " ",
                Unit          = " ",
                Value         = " ",
                Variable      = "󰀫 ",
            }

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                },
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select == true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }, {
                        { name = "buffer" },
                    }),
                formatting = {
                    format = function(_, item)
                        if kind_icons[item.kind] then
                            item.kind = kind_icons[item.kind] .. item.kind
                        end

                        local widths = {
                            abbr = 40,
                            menu = 30,
                        }

                        for key, width in pairs(widths) do
                            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                            end
                        end

                        return item
                    end,
                },
                sorting = defaults.sorting,
            }
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            local rep = require("luasnip.extras").rep
            
            -- Snippet for logging a js/ts variable
            local function create_var_log_js_snippet()
                return s("varlog", {
                    t('console.log("[ENVR] >>> '),
                    i(1, "variable"),
                    t(' = ", JSON.stringify('),
                    rep(1),
                    t('));')
                })
            end
            ls.add_snippets("typescript", { create_var_log_js_snippet() })
            ls.add_snippets("typescriptreact", { create_var_log_js_snippet() })
            ls.add_snippets("javascript", { create_var_log_js_snippet() })

            -- Snippet for logging a rust variable
            local function create_var_log_rust_snippet()
                return s("varlog", {
                    t('log::info!("[ENVR] >>> '),
                    i(1, "variable"),
                    t(' = {}", '),
                    rep(1),
                    t(');')
                })
            end
            ls.add_snippets("rust", { create_var_log_rust_snippet() })

            -- Snippet for logging js/ts text
            local function create_log_js_snippet()
                return s("envlog", {
                    t('console.log("[ENVR] >>> '),
                    i(1, "text"),
                    t('");')
                })
            end
            ls.add_snippets("typescript", { create_log_js_snippet() })
            ls.add_snippets("typescriptreact", { create_log_js_snippet() })
            ls.add_snippets("javascript", { create_log_js_snippet() })

            -- Snippet for logging rust text
            local function create_log_rust_snippet()
                return s("envlog", {
                    t('log::info!("[ENVR] >>> '),
                    i(1, "text"),
                    t('");')
                })
            end
            ls.add_snippets("rust", { create_log_rust_snippet() })


            -- Snippet for comment
            local function create_env_comment_snippet()
                return s("envcomm", {
                    t('// [ENVR]: '),
                })
            end

            ls.add_snippets("typescript", { create_env_comment_snippet() })
            ls.add_snippets("typescriptreact", { create_env_comment_snippet() })
            ls.add_snippets("javascript", { create_env_comment_snippet() })
            ls.add_snippets("rust", { create_env_comment_snippet() })

            -- Snippet for note
            local function create_env_note_snippet()
                return s("envnote", {
                    t('// NOTE [ENVR]: '),
                })
            end

            ls.add_snippets("typescript", { create_env_note_snippet() })
            ls.add_snippets("typescriptreact", { create_env_note_snippet() })
            ls.add_snippets("javascript", { create_env_note_snippet() })
            ls.add_snippets("rust", { create_env_note_snippet() })
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    }
}
