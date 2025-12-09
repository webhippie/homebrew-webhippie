# frozen_string_literal: true

# Definition of the prom-to-apt-dater formula
class PromToAptDater < Formula
  desc "Prometheus targets for APT-Dater"
  homepage "https://webhippie.github.io/prom-to-apt-dater"
  license "Apache-2.0"

  url "https://github.com/webhippie/prom-to-apt-dater/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "aec741bda34fab81f03d896ccb1f51cbb7c4b11a756d9f23a38176978f1a7819"
  head "https://github.com/webhippie/prom-to-apt-dater.git", branch: "master"

  test do
    system bin / "prom-to-apt-dater", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["SHA"] = "undefined"
    ENV["VERSION"] = if build.head?
                       Utils.git_short_head(length: 8)
                     else
                       url.split("/").last.gsub(".tar.gz", "").gsub("v", "")
                     end

    system "make", "generate", "build"
    bin.install "bin/prom-to-apt-dater"
  end
end
