{
  config.packages.openfront = {
    systems = [ "x86_64-linux" ];

    package = { lib, buildNpmPackage, importNpmLock, nodejs, pkg-config, pixman, cairo, pango, cloudflared, bash, makeWrapper, ... }:
      let
        src = ../..;
      in
      buildNpmPackage {
        pname = "openfront";
        version = "unstable";

        inherit src;
        inherit nodejs;

        meta = {
          mainProgram = "openfront";
        };

        GIT_COMMIT = "unstable";

        npmDeps = importNpmLock {
          npmRoot = src;
        };

        npmConfigHook = importNpmLock.npmConfigHook;

        nativeBuildInputs = [
          pkg-config
          makeWrapper
        ];

        buildInputs = [
          pixman
          cairo
          pango
          cloudflared
        ];

        installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/libexec/openfront

          cp -r . $out/libexec/openfront

          makeWrapper ${nodejs}/bin/npm $out/bin/openfront \
            --chdir "$out/libexec/openfront" \
            --prefix PATH : ${lib.makeBinPath [ cloudflared bash nodejs ]} \
            --prefix NODE_PATH : "$out/libexec/openfront/node_modules" \
            --add-flags "run start:server" \
        '';
      };
  };
}
