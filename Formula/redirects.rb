# frozen_string_literal: true

# Definition of the redirects formula
class Redirects < Formula
  desc "Simple pattern-based redirect server"
  homepage "https://webhippie.github.io/redirects"
  license "Apache-2.0"

  url "https://github.com/webhippie/redirects/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3435c85725f0f9a984861446353d3f443d6fd21b5dfd80883ed27a73de6774db"
  head "https://github.com/webhippie/redirects.git", branch: "master"

  test do
    system bin / "redirects", "--version"
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
    bin.install "bin/redirects"

    FileUtils.touch("redirects.conf")
    etc.install "redirects.conf"
  end

  def post_install
    (var / "redirects").mkpath
  end

  service do
    run [opt_bin / "redirects", "server"]
    environment_variables REDIRECTS_ENV_FILE: etc / "redirects.conf"
    keep_alive true
    log_path var / "log/redirects.log"
    error_log_path var / "log/redirects.log"
  end
end
