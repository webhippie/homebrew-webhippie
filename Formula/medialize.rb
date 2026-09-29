# frozen_string_literal: true

# Definition of the medialize formula
class Medialize < Formula
  desc "Sort and filter your photos"
  homepage "https://webhippie.github.io/medialize"
  license "Apache-2.0"

  url "https://github.com/webhippie/medialize/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "b11db183fa03bfbb0e56c71d3586905520146ec9ce28ebb8c58acb4ca7b5968b"
  head "https://github.com/webhippie/medialize.git", branch: "master"

  test do
    system bin / "medialize", "--version"
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
    bin.install "bin/medialize"
  end
end
