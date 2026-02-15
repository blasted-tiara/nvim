return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- LSP on_attach function for document highlighting
            -- LSP keybindings setup via LspAttach autocmd
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf
                    local opts = { buffer = bufnr, noremap = true, silent = true }

                    -- Essential LSP keybindings
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

                    -- Document highlighting if supported
                    if client and client.server_capabilities.documentHighlightProvider then
                        local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = bufnr,
                            group = group,
                            callback = function()
                                vim.lsp.buf.document_highlight()
                            end,
                        })

                        vim.api.nvim_create_autocmd("CursorMoved", {
                            buffer = bufnr,
                            group = group,
                            callback = function()
                                vim.lsp.buf.clear_references()
                            end,
                        })

                        vim.api.nvim_create_autocmd("BufLeave", {
                            buffer = bufnr,
                            group = group,
                            callback = function()
                                vim.lsp.buf.clear_references()
                            end,
                        })
                    end
                end,
            })

            vim.lsp.config("lua_ls", {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                            return
                        end
                    end

                    local library = { vim.env.VIMRUNTIME }
                    -- Check if nvim is run from ~/.config/nvim.
                    -- If yes, then also add plugin autocompletes.
                    -- This is conditional because it takes hell of a long time to load.
                    if vim.fn.getcwd() == vim.fn.stdpath("config") then
                        local lazy_path = vim.fn.stdpath("data") .. "/lazy"
                        table.insert(library, lazy_path)
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most
                            -- likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Tell the language server how to find Lua modules same way as Neovim
                            -- (see `:h lua-module-load`)
                            path = {
                                'lua/?.lua',
                                'lua/?/init.lua',
                            },
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = library,
                            -- Or pull in all of 'runtimepath'.
                            -- NOTE: this is a lot slower and will cause issues when working on
                            -- your own configuration.
                            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                            -- library = vim.api.nvim_get_runtime_file('', true),
                        },
                    })
                end,
                settings = {
                    Lua = {
                    },
                },
            })
            vim.lsp.enable('lua_ls')

            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            allTargets = true,
                        },
                        cargo = {
                            allTargets = true,
                            -- target = "all",
                            target = "wasm32-unknown-unknown",
                        },
                    },
                },
            })
            vim.lsp.enable('rust_analyzer')
        end,
    },
}
