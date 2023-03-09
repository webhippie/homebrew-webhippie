# frozen_string_literal: true

# Definition of the templater formula
class Templater < Formula
  desc "Template processor for env variables"
  homepage "https://webhippie.github.io/templater"
  license "Apache-2.0"

  version "1.0.0"
  url "https://github.com/webhippie/templater.git",
      tag: "v1.0.0",
      revision: "bd7248802755359eba462d05f24232dd3272e291"

  head "https://github.com/webhippie/templater.git", branch: "master"

  test do
    system bin / "templater", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
    bin.install "bin/templater"
  end
end
