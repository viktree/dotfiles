{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "vikster";
    homeDirectory = "/home/vikster";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.03";

    packages = with pkgs; [
      aria2
      bat
      direnv
      exa
      fd
      gotop
      neofetch
      neovim
      niv
      nixfmt
      ripgrep
      ripgrep-all
      yadm
    ];

    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
    };
  };

  services = {
    lorri.enable = true;
  };

  programs = {
    git = {
      enable = true;
      userName = "Vikram Venkataramanan";
      userEmail = "vikram.venkataramanan@mail.utoronto.ca";
      extraConfig.pull.rebase = true;
      aliases = {
        cm = "commit";
        ls = "status -s";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    # zsh = {
    #   enable = true;
    #   dotDir = ".config/zsh";
    #   enableAutosuggestions = true;
    #   enableCompletion = true;
    #   shellAliases = {
    #     cat = "bat --paging=never";
    #   };
    #   history = {
    #     expireDuplicatesFirst = true;
    #     ignoreDups = true;
    #   };
    # };
  };

}
