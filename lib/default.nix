{ lib, ... }: with lib; rec {
  # https://reddit.com/r/NixOS/comments/j5pa9o/getting_all_configs_from_folder/

  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir = dir: mapAttrs
    (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
    (builtins.readDir dir);

  # Collects all files of a directory as a list of strings of paths
  files = dir: collect isString
    (mapAttrsRecursive
      (path: type: concatStringsSep "/" path)
      (getDir dir)
    );

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  validFiles = dir: map
    (file: dir + "/${file}")
    (filter
      (file: hasSuffix ".nix" file && file != "default.nix") # filter files that have .nix and arent this file
      (files dir)
    );
}
