# frozen_string_literal: true

# Definition of the templater formula
class Templater < Formula
  desc "Template processor for env variables"
  homepage "https://webhippie.github.io/templater"
  license "Apache-2.0"

  url "https://github.com/webhippie/templater/archive/v1.0.0.tar.gz"
  sha256 "77392ce115143e8cdab5e7156db1c233397064093f354d94d33705a938980853"
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
