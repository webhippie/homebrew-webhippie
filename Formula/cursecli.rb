# frozen_string_literal: true

# Definition of the cursecli formula
class Cursecli < Formula
  desc "Commandline client for Curseforge"
  homepage "https://webhippie.github.io/cursecli"
  license "Apache-2.0"

  url "https://github.com/webhippie/cursecli/archive/refs/tags/v2.8.6.tar.gz"
  sha256 "7d3e040dcb4f7aef9086c61a04dd2a945d87aa7c76737fa6399e1dffa2697119"
  head "https://github.com/webhippie/cursecli.git", branch: "master"

  test do
    system bin / "cursecli", "--version"
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
    bin.install "bin/cursecli"
  end
end
