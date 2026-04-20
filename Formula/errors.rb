# frozen_string_literal: true

# Definition of the errors formula
class Errors < Formula
  desc "Default backend for Kubernetes Ingress"
  homepage "https://webhippie.github.io/errors"
  license "Apache-2.0"

  url "https://github.com/webhippie/errors/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "47128e9d9328770806b4a5f47074edbeb4f1b9c0ca1c1eca7aa339d70a3c1e0e"
  head "https://github.com/webhippie/errors.git", branch: "master"

  test do
    system bin / "errors", "--version"
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
