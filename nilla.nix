let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create {
  includes = [
    ./nilla/packages/openfront.nix

    "${pins.nilla-nixos}/modules/nixos.nix"
  ];

  config = {
    inputs = builtins.mapAttrs
      (_name: pin: {
        src = pin;
      })
      pins;
  };
}
