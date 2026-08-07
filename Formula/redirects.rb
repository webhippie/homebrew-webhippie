# frozen_string_literal: true

# Definition of the redirects formula
class Redirects < Formula
  desc "Simple pattern-based redirect server"
  homepage "https://webhippie.github.io/redirects"
  license "Apache-2.0"

  url "https://github.com/webhippie/redirects/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "82e5eaf7063d374d890266620d5bff6808098ab2c83cc20e57e23760e6e7b1ba"
  head "https://github.com/webhippie/redirects.git", branch: "master"

  test do
    system bin / "redirects", "--version"
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
