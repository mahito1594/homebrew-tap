class SfPkgen < Formula
  desc "Interactive Salesforce package.xml generator"
  homepage "https://github.com/mahito1594/sf-pkgen-rs"
  version "1.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/mahito1594/sf-pkgen-rs/releases/download/v1.1.2/sf-pkgen-aarch64-apple-darwin.tar.xz"
    sha256 "be7855c6f719a8f7948106f27a68372cfad18ff4c16a95a19f635404884efc69"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mahito1594/sf-pkgen-rs/releases/download/v1.1.2/sf-pkgen-x86_64-unknown-linux-musl.tar.xz"
    sha256 "5eec9a92cde2604407a5f664c43c603fbb5dc0aa82473e86bbdac071ed40815b"
  end
  license "MIT"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sf-pkgen"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sf-pkgen"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
