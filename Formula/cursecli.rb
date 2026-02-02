# frozen_string_literal: true

# Definition of the cursecli formula
class Cursecli < Formula
  desc "Commandline client for Curseforge"
  homepage "https://webhippie.github.io/cursecli"
  license "Apache-2.0"

  url "https://github.com/webhippie/cursecli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "85a93448a40190193593ff1a0d68ebc2aa7f68bd55941cd6ec646a1375d0a24d"
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
