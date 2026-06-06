class Cxr < Formula
  desc "A tool to generate a directory structure from a YAML template"
  homepage "https://github.com/suzuuuuu09/cxr"
  url "https://github.com/suzuuuuu09/cxr/releases/download/v0.1.4/cxr-0.1.4.tar.gz"
  sha256 "25fb440c8b699703d724db17bcd59e69ae605133a3749356dc4b80b6494f6ce9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cxr --version")
  end
end
