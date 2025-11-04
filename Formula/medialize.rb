# frozen_string_literal: true

# Definition of the medialize formula
class Medialize < Formula
  desc "Sort and filter your photos"
  homepage "https://webhippie.github.io/medialize"
  license "Apache-2.0"

  url "https://github.com/webhippie/medialize/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "772e5fd687511ca6fdb1aae0fc25163ae757c97601e61b42a80f107533ec5a88"
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
