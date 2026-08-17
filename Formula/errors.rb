# frozen_string_literal: true

# Definition of the errors formula
class Errors < Formula
  desc "Default backend for Kubernetes Ingress"
  homepage "https://webhippie.github.io/errors"
  license "Apache-2.0"

  url "https://github.com/webhippie/errors/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "0fddcfb3c31af6d8705425594ed56503afec9ac26f7488f85874941ed89a602b"
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
