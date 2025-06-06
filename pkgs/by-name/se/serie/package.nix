{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-JTrXsakXsDuEzRs7y3OgdvfWw8vvF1IvajHi7KueoPI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+5mUMB4rqLePimfgWlV7UP8B1lPoKzfWCXBBN1q2WIU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = with lib; {
    description = "A rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
