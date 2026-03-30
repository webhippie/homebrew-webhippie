# frozen_string_literal: true

# Definition of the prom-to-apt-dater formula
class PromToAptDater < Formula
  desc "Prometheus targets for APT-Dater"
  homepage "https://webhippie.github.io/prom-to-apt-dater"
  license "Apache-2.0"

  url "https://github.com/webhippie/prom-to-apt-dater/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "b9bf97ff63ffe3f80faa6eecfff3640b106078f0f8f3cb6a547e02700af7932a"
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
