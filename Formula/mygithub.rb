# frozen_string_literal: true

# Definition of the mygithub formula
class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://webhippie.github.io/mygithub"
  license "Apache-2.0"

  url "https://github.com/webhippie/mygithub/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "edb86bb41e6a81fe6bda039131774e0e066a2eed7c8d1f9bcf78532f8f34d3bd"
  head "https://github.com/webhippie/mygithub.git", branch: "master"

  test do
    system bin / "mygithub", "--version"
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
    bin.install "bin/mygithub"
  end
end
