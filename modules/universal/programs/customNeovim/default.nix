{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.customNeovim;
in {
  options.programs.customNeovim = {
    enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    # nixpkgs = {
    #   config = {
    #     allowBroken = true;
    #     permittedInsecurePackages = ["nix-2.16.2"];
    #   };
    # };

    home-manager.users.${config.users.defaultUser} = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimdiffAlias = true;

        extraConfig = ''
          autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
          autocmd FileType * setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
        '';

        extraLuaConfig = ''
          -- vim.opt.number = true

          -- Restore cursor position
          vim.api.nvim_create_autocmd({ "BufReadPost" }, {
            pattern = { "*" },
            callback = function()
              vim.api.nvim_exec('silent! normal! g`"zv', false)
            end,
          })

          -- Exit terminal mode, the default binding is way to aids imo
          vim.api.nvim_set_keymap('t', '<C-Space>', [[<C-\><C-n>]], { noremap = true, silent = true })


          -- Cheatsheet for custom keybinds
          function print_cheatsheet()
            local cheatsheetContent = [[
              === Custom Neovim Keybindings ===
              ## General Keybindings ##
              <C-Space>           Exit terminal mode (<C-\\><C-n>)

              ## Buffer Navigation ##
              <Tab>               Cycle forward through buffers (:BufferLineCycleNext)
              <S-Tab>             Cycle backward through buffers (:BufferLineCyclePrev)

              ## Telescope Plugin ##
              <leader>ff          Find files (telescope.builtin.find_files)
              <leader>fg          Live grep (telescope.builtin.live_grep)
              <leader>fb          Buffers (telescope.builtin.buffers)
              <leader>fh          Help tags (telescope.builtin.help_tags)
              <C-h>               Show telescope mappings in insert mode (actions.which_key)

              ## DAP (Debugger) Plugin ##
              <leader>b           Toggle breakpoint (require'dap'.toggle_breakpoint())
              <leader>c           Continue execution (require'dap'.continue())
              <leader>n           Step over (require'dap'.step_over())
              <leader>i           Step into (require'dap'.step_into())
              <leader>r           Open REPL (require'dap'.repl.open())

              ## Completion (nvim-cmp Plugin) ##
              <C-p>               Select previous item (cmp.mapping.select_prev_item())
              <C-n>               Select next item (cmp.mapping.select_next_item())
              <C-b>               Scroll documentation up (cmp.mapping.scroll_docs(-4))
              <C-f>               Scroll documentation down (cmp.mapping.scroll_docs(4))
              <C-Space>           Trigger completion (cmp.mapping.complete())
              <C-e>               Abort completion (cmp.mapping.abort())
              <CR>                Confirm selection (cmp.mapping.confirm({ select = true }))

              ## LSP (Language Server Protocol) Keybindings ##
              gD                  Go to declaration (vim.lsp.buf.declaration())
              gd                  Go to definition (vim.lsp.buf.definition())

            ]]
            print(cheatsheetContent)
          end

          -- Register the command ':cheatsheet' to print the cheatsheet
          vim.cmd('command! Cheatsheet lua print_cheatsheet()')

          -- Optionally bind the command to a keymap
          vim.api.nvim_set_keymap('n', '<leader>cs', ':Cheatsheet<CR>', { noremap = true, silent = true })

        '';

        extraPackages = with pkgs; [
          alejandra
          clang-tools
          ripgrep
          black
        ];

        plugins = with pkgs.vimPlugins; [
          # Visual
          {
            type = "lua";
            plugin = oxocarbon-nvim;
            config = ''
              vim.opt.background = "dark"
              vim.cmd("colorscheme oxocarbon")
              -- TODO: find a better full black theme.
              vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
              vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            '';
          }
          {
            #TODO: Theme lualine properly
            type = "lua";
            plugin = lualine-nvim;
            config = ''
              require('lualine').setup()
            '';
          }

          # Don't really care about this, but will keep it here in case
          # {
          #   type = "lua";
          #   plugin = noice-nvim;
          #   config = ''
          #     require("noice").setup({
          #        lsp = {
          #          override = {
          #            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          #            ["vim.lsp.util.stylize_markdown"] = true,
          #            ["cmp.entry.get_documentation"] = true,
          #          },
          #        },
          #        presets = {
          #          bottom_search = true,
          #          command_palette = true,
          #          long_message_to_split = true,
          #          inc_rename = false,
          #          lsp_doc_border = false,
          #        },
          #      })
          #   '';
          # }

          # Misc plugins/quality of life
          vim-qml
          vim-nix

          # Easy comment management
          {
            type = "lua";
            plugin = comment-nvim;
            config = ''
              require('Comment').setup()
            '';
          }

          # Wilder (command suggestions)
          {
            type = "viml";
            plugin = wilder-nvim;
            config = ''
              call wilder#setup({'modes': [':', '/', '?']})
            '';
          }

          # Telescope
          {
            type = "lua";
            plugin = telescope-nvim;
            config = ''
              local builtin = require('telescope.builtin')
              vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
              vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
              vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
              vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

              require('telescope').setup{
                defaults = {
                  -- Default configuration for telescope goes here:
                  -- config_key = value,
                  mappings = {
                    i = {
                      -- map actions.which_key to <C-h> (default: <C-/>)
                      -- actions.which_key shows the mappings for your picker,
                      -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                      ["<C-h>"] = "which_key"
                    }
                  }
                },
                pickers = {
                  -- Default configuration for builtin pickers goes here:
                  -- picker_name = {
                  --   picker_config_key = value,
                  --   ...
                  -- }
                  -- Now the picker_config_key will be applied every time you call this
                  -- builtin picker
                },
                extensions = {
                  -- Your extension configuration goes here:
                  -- extension_name = {
                  --   extension_config_key = value,
                  -- }
                  -- please take a look at the readme of the extension you want to configure
                }
              }
            '';
          }

          # Buffer line
          nvim-web-devicons
          {
            type = "lua";
            plugin = bufferline-nvim;
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

              vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
              vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
            '';
          }

          # Autoformatting
          vim-clang-format
          {
            type = "lua";
            plugin = null-ls-nvim;
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
            plugin = nvim-dap;
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

          # Autocompletion (nvim-cmp - this is just the github config but setup properly)
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          cmp-treesitter
          luasnip
          {
            type = "lua";
            plugin = nvim-cmp;
            config = ''
              local cmp = require'cmp'
              local lspconfig = require('lspconfig')

              cmp.setup({
              snippet = {
                expand = function(args)
                  require('luasnip').lsp_expand(args.body)
                end,
              },
              window = {
                documentation = cmp.config.window.bordered(),
              },
              mapping = {
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              },
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
              }, {
                { name = 'buffer' },
                })
              })

              -- Set configuration for specific filetype.
              cmp.setup.buffer({
                sources = cmp.config.sources({
                  { name = 'git' },
                }, {
                  { name = 'buffer' },
                })
              })

              -- Use buffer source for '/' and '?'.
              cmp.setup.cmdline({
                sources = {
                  { name = 'buffer' }
                }
              })

              -- Use cmdline & path source for ':'.
              cmp.setup.cmdline({
                sources = cmp.config.sources({
                  { name = 'path' }
                }, {
                  { name = 'cmdline' }
                })
              })

              -- LSP Configs
              local capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities(),
                -- File watching is disabled by default for neovim.
                -- See: https://github.com/neovim/neovim/pull/22405
                { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
              );

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
            '';
          }

          # Treesitter (fuck it we ball)
          nvim-treesitter.withAllGrammars
        ];
      };
    };
  };
}
