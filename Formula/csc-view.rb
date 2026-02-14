class CscView < Formula
  desc "Salesforce package.xml viewer - displays metadata components in readable formats"
  homepage "https://github.com/mahito1594/changeset-component-viewer"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/mahito1594/changeset-component-viewer/releases/download/v0.1.2/csc-view-aarch64-apple-darwin.tar.xz"
      sha256 "fd934d6a359defcc1baaf54a7d38f468ca44121701a73bdb530c2bc0cdaff6d2"
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mahito1594/changeset-component-viewer/releases/download/v0.1.2/csc-view-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b828ba8bb49d23d1e3343991641d0975b739afd566e73b032155b29358582a97"
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
