# frozen_string_literal: true

# Definition of the cursecli formula
class Cursecli < Formula
  desc "Commandline client for Curseforge"
  homepage "https://webhippie.github.io/cursecli"
  license "Apache-2.0"

  version "1.1.1"
  url "https://github.com/webhippie/cursecli.git",
      tag: "v1.1.1",
      revision: "cc69b052e4d24cee86cd9c0914147cb0b493f23d"

  head "https://github.com/webhippie/cursecli.git", branch: "master"

  test do
    system bin / "cursecli", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
    bin.install "bin/cursecli"
  end
end
