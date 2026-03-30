# frozen_string_literal: true

# Definition of the templater formula
class Templater < Formula
  desc "Template processor for env variables"
  homepage "https://webhippie.github.io/templater"
  license "Apache-2.0"

  url "https://github.com/webhippie/templater/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "7ce5e3abba0d35e3c428b9ebabd2ed4a2476918caa9902243a0edeb714e8c699"
  head "https://github.com/webhippie/templater.git", branch: "master"

  test do
    system bin / "templater", "--version"
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
    bin.install "bin/templater"
  end
end
