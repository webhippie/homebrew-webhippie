# frozen_string_literal: true

# Definition of the redirects formula
class Redirects < Formula
  desc "Simple pattern-based redirect server"
  homepage "https://webhippie.github.io/redirects"
  license "Apache-2.0"

  url "https://github.com/webhippie/redirects/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "6a0d3532999ec242ed8455c26e0d23a16386e62d3cf5050c7778b3e3540cd068"
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
