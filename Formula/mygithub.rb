# frozen_string_literal: true

# Definition of the mygithub formula
class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://webhippie.github.io/mygithub"
  license "Apache-2.0"

  url "https://github.com/webhippie/mygithub/archive/refs/tags/v19.0.4.tar.gz"
  sha256 "fda06f91178331b122044716a315e5109371e381b2a0e1d943cf7e9c6500e7d1"
  head "https://github.com/webhippie/mygithub.git", branch: "master"

  test do
    system bin / "mygithub", "--version"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["SHA"] = "undefined"
    ENV["VERSION"] = if build.head?
                       Utils.git_short_head(length: 8)
                     else
                       url.split("/").last.gsub(".tar.gz", "").gsub("v", "")
                     end

    system "task", "generate", "build"
    bin.install "bin/mygithub"
  end
end
