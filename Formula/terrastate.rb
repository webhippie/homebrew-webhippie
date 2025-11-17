# frozen_string_literal: true

# Definition of the terrastate formula
class Terrastate < Formula
  desc "Terraform HTTP remote state storage"
  homepage "https://webhippie.github.io/terrastate"
  license "Apache-2.0"

  url "https://github.com/webhippie/terrastate/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a6694c9a9ff999c8f41b6825c9cd3d5fbd2a155256452088e03d6f6a2f198b32"
  head "https://github.com/webhippie/terrastate.git", branch: "master"

  test do
    system bin / "terrastate", "--version"
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
