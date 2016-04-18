require "securerandom"

class Mygithub < Formula
  homepage "https://github.com/webhippie/mygithub"
  url "http://dl.webhippie.de/mygithub/latest/mygithub-latest-darwin-amd64"
  sha256 `curl -s http://dl.webhippie.de/mygithub/latest/mygithub-latest-darwin-amd64.sha256`.split(" ").first

  head do
    url "https://github.com/webhippie/mygithub.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  test do
    system "#{bin}/mygithub", "--version"
  end

  def install
    if build.head?
      mygithub_build_home = "/tmp/#{SecureRandom.hex}"
      mygithub_build_path = File.join(mygithub_build_home, "src", "github.com", "webhippie", "mygithub")

      ENV["GOPATH"] = mygithub_build_home
      ENV["GOHOME"] = mygithub_build_home

      mkdir_p mygithub_build_path

      system("cp -R #{buildpath}/* #{mygithub_build_path}")
      ln_s File.join(cached_download, ".git"), File.join(mygithub_build_path, ".git")

      Dir.chdir mygithub_build_path

      system "make", "deps"
      system "make", "build"

      bin.install "#{mygithub_build_path}/bin/mygithub" => "mygithub"
      Dir.chdir buildpath
    else
      bin.install "#{buildpath}/mygithub-latest-darwin-amd64" => "mygithub"
    end
  ensure
    rm_rf mygithub_build_home if build.head?
  end
end
