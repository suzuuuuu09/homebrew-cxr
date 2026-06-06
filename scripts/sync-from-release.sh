#!/usr/bin/env bash
set -euo pipefail

repo="suzuuuuu09/cxr"
root_dir="$(cd "$(dirname "$0")/.." && pwd)"
version="$(gh api "repos/${repo}/releases/latest" --jq '.tag_name | sub("^v"; "")')"
asset_name="cxr-${version}.tar.gz"
asset_url="$(gh api "repos/${repo}/releases/latest" --jq ".assets[] | select(.name == \"${asset_name}\") | .browser_download_url")"
sha256="$(gh api "repos/${repo}/releases/latest" --jq ".assets[] | select(.name == \"${asset_name}\") | .digest | sub(\"^sha256:\"; \"\")")"

if [ -z "${asset_url}" ] || [ "${asset_url}" = "null" ]; then
  echo "missing asset: ${asset_name}" >&2
  exit 1
fi

cat > "${root_dir}/Formula/cxr.rb" <<EOF
class Cxr < Formula
  desc "A tool to generate a directory structure from a YAML template"
  homepage "https://github.com/suzuuuuu09/cxr"
  url "${asset_url}"
  sha256 "${sha256}"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cxr --version")
  end
end
EOF

printf 'version=%q\nsha256=%q\n' "${version}" "${sha256}"
