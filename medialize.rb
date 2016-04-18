require "securerandom"

class Medialize < Formula
  homepage "https://github.com/webhippie/medialize"
  url "http://dl.webhippie.de/medialize/latest/medialize-latest-darwin-amd64"
  sha256 `curl -s http://dl.webhippie.de/medialize/latest/medialize-latest-darwin-amd64.sha256`.split(" ").first

  head do
    url "https://github.com/webhippie/medialize.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/medialize", "--version"
  end

  def install
    if build.head?
      medialize_build_home = "/tmp/#{SecureRandom.hex}"
      medialize_build_path = File.join(medialize_build_home, "src", "github.com", "webhippie", "medialize")

      ENV["GOPATH"] = medialize_build_home
      ENV["GOHOME"] = medialize_build_home

      mkdir_p medialize_build_path

      system("cp -R #{buildpath}/* #{medialize_build_path}")
      ln_s File.join(cached_download, ".git"), File.join(medialize_build_path, ".git")

      Dir.chdir medialize_build_path

      system "make", "deps"
      system "make", "build"

      bin.install "#{medialize_build_path}/bin/medialize" => "medialize"
      Dir.chdir buildpath
    else
      bin.install "#{buildpath}/medialize-latest-darwin-amd64" => "medialize"
    end
  ensure
    rm_rf medialize_build_home if build.head?
  end
end
