{
  pkgs,
  username,
  homeDirectory,
  ...
}: let
  shellAliases = {
    open = "xdg-open";
    ga = "git add";
    gc = "git commit";
    gca = "git commit --amend";
    gcn = "git commit --no-verify";
    gcp = "git cherry-pick";
    gf = "git fetch";
    gl = "git log --oneline --no-abbrev-commit";
    glg = "git log --graph";
    gpl = "git pull";
    gps = "git push";
    gr = "git rebase";
    gri = "git rebase -i";
    grc = "git rebase --continue";
    gm = "git merge";
    gs = "git status";
    gsh = "git stash";
    gsw = "git switch";
    gco = "git checkout";
    gcb = "git checkout -b";
    gundo = "git reset HEAD~1 --soft";
    du = "dust";
    cat = "bat";
    find = "fd";
    grep = "rg";
    man = "tldr";
    top = "bottom";
    cd = "z";
    bg = "pueue";
    optpng = "oxipng";
    firefox-dev = "firefox -start-debugger-server 6000 -P dev http://localhost:3000";
    chromium-dev = "chromium --remote-debugging-port=9220";
  };
in {
  imports = [./git.nix ./vscode.nix];
  programs = {
    home-manager.enable = true;
    gh.enable = true;
    bat.enable = true;
    tealdeer.enable = true;
    bottom.enable = true;

    nushell = {
      enable = true;
      inherit shellAliases;
      configFile.source = ./config.nu;
      environmentVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
        PYTHONSTARTUP = "${homeDirectory}/.pystartup";
        NIXOS_OZONE_WL = "1";
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        GRANTED_ALIAS_CONFIGURED = "\"true\"";
        XDG_DATA_DIRS = builtins.concatStringsSep ":" [
          "${homeDirectory}/.nix-profile/share"
          "${homeDirectory}/.local/share/flatpak/exports/share"
          "($env.XDG_DATA_DIRS)"
        ];
        # XR
        XR_RUNTIME_JSON = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
        XRT_COMPOSITOR_FORCE_XCB = "1";
        XRT_COMPOSITOR_XCB_FULLSCREEN = "1";
      };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      initExtra = ''
        export SHELL="${pkgs.bash}/bin/bash"
      '';
      historyControl = ["ignoredups" "erasedups"];
    };

    readline = {
      enable = true;
      extraConfig = ''
        "\e[A":history-search-backward
        "\e[B":history-search-forward
        set completion-ignore-case On
        set completion-prefix-display-length 2
      '';
    };

    zellij = {
      enable = true;
      settings = {
        copy_command = "wl-copy";
        session_serialization = false;
        pane_frames = false;
        env = {
          TERM = "tmux-256color";
        };
      };
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      settings = {
        command_timeout = 10000;
        time = {
          disabled = false;
          format = " [$time]($style) ";
        };
        directory = {
          truncation_length = 8;
          truncation_symbol = ".../";
          truncate_to_repo = false;
        };
      };
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };

    nix-index = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };

    ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/socket/%r@%h:%p";
      controlPersist = "120";
      forwardAgent = true;
      matchBlocks = {
        localhost = {
          hostname = "localhost";
          user = username;
        };
        macbook-x64 = {
          hostname = "10.0.20.137";
          user = "noverby";
        };
      };
    };

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg.enableGnomeExtensions = true;
      };
      nativeMessagingHosts = [pkgs.firefoxpwa];
      profiles = rec {
        default = {
          isDefault = true;
          userChrome = builtins.readFile ./userChrome.css;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
        dev =
          default
          // {
            id = 1;
            isDefault = false;
          };
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-3d-effect
      ];
    };
  };
}
