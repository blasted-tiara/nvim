return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
            "theHamsta/nvim-dap-virtual-text",
        },
        -- Keymaps live here
        keys = {
            -- If you're using which-key.nvim, this "group" entry is handled by which-key,
            -- but lazy.nvim will just treat it as a key spec entry.
            { "<leader>d",  group = "Debugger" },

            { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
            { "<leader>di", function() require("dap").step_into() end,         desc = "Step Into" },
            { "<leader>do", function() require("dap").step_over() end,         desc = "Step Over" },
            { "<leader>du", function() require("dap").step_out() end,          desc = "Step Out" },
            { "<leader>dr", function() require("dap").repl.open() end,         desc = "Open REPL" },
            { "<leader>dl", function() require("dap").run_last() end,          desc = "Run Last" },

            {
                "<leader>dq",
                function()
                    require("dap").terminate()
                    require("dapui").close()
                    require("nvim-dap-virtual-text").toggle()
                end,
                desc = "Terminate",
            },

            { "<leader>db", function() require("dap").list_breakpoints() end, desc = "List Breakpoints" },
            { "<leader>de", function() require("dap").set_exception_breakpoints({ "all" }) end, desc = "Set Exception Breakpoints" },
        },
        config = function()
            local mason_dap = require("mason-nvim-dap")
            local dap = require("dap")
            local ui = require("dapui")
            local dap_virtual_text = require("nvim-dap-virtual-text")

            -- Dap Virtual Text
            dap_virtual_text.setup({})

            mason_dap.setup({
                ensure_installed = { "codelldb", "cpptools" },
                automatic_installation = true,
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })

            -- Configurations
            dap.configurations = {
                rust = {
                    {
                        -- For now, this only works for a project named debug_test.
                        -- Create it with: cargo new debug_test
                        -- Then build it with cargo build - it builds with debug symbols by default_setup
                        -- Next, open nvim in the debug_test directory, place a breakpoint with <leader>+dt
                        -- And then start the debug session with <leader>+dc.
                        -- To step over lines, use <leader>+do

                        name = "hello-world",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.getcwd() .. "/target/debug/debug_test"
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                    },
                },
            }

            -- Dap UI

            ui.setup()

            vim.fn.sign_define("DapBreakpoint", { text = "🐞" })


            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end
    },
}
