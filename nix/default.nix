self: { pkgs, lib, config, ... }: let
  inherit (lib) mkOption mkIf types;
  inherit (lib.hm.dag) entryAfter;
  inherit (config.home) username homeDirectory;

  cfg = config.dots.tmux;
  dotsDir = "${homeDirectory}/${cfg.directory}";
  xdgConfDir = "${homeDirectory}/.config/tmux";
  repoUrl = "git@github.com:iErik/dots.tmux.git";
in {
  options.dots.tmux = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Tmux Dotfiles module";
    };

    cloneConfig = mkOption {
      type = types.bool;
      default = true;
      description =
        "Whether or not to clone the Dotfiles" +
        "repository to the user's directory";
    };

    directory = mkOption {
      type = types.str;
      default = "Dots/Tmux.dot";
      description =
        "The path of the directory in which to " +
        "store the dotfiles (relative to the " +
        "user's home directory).";
    };

    branch = mkOption {
      type = types.str;
      default = "master";
      description =
        "The branch of the dotfiles repository to be cloned";
    };

    tmuxinator = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Tmuxinator integration";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      tmuxinator.enable = cfg.tmuxinator;
    };

    home.activation.tmuxSetup = mkIf cfg.cloneConfig
      (entryAfter ["writeBoundary"] ''
        export PATH=${pkgs.openssh}/bin:$PATH
        export PATH=${pkgs.git}/bin:$PATH

        eval $(ssh-agent -s)
        ssh-add

        if [ -d "${dotsDir}/.git" ];
        then
          cd ${dotsDir} && git pull origin ${cfg.branch}
        else
          rm -rf ${dotsDir}
          rm -rf ${xdgConfDir}

          git clone ${repoUrl} ${dotsDir}

          chown -R ${username} ${dotsDir}
          find ${dotsDir} -type d -exec chmod 744 {} \;
          find  ${dotsDir} -type f -exec chmod 644 {} \;

          ln -s ${dotsDir} ${xdgConfDir}
        fi

        ssh-agent -k
      '');
  };
}
