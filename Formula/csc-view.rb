class CscView < Formula
  desc "Salesforce package.xml viewer - displays metadata components in readable formats"
  homepage "https://github.com/mahito1594/changeset-component-viewer"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/mahito1594/changeset-component-viewer/releases/download/v0.1.1/csc-view-aarch64-apple-darwin.tar.xz"
      sha256 "a33717bc7f8ebed02752985398c540c63c7eaf02c7746671cd850755528140ba"
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mahito1594/changeset-component-viewer/releases/download/v0.1.1/csc-view-x86_64-unknown-linux-musl.tar.xz"
      sha256 "97ca85b7e39bfe788dc22965177d6db9bcf0bae0bc1fa9291305ba49315fce29"
  end
  license "Unlicense"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "csc-view" if OS.mac? && Hardware::CPU.arm?
    bin.install "csc-view" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
