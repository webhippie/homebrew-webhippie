# frozen_string_literal: true

# Definition of the medialize formula
class Medialize < Formula
  desc "Sort and filter your photos"
  homepage "https://webhippie.github.io/medialize"
  license "Apache-2.0"

  url "https://github.com/webhippie/medialize/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "8e262fa17c51a57197d976e6480a14bb4da810e1e934e0d990f0dcf644a937d1"
  head "https://github.com/webhippie/medialize.git", branch: "master"

  test do
    system bin / "medialize", "--version"
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
    bin.install "bin/medialize"
  end
end
