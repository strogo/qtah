Nix expressions are provided to ease building Qtah within
[Nixpkgs](https://nixos.org/nixpkgs).  Qtah can be inserted into Nixpkgs with
the following overrides, after updating `qtahDir` as appropriate for your
environment.  Hoppy must already be at `haskellPackages.hoppy`; if it's not,
follow the similar setup instructions for Hoppy.

    packageOverrides = let qtahDir = /my/projects/qtah.git; in pkgs: rec {
      qtah-cpp = pkgs.callPackage (qtahDir + /qtah/cpp) {
        inherit (haskellPackages) qtah-generator;
      };

      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: {
          qtah-generator = self.callPackage (qtahDir + /qtah-generator) {};
          qtah = self.callPackage (qtahDir + /qtah/hs) {};
          qtah-examples = self.callPackage (qtahDir + /qtah-examples) {};
        };
      };

The Haskell packages accept two optional parameters.  `enableSplitObjs`, when
non-null, will override Nixpkgs's default behaivour for Cabal, and the boolean
`forceParallelBuilding` will force a parallel build for faster development, at
the risk of nondeterministic results (see
[Nixpkgs bug 3220](https://github.com/NixOS/nixpkgs/issues/3220)).

---

This file is part of Qtah.

Copyright 2015 Bryan Gardiner <bog@khumba.net>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License version 3
as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.