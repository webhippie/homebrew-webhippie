# frozen_string_literal: true

# Definition of the cursecli formula
class Cursecli < Formula
  desc "Commandline client for Curseforge"
  homepage "https://webhippie.github.io/cursecli"
  license "Apache-2.0"

  url "https://github.com/webhippie/cursecli/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "c92d768256d723403f86f7dfa8477d819b7dba9ae942fb1f99f2b844ea7f19f0"
  head "https://github.com/webhippie/cursecli.git", branch: "master"

  test do
    system bin / "cursecli", "--version"
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
    bin.install "bin/cursecli"
  end
end
