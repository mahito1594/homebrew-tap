class SfPkgen < Formula
  desc "Interactive Salesforce package.xml generator"
  homepage "https://github.com/mahito1594/sf-pkgen-rs"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/mahito1594/sf-pkgen-rs/releases/download/v1.1.0/sf-pkgen-aarch64-apple-darwin.tar.xz"
    sha256 "a7044b6a6f90acf40e9763812509aa3609f434a6a7422eec9ecc654faf557fcd"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mahito1594/sf-pkgen-rs/releases/download/v1.1.0/sf-pkgen-x86_64-unknown-linux-musl.tar.xz"
    sha256 "cf562cb3f25de3d8d36b7e4c86937d1633f4260f15d4bb10695cd601161f47f4"
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
    bin.install "sf-pkgen" if OS.mac? && Hardware::CPU.arm?
    bin.install "sf-pkgen" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
