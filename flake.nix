{
  description = "homelab";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell/main";
  };
  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = import nixpkgs {inherit system ; };

      # ksops = pkgs.stdenvNoCC.mkDerivation {
      #   name = "ksops";
      #   version = pkgs.kustomize-sops.version;
      #   buildInputs = with pkgs; [ kustomize-sops ];
      #   phases = [ "installPhase" ];
      #   installPhase = ''
      #     mkdir -p $out/lib/viaduct.ai/v1/ksops/
      #     cp ${pkgs.kustomize-sops.outPath }/lib/viaduct.ai/v1/ksops-exec/ksops-exec $out/lib/viaduct.ai/v1/ksops/ksops
      #   '';
      # };

    in {
      #packages.default = ksops;
      devShell = pkgs.mkShell {
        name = "homelab";
        motd = ''
          Hello
        '';
        
        # I'm not sure why 
        shellHook = ''
          export LC_ALL=C.utf8;
          export PATH=$PATH:$PWD/scripts
        '';
          #export PATH=$PATH:${ ksops.outPath }/lib/viaduct.ai/v1/ksops;

        buildInputs = (with pkgs; [
          just
          shellcheck
          
          python311Packages.ansible
          ansible-lint
          
          step-cli
          step-kms-plugin
          step-ca
          sops
          age
          sshpass

          #kubectl
          # python311Packages.lxml
          # libxml2
          # cilium-cli
          # linkerd
          # cmctl
          # hubble
          # fluxcd
          # kubevirt
          # kubernetes-helm
          # kustomize
          # ksops #kustomize-sops
          # kubelogin-oidc
        ]);
      };
      formatter = pkgs.nixpkgs-fmt;
      checks = { };
    });
}
