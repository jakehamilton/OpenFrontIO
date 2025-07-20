{
  config.packages.openfront = {
    systems = [ "x86_64-linux" ];

    package = { lib, buildNpmPackage, importNpmLock, nodejs, pkg-config, pixman, cairo, pango, cloudflared, makeWrapper, ... }:
      let
        src = ../..;
      in
      buildNpmPackage {
        pname = "openfront";
        version = "unstable";

        inherit src;
        inherit nodejs;

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

          makeWrapper ${lib.getExe nodejs} $out/bin/openfront \
            --prefix PATH : ${lib.makeBinPath [ cloudflared ]} \
            --prefix NODE_PATH : "$out/libexec/openfront/node_modules" \
            --add-flags "--loader ts-node/esm" \
            --add-flags "--experimental-specifier-resolution=node" \
            --add-flags "$out/libexec/openfront/src/server/Server.ts"
        '';
      };
  };
}
