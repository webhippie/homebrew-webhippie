require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Medialize < Formula
  desc "sort and filter your media files based on meta infos"
  homepage "https://github.com/webhippie/medialize"

  head do
    url "https://github.com/webhippie/medialize.git", :branch => "master"
    depends_on "go" => :build
  end

  stable do
    url "https://dl.webhippie.de/misc/medialize/1.0.0/medialize-1.0.0-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/misc/medialize/1.0.0/medialize-1.0.0-darwin-10.6-amd64.sha256").read.split(" ").first
    version "1.0.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/medialize/master/medialize-master-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/misc/medialize/master/medialize-master-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/medialize", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/medialize"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/medialize" => "medialize"
        # bash_completion.install "contrib/bash-completion/_medialize"
        # zsh_completion.install "contrib/zsh-completion/_medialize"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/medialize-master-darwin-10.6-amd64" => "medialize"
    else
      bin.install "#{buildpath}/medialize-1.0.0-darwin-10.6-amd64" => "medialize"
    end
  end
end
