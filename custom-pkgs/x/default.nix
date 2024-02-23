{ pkgs ? import <nixpkgs> { } }: pkgs.stdenv.mkDerivation {
  name = "x";

  src = ./x.rs;
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [ rustc ];

  buildPhase = ''
    rustc -Copt-level=3 -Cembed-bitcode=false $src --out-dir $out/bin
  '';

  meta = with pkgs.lib; {
    description = "Helper for rust-lang/rust x.py";
    homepage = "https://github.com/rust-lang/rust/blob/master/src/tools/x";
    license = licenses.mit;
    mainProgram = "x";
  };
}
