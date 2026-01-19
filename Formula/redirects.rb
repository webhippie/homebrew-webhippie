# frozen_string_literal: true

# Definition of the redirects formula
class Redirects < Formula
  desc "Simple pattern-based redirect server"
  homepage "https://webhippie.github.io/redirects"
  license "Apache-2.0"

  url "https://github.com/webhippie/redirects/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "1809c1dd5c9938cf8a15c1eed14a6f3a5cfe8bb795827fecf3e30d1e7a2f0a8e"
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
