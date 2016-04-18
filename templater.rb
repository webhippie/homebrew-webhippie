require "securerandom"

class SolderApi < Formula
  homepage "https://github.com/webhippie/templater"
  url "http://dl.webhippie.de/templater/latest/templater-latest-darwin-amd64"
  sha256 `curl -s http://dl.webhippie.de/templater/latest/templater-latest-darwin-amd64.sha256`.split(" ").first

  head do
    url "https://github.com/webhippie/templater.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/templater", "--version"
  end

  def install
    if build.head?
      templater_build_home = "/tmp/#{SecureRandom.hex}"
      templater_build_path = File.join(templater_build_home, "src", "github.com", "webhippie", "templater")

      ENV["GOPATH"] = templater_build_home
      ENV["GOHOME"] = templater_build_home

      mkdir_p templater_build_path

      system("cp -R #{buildpath}/* #{templater_build_path}")
      ln_s File.join(cached_download, ".git"), File.join(templater_build_path, ".git")

      Dir.chdir templater_build_path

      system "make", "deps"
      system "make", "build"

      bin.install "#{templater_build_path}/bin/templater" => "templater"
      Dir.chdir buildpath
    else
      bin.install "#{buildpath}/templater-latest-darwin-amd64" => "templater"
    end
  ensure
    rm_rf templater_build_home if build.head?
  end
end
