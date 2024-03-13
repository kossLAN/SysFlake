{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.programs.nvim;
in
{
  options.programs.nvim = {
    enable = lib.mkEnableOption "custom nvim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;

      extraConfig = ''
        autocmd FileType c setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
        autocmd FileType rs setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
        autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
      '';

      extraLuaConfig = ''
        vim.opt.number = true
      '';

      extraPackages = with pkgs; [
        alejandra
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
        {
          type = "lua";
          plugin = noice-nvim;
          config = ''
            require("noice").setup({
               lsp = {
                 override = {
                   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                   ["vim.lsp.util.stylize_markdown"] = true,
                   ["cmp.entry.get_documentation"] = true,
                 },
               },
               presets = {
                 bottom_search = true,
                 command_palette = true,
                 long_message_to_split = true,
                 inc_rename = false,
                 lsp_doc_border = false,
               },
             })
          '';
        }

        # Misc plugins/quality of life
        {
          type = "lua";
          plugin = comment-nvim;
          config = ''
            require('Comment').setup()
          '';
        }

        # Autoformatting
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
                    },
                })

                vim.cmd([[
                augroup FormatAutogroup
                    autocmd!
                    autocmd BufWritePre *.c,*.cpp,*.rs,*.nix,*.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.md,*.html,*.yaml,*.yml,*.lua :lua vim.lsp.buf.format({timeout_ms = 2000})
                augroup END
            ]])
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
              -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
              -- ['<C-Space>'] = cmp.mapping.complete(),
              -- ['<C-e>'] = cmp.mapping.abort(),
              -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            lspconfig.clangd.setup {
              capabilities = capabilities,
              cmd = { "${pkgs.clang-tools}/bin/clangd" },
            }
            lspconfig.rnix.setup {
              capabilities = capabilities,
              cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
            }
            lspconfig.rust_analyzer.setup {
              capabilities = capabilities,
              cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
            }
          '';
        }

        # Treesitter (fuck it we ball)
        nvim-treesitter.withAllGrammars
      ];
    };
  };
}
