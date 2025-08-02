{ stdenv, fetchurl, openssl_1_1, zlib, autoPatchelfHook, lib, libgcc }:
let
  hostname = "binaries.prisma.sh";
  release = "2.16.x/latest/debian-openssl-1.1.x";
  baseUrl = "https://${hostname}/${release}/";
  hashes = {
    introspection-engine =
      "07zsnrrzq8123rjha5680v4vwwn80jxib5j8f3hn8dw54y7hq60b";
    migration-engine = "0a6xrwb27bcb9dh4y2yalhny6vhdwrdqhk2y4kmrjy3pr2z38f21";
    prisma-fmt = "0c11i0bm35ssapmp92y72wbff1rh7dx511hfkbx3d5y0yqnmhv6l";
    query-engine = "05hi8ks3rwxws8pw0391zf2h41p5hj6ggpbg01wcidby8j1r11fh";
  };
  files = lib.mapAttrs (name: sha256:
    fetchurl {
      url = "${baseUrl}${name}.gz";
      inherit sha256;
    }) hashes;
  unzipCommands =
    lib.mapAttrsToList (name: file: "gunzip -c ${file} > $out/bin/${name}")
    files;
in stdenv.mkDerivation rec {
  pname = "prisma-bin";
  version = "2.1.x";
  # Use openssl_1_1 to match the required libssl.so.1.1 and libcrypto.so.1.1
  # Add libgcc to nativeBuildInputs to resolve libgcc_s.so.1
  # autoPatchelfHook needs access to these dependencies during the build
  nativeBuildInputs = [ autoPatchelfHook zlib openssl_1_1 libgcc ];
  # The build process is simple: unzip and set permissions
  phases = [ "buildPhase" "postFixupHooks" ];
  buildPhase = ''
    mkdir -p $out/bin
    ${lib.concatStringsSep "\n" unzipCommands}
    chmod +x $out/bin/*
  '';
}
