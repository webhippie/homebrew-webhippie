# frozen_string_literal: true

# Definition of the mygithub formula
class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://webhippie.github.io/mygithub"
  license "Apache-2.0"

  url "https://github.com/webhippie/mygithub/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7e91071cf4a3d73ad93d83a994428348a6f8c8ead1cd5991c48eb8cd383851f9"
  head "https://github.com/webhippie/mygithub.git", branch: "master"

  test do
    system bin / "mygithub", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["SHA"] = "undefined"
    ENV["VERSION"] = url.split("/").last.gsub(".tar.gz", "").gsub("v", "")

    if build.head?
      ENV["VERSION"] = Utils.git_short_head(length: 8)
    end

    system "make", "generate", "build"
    bin.install "bin/mygithub"
  end
end
