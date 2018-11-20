{ pkgs ? import ./nixpkgs.nix
}:

with pkgs;

stdenv.mkDerivation {
  name = "blog.hercules-ci.com";

  src = ./.;

  buildInputs = [
    nodePackages.parcel-bundler
    (jekyll.override { withOptionalDependencies = true; })
    glibcLocales
  ];

  LANG = "en_US.utf8";

  buildPhase = ''
    jekyll build
  '';

  installPhase = ''
    mkdir -p $out
    cp -R _site/* $out
  '';
}
