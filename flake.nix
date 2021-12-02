{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
  };

  outputs = { self, nixpkgs, hercules-ci-effects }:
    let
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      jekyll = pkgs.jekyll.override { withOptionalDependencies = true; };
    in
    {
      herculesCI = { branch, ... }: {
        onPush.default = {
          outputs = {
            inherit (self.packages.x86_64-linux) blog;

            effects.deploy =
              let
                effects = hercules-ci-effects.lib.withPkgs pkgs;
              in
              effects.runIf (branch != null) (effects.mkEffect {
                name = "deploy";
                inputs = [ pkgs.netlify-cli ];
                secretsMap.netlify = "default-netlify";
                # Team page -> Site -> Site Settings -> Site details -> Site information -> API ID copy button
                # also, Team page -> Site -> Deploys -> Deploy settings -> Build Settings -> Edit Settings -> Stop builds, Save
                NETLIFY_SITE_ID = "5cb1c6bd-83d5-4cd0-be5c-e0a8408a43ce";
                src = self.packages.x86_64-linux.blog;
                effectScript = ''
                  # https://app.netlify.com/user/applications#personal-access-tokens
                  # Personal access tokens -> New access token
                  # hci secret add default-netlify --string authToken <the token>
                  export NETLIFY_AUTH_TOKEN="$(readSecretString netlify .authToken)"

                  netlify deploy --dir=. ${
                    if branch == "master"
                    then "--prod"
                    else "--alias=${lib.escapeShellArg branch}"
                  }
                '';

              });
          };
        };
      };

      packages.x86_64-linux.blog =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          inherit (pkgs) stdenv nodePackages glibcLocales;
        in
        stdenv.mkDerivation {
          name = "blog.hercules-ci.com";

          src = lib.cleanSource ./.;

          nativeBuildInputs = [
            nodePackages.parcel-bundler
            jekyll
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
        };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.blog;

      devShell.x86_64-linux =
        nixpkgs.legacyPackages.x86_64-linux.mkShell {
          nativeBuildInputs = [
            jekyll
            pkgs.netlify-cli
            pkgs.nixpkgs-fmt
          ];
        };
    };
}
