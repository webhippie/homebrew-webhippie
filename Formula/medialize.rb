# frozen_string_literal: true

# Definition of the medialize formula
class Medialize < Formula
  desc "Sort and filter your photos"
  homepage "https://webhippie.github.io/medialize"
  license "Apache-2.0"

  version "1.0.0"
  url "https://github.com/webhippie/medialize.git",
      tag: "v1.0.0",
      revision: "0000000000000000000000000000000000000000"

  head "https://github.com/webhippie/medialize.git", branch: "master"

  test do
    system bin / "medialize", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
    bin.install "bin/medialize"
  end
end
