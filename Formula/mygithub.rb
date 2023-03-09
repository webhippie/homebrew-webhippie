# frozen_string_literal: true

# Definition of the mygithub formula
class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://webhippie.github.io/mygithub"
  license "Apache-2.0"

  version "1.0.0"
  url "https://github.com/webhippie/mygithub.git",
      tag: "v1.0.0",
      revision: "2af2923799b6af0bb871440b39594f3aaf32cbb4"

  head "https://github.com/webhippie/mygithub.git", branch: "master"

  test do
    system bin / "mygithub", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
    bin.install "bin/mygithub"
  end
end
