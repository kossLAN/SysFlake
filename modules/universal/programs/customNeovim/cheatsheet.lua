-- Define the cheatsheet content
local cheatsheet = {
    ["General Keybindings"] = {
        ["<C-Space>"] = "Exit terminal mode (<C-\\><C-n>)",
    },
    ["Buffer Navigation"] = {
        ["<Tab>"] = "Cycle forward through buffers (:BufferLineCycleNext)",
        ["<S-Tab>"] = "Cycle backward through buffers (:BufferLineCyclePrev)",
    },
    ["Telescope Plugin"] = {
        ["<leader>ff"] = "Find files (telescope.builtin.find_files)",
        ["<leader>fg"] = "Live grep (telescope.builtin.live_grep)",
        ["<leader>fb"] = "Buffers (telescope.builtin.buffers)",
        ["<leader>fh"] = "Help tags (telescope.builtin.help_tags)",
        ["<C-h>"] = "Show telescope mappings in insert mode (actions.which_key)",
    },
    ["DAP (Debugger) Plugin"] = {
        ["<leader>b"] = "Toggle breakpoint (require'dap'.toggle_breakpoint())",
        ["<leader>c"] = "Continue execution (require'dap'.continue())",
        ["<leader>n"] = "Step over (require'dap'.step_over())",
        ["<leader>i"] = "Step into (require'dap'.step_into())",
        ["<leader>r"] = "Open REPL (require'dap'.repl.open())",
    },
    ["Completion (nvim-cmp Plugin)"] = {
        ["<C-p>"] = "Select previous item (cmp.mapping.select_prev_item())",
        ["<C-n>"] = "Select next item (cmp.mapping.select_next_item())",
        ["<C-b>"] = "Scroll documentation up (cmp.mapping.scroll_docs(-4))",
        ["<C-f>"] = "Scroll documentation down (cmp.mapping.scroll_docs(4))",
        ["<C-Space>"] = "Trigger completion (cmp.mapping.complete())",
        ["<C-e>"] = "Abort completion (cmp.mapping.abort())",
        ["<CR>"] = "Confirm selection (cmp.mapping.confirm({ select = true }))",
    },
    ["LSP (Language Server Protocol) Keybindings"] = {
        ["gD"] = "Go to declaration (vim.lsp.buf.declaration())",
        ["gd"] = "Go to definition (vim.lsp.buf.definition())",
    },
}

-- Function to print the cheatsheet
local function print_cheatsheet()
    print("=== Custom Neovim Keybindings ===")
    for category, bindings in pairs(cheatsheet) do
        print(string.format("## %s ##", category))
        for key, description in pairs(bindings) do
            print(string.format("%-20s %s", key, description))
        end
        print("")  -- empty line for readability
    end
end

-- Register the command ':cheatsheet' to print the cheatsheet
vim.cmd([[command! Cheatsheet lua require('cheatsheet').print_cheatsheet()]])

-- Return the module with the print_cheatsheet function
return {
    print_cheatsheet = print_cheatsheet
}
