{
  description = "A very basic flake";
  inputs = {
    home-manager.url = "github:rycee/home-manager";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
  };
}
