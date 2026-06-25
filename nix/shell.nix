{ pkgs }:

{
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nim
      nimble

      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
    ];
  };
}
