{ pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    userSettings = {
      # Note: In settings.json, `.` in a key is not equivalent to a nested object property.
      "[nix]"."editor.formatOnSave" = true;
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${lib.getExe pkgs.nil}";
      "nix.serverSettings" = {
        nil = {
          formatting = {
            command = [ "${lib.getExe pkgs.nixpkgs-fmt}" ];
          };
        };
      };
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "window.zoomLevel" = 1;
      "terminal.integrated.enableMultiLinePasteWarning" = false;
      "git.confirmSync" = false;
      "debug.allowBreakpointsEverywhere" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      bmalehorn.vscode-fish
      dbaeumer.vscode-eslint
      eamodio.gitlens
      esbenp.prettier-vscode
      github.vscode-github-actions
      jnoortheen.nix-ide
      mads-hartmann.bash-ide-vscode
      ms-azuretools.vscode-docker
      # the server fails to build temporarily
      # https://github.com/NixOS/nixpkgs/issues/263493
      # ms-python.python
      ms-vscode-remote.remote-ssh
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.hexeditor
      nvarner.typst-lsp
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      usernamehw.errorlens
      vadimcn.vscode-lldb
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "dtsvet";
        name = "vscode-wasm";
        version = "1.4.1";
        sha256 = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
      }
      {
        publisher = "redhat";
        name = "ansible";
        version = "2.7.98";
        sha256 = "sha256-b3Z40IeQbtYci2LA4/OlJkfqMB78cWRNTNWd89lfhy4=";
      }
      {
        publisher = "matthewpi";
        name = "caddyfile-support";
        version = "0.3.0";
        sha256 = "sha256-1yiOnvC2w33kiPRdQYskee38Cid/GOj9becLadP1fUY=";
      }
    ] ++ [
      (pkgs.vscode-utils.buildVscodeExtension {
        name = "riverdelta";
        version = "0.1.0";
        src = builtins.fetchGit {
          url = "https://github.com/Nilstrieb/riverdelta";
          rev = "64d81b56084d9a7663517b367b4533fb8ea83a92";
        };
        vscodeExtPublisher = "Nilstrieb";
        vscodeExtName = "riverdelta";
        vscodeExtUniqueId = "Nilstrieb.riverdelta";
        buildPhase = ''
          runHook preBuild;
          cd ./vscode
          runHook postBuild;
        '';
      })
    ];
  };
}
