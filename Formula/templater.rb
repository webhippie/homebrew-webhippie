# frozen_string_literal: true

# Definition of the templater formula
class Templater < Formula
  desc "Template processor for env variables"
  homepage "https://webhippie.github.io/templater"
  license "Apache-2.0"

  url "https://github.com/webhippie/templater/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "6bb1e9cfb1894b9770aa77264179260eb16097df8d0bef78ba6aa29efe98c22b"
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
