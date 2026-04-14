# frozen_string_literal: true

# Definition of the mygithub formula
class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://webhippie.github.io/mygithub"
  license "Apache-2.0"

  url "https://github.com/webhippie/mygithub/archive/refs/tags/v11.2.1.tar.gz"
  sha256 "1d931031f88eddb2eb248a5dd4c1337481969bf6ff5edce5aa510808de7b8e6b"
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
