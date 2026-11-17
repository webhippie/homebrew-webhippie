# frozen_string_literal: true

# Definition of the errors formula
class Errors < Formula
  desc "Default backend for Kubernetes Ingress"
  homepage "https://webhippie.github.io/errors"
  license "Apache-2.0"

  url "https://github.com/webhippie/errors/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "c0bf435504b7fb1d7a23de823f423c867f31bb945ee55dcaee6a16e93cd17fb6"
  head "https://github.com/webhippie/errors.git", branch: "master"

  test do
    system bin / "errors", "--version"
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
    bin.install "bin/errors"

    FileUtils.touch("errors.conf")
    etc.install "errors.conf"
  end

  def post_install
    (var / "errors").mkpath
  end

  service do
    run [opt_bin / "errors", "server"]
    environment_variables ERRORS_ENV_FILE: etc / "errors.conf"
    keep_alive true
    log_path var / "log/errors.log"
    error_log_path var / "log/errors.log"
  end
end
