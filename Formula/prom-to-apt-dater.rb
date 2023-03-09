# frozen_string_literal: true

# Definition of the prom-to-apt-dater formula
class PromToAptDater < Formula
  desc "Prometheus targets for APT-Dater"
  homepage "https://webhippie.github.io/prom-to-apt-dater"
  license "Apache-2.0"

  version "1.0.0"
  url "https://github.com/webhippie/prom-to-apt-dater.git",
      tag: "v1.0.0",
      revision: "1e57090c4ab441d760ed09ba2584eb1078b754fc"

  head "https://github.com/webhippie/prom-to-apt-dater.git", branch: "master"

  test do
    system bin / "prom-to-apt-dater", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
    bin.install "bin/prom-to-apt-dater"
  end
end
