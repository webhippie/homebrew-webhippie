require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Mygithub < Formula
  desc "some tiny github client utilities for daily work"
  homepage "https://github.com/webhippie/mygithub"

  head do
    url "https://github.com/webhippie/mygithub.git", :branch => "master"
    depends_on "go" => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/misc/mygithub/1.0.0/mygithub-1.0.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/misc/mygithub/1.0.0/mygithub-1.0.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "1.0.0"
  # end

  devel do
    url "https://dl.webhippie.de/misc/mygithub/master/mygithub-master-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/misc/mygithub/master/mygithub-master-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/mygithub", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/mygithub"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/mygithub" => "mygithub"
        # bash_completion.install "contrib/bash-completion/_mygithub"
        # zsh_completion.install "contrib/zsh-completion/_mygithub"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/mygithub-master-darwin-10.6-amd64" => "mygithub"
    else
      bin.install "#{buildpath}/mygithub-1.0.0-darwin-10.6-amd64" => "mygithub"
    end
  end
end
