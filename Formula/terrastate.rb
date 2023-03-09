# frozen_string_literal: true

# Definition of the terrastate formula
class Terrastate < Formula
  desc "Terraform HTTP remote state storage"
  homepage "https://webhippie.github.io/terrastate"
  license "Apache-2.0"

  version "1.0.1"
  url "https://github.com/webhippie/terrastate.git",
      tag: "v1.0.1",
      revision: "021bf5048957fbc5da4d89e738b6bfd91c6b6d8e"

  head "https://github.com/webhippie/terrastate.git", branch: "master"

  test do
    system bin / "terrastate", "--version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = 0
    ENV["TAGS"] = ""

    system "make", "generate", "build"
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
