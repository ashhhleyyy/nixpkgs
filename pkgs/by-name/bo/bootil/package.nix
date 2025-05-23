{
  lib,
  stdenv,
  fetchFromGitHub,
  premake4,
  zlib,
}:

stdenv.mkDerivation {
  pname = "bootil";
  version = "unstable-2019-11-18";

  src = fetchFromGitHub {
    owner = "garrynewman";
    repo = "bootil";
    rev = "beb4cec8ad29533965491b767b177dc549e62d23";
    sha256 = "1njdj6nvmwf7j2fwqbyvd1cf5l52797vk2wnsliylqdzqcjmfpij";
  };

  enableParallelBuilding = true;

  # Avoid guessing where files end up. Just use current directory.
  postPatch = ''
    substituteInPlace projects/premake4.lua \
      --replace-fail 'location ( os.get() .. "/" .. _ACTION )' 'location ( ".." )'
    substituteInPlace projects/bootil.lua \
      --replace-fail 'targetdir ( "../lib/" .. os.get() .. "/" .. _ACTION )' 'targetdir ( ".." )'

    rm src/3rdParty/zlib -rf
    mkdir src/3rdParty/zlib
    cp -r ${zlib.dev}/include/z{conf,lib}.h src/3rdParty/zlib
  '';

  nativeBuildInputs = [ premake4 ];

  premakefile = "projects/premake4.lua";

  installPhase = ''
    install -D libbootil_static.a $out/lib/libbootil_static.a
    cp -r include $out
  '';

  meta = with lib; {
    description = "Garry Newman's personal utility library";
    homepage = "https://github.com/garrynewman/bootil";
    # License unsure - see https://github.com/garrynewman/bootil/issues/21
    license = licenses.free;
    maintainers = with maintainers; [ abigailbuccaneer ];
    # Build uses `-msse` and `-mfpmath=sse`
    platforms = platforms.all;
    badPlatforms = [ "aarch64-linux" ];
  };
}
