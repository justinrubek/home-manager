{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.gitu;

in {
  meta.maintainers = [ hm.maintainers.justinrubek ];

  options.programs.gitu = {
    enable =
      mkEnableOption "A TUI Git client inspired by Magit";

    package = mkOption {
      type = types.package;
      default = pkgs.gitu;
      defaultText = "pkgs.gitu";
      description = "The package to use.";
    };

    config = mkOption {
      type = types.either types.path types.lines;
      default = ''
        [style]
        # fg / bg can be either of:
        # - a hex value: "#707070"
        # - an ansi color name: "light blue"
        # - an ansi color index: "255"
        # - "reset" will set the terminal's default foreground / background color.

        # 'mods' can be any combination of (multiple values separated by '|'):
        # "BOLD|DIM|ITALIC|UNDERLINED|SLOW_BLINK|RAPID_BLINK|REVERSED|HIDDEN|CROSSED_OUT"

        # Example style config values:
        # section_header.fg = "#808080"
        # section_header.bg = "light green"
        # section_header.mods = "UNDERLINED|ITALIC"

        section_header.fg = "yellow"
        file_header.fg = "magenta"
        hunk_header.fg = "blue"

        line_added.fg = "green"
        line_removed.fg = "red"
        line_highlight.changed.mods = "BOLD"
        line_highlight.unchanged.mods = "DIM"

        selection_line.mods = "BOLD"
        selection_bar.fg = "blue"
        selection_bar.mods = "DIM"
        # You may want to set `selection_area.bg` to a nice background color.
        # Looks horrible with regular terminal colors, so is therefore not set.
        selection_area.bg = "reset"

        hash.fg = "yellow"
        branch.fg = "green"
        remote.fg = "red"
        tag.fg = "yellow"

        command.fg = "blue"
        command.mods = "BOLD"
        hotkey.fg = "magenta"
      '';
      description = ''
        Config in Toml file format. This is written to
        {file}`$XDG_CONFIG_HOME/gitu/config.toml`.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."gitu/config.toml".source =
      if builtins.isPath cfg.config || lib.isStorePath cfg.config then
        cfg.config
      else
        pkgs.writeText "config.toml" cfg.config;
  };
}
