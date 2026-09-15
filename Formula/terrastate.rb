# frozen_string_literal: true

# Definition of the terrastate formula
class Terrastate < Formula
  desc "Terraform HTTP remote state storage"
  homepage "https://webhippie.github.io/terrastate"
  license "Apache-2.0"

  url "https://github.com/webhippie/terrastate/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "726b8a15bfa0bf2b39af4135ae36ff85680d3349bc79f7f69fb5d4100a1431c3"
  head "https://github.com/webhippie/terrastate.git", branch: "master"

  test do
    system bin / "terrastate", "--version"
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
    bin.install "bin/terrastate"

    FileUtils.touch("terrastate.conf")
    etc.install "terrastate.conf"
  end

  def post_install
    (var / "terrastate").mkpath
  end

  service do
    run [opt_bin / "terrastate", "server"]
    environment_variables TERRASTATE_ENV_FILE: etc / "terrastate.conf"
    keep_alive true
    log_path var / "log/terrastate.log"
    error_log_path var / "log/terrastate.log"
  end
end
