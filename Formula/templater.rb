# frozen_string_literal: true

# Definition of the templater formula
class Templater < Formula
  desc "Template processor for env variables"
  homepage "https://webhippie.github.io/templater"
  license "Apache-2.0"

  url "https://github.com/webhippie/templater/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "da2baa4c98848acbc52e1f3ed1bb7da49cafda82c6ddac76656458efae29c0a6"
  head "https://github.com/webhippie/templater.git", branch: "master"

  test do
    system bin / "templater", "--version"
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
    bin.install "bin/templater"
  end
end
