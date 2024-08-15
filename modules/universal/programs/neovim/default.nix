{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.neovim;
in {
  options.programs.neovim = {
    defaults.enable = mkEnableOption "Enable neovim opioninated defaults";
  };

  config = mkIf cfg.defaults.enable {
    home-manager.users.${config.users.defaultUser} = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimdiffAlias = true;

        extraConfig = ''
          autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
          autocmd FileType qml setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
          autocmd FileType * setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
        '';

        extraLuaConfig = ''
          vim.opt.number = true

          -- Restore cursor position
          vim.api.nvim_create_autocmd({ "BufReadPost" }, {
            pattern = { "*" },
            callback = function()
              vim.api.nvim_exec('silent! normal! g`"zv', false)
            end,
          })

          -- Exit terminal mode, the default binding is way to aids imo
          vim.api.nvim_set_keymap('t', '<C-Space>', [[<C-\><C-n>]], { noremap = true, silent = true })
        '';

        extraPackages = with pkgs; [
          alejandra
          clang-tools
          ripgrep
          black
          nodePackages.prettier
        ];

        plugins = [
          # Visual
          {
            type = "lua";
            plugin = pkgs.vimPlugins.kanagawa-nvim;
            config = ''
              vim.cmd("colorscheme kanagawa")
            '';
          }
          {
            #TODO: Theme lualine properly
            type = "lua";
            plugin = pkgs.vimPlugins.lualine-nvim;
            config = ''
              require('lualine').setup()
            '';
          }

          # Misc plugins/quality of life
          pkgs.vimPlugins.vim-qml
          pkgs.vimPlugins.vim-nix
          {
            type = "lua";
            plugin = pkgs.vimPlugins.which-key-nvim;
            config = ''
              -- Increase the loading times of this shitty popup
              vim.opt.timeoutlen = 300

              require("which-key").setup {
                mappings = {
                  { '<leader>c', group = '[C]ode' },
                  { '<leader>d', group = '[D]ocument' },
                  { '<leader>r', group = '[R]ename' },
                  { '<leader>s', group = '[S]earch' },
                  { '<leader>w', group = '[W]orkspace' },
                  { '<leader>t', group = '[T]oggle' },
                },
              }
            '';
          }

          {
            type = "lua";
            plugin = pkgs.vimPlugins.gitsigns-nvim;
            config = ''
              require('gitsigns').setup()
            '';
          }

          # Wilder (command suggestions)
          {
            type = "viml";
            plugin = pkgs.vimPlugins.wilder-nvim;
            config = ''
              call wilder#setup({'modes': [':', '/', '?']})
            '';
          }

          # Telescope
          {
            type = "lua";
            plugin = pkgs.vimPlugins.telescope-nvim;
            config = ''
              local builtin = require('telescope.builtin')
              vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
              vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
              vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
              vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

              require('telescope').setup{
                defaults = {
                  mappings = {
                    i = {
                      ["<C-h>"] = "which_key"
                    }
                  }
                },
              }
            '';
          }

          # Buffer line
          pkgs.vimPlugins.nvim-web-devicons
          {
            type = "lua";
            plugin = pkgs.vimPlugins.bufferline-nvim;
            config = ''
              vim.opt.termguicolors = true
              require("bufferline").setup{
                options = {
                  color_icons = true,
                  show_buffer_icons = true,
                  show_close_icon = true,
                  show_tab_indicators = true,
                }
              }

              vim.api.nvim_set_keymap('n', '<C-Left>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<C-Right>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<C-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
            '';
          }

          # Autoformatting
          pkgs.vimPlugins.vim-clang-format
          {
            type = "lua";
            plugin = pkgs.vimPlugins.null-ls-nvim;
            config = ''
              local null_ls = require("null-ls")

              null_ls.setup({
                sources = {
                  null_ls.builtins.formatting.prettier,
                  null_ls.builtins.formatting.stylua,
                  null_ls.builtins.formatting.clang_format,
                  null_ls.builtins.formatting.alejandra,
                  null_ls.builtins.formatting.black,
                },
              })

              vim.cmd([[
                augroup FormatAutogroup
                    autocmd!
                    autocmd BufWritePre *.c,*.cpp,*.rs,*.py,*.nix,*.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.md,*.html,*.yaml,*.yml,*.lua :lua vim.lsp.buf.format({timeout_ms = 2000})
                augroup END
              ]])
            '';
          }

          # DAP
          {
            type = "lua";
            plugin = pkgs.vimPlugins.nvim-dap;
            config = ''
              vim.api.nvim_set_keymap('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<leader>c', ':lua require"dap".continue()<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<leader>n', ':lua require"dap".step_over()<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<leader>i', ':lua require"dap".step_into()<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<leader>r', ':lua require"dap".repl.open()<CR>', { noremap = true, silent = true })

              local dap = require("dap")
              dap.adapters.gdb = {
                type = "executable",
                command = "${pkgs.gdb}/bin/gdb",
                args = { "-i", "dap" }
              }

              local dap = require("dap")
              dap.configurations.c = {
                {
                  name = "Launch",
                  type = "gdb",
                  request = "launch",
                  program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  stopAtBeginningOfMainSubprogram = false,
                },
              }

              dap.configurations.cpp = {
                {
                  name = "Launch",
                  type = "gdb",
                  request = "launch",
                  program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  stopAtBeginningOfMainSubprogram = false,
                },
              }
            '';
          }

          # Copilot
          {
            type = "lua";
            plugin = pkgs.vimPlugins.CopilotChat-nvim;
            config = ''
              require("CopilotChat").setup {
                debug = true,
              }
            '';
          }
          {
            type = "lua";
            plugin = pkgs.vimPlugins.copilot-cmp;
            config = ''
              require("copilot_cmp").setup()
            '';
          }
          {
            type = "lua";
            plugin = pkgs.vimPlugins.copilot-lua;
            config = ''
              require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                  ["."] = false,
                },
                copilot_node_command = '${pkgs.nodejs}/bin/node',
              })
            '';
          }

          # Autocompletion (nvim-cmp - this is just the github config but setup properly)
          pkgs.vimPlugins.vim-vsnip
          pkgs.vimPlugins.friendly-snippets
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.cmp-treesitter
          pkgs.vimPlugins.cmp-vsnip
          {
            type = "lua";
            plugin = pkgs.vimPlugins.nvim-cmp;
            config = ''
              local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
              end

              local cmp = require'cmp'

              cmp.setup({
                snippet = {
                  -- REQUIRED - you must specify a snippet engine
                  expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                  end,
                },
                window = {
                  -- completion = cmp.config.window.bordered(),
                  -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ["<Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                      fallback()
                    end
                  end),
                }),
                sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'copilot' },
                  { name = 'vsnip' },
                }, {
                  { name = 'buffer' },
                })
              })

              cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                  { name = 'buffer' }
                }
              })

              cmp.setup.cmdline(':', {
                  mapping = cmp.mapping.preset.cmdline(),
                  sources = cmp.config.sources({
                    { name = 'path' }
                  }, {
                    { name = 'cmdline' }
                  }),
                  matching = { disallow_symbol_nonprefix_matching = false }
                })
            '';
          }
          {
            type = "lua";
            plugin = pkgs.vimPlugins.nvim-lspconfig;
            config = ''
               -- LSP Configs
              local lspconfig = require('lspconfig')
              local capabilities = require('cmp_nvim_lsp').default_capabilities()

              -- Why did I put this here?
              vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
              vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

              lspconfig.clangd.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.clang-tools}/bin/clangd" },
              }
              lspconfig.nixd.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.nixd}/bin/nixd" },
              }

              lspconfig.rust_analyzer.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
              }

              lspconfig.pylyzer.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.pyright}/bin/pyright-langserver", "--stdio" },
              }

              lspconfig.html.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
              }

              lspconfig.cssls.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
              }

              lspconfig.tsserver.setup {
                capabilities = capabilities,
                cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
              }
            '';
          }

          # Treesitter (fuck it we ball)
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        ];
      };
    };
  };
}
