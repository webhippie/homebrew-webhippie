require "formula"
require "language/go"

class Mygithub < Formula
  desc "Some tiny GitHub client utilities for daily work"
  homepage "https://github.com/webhippie/mygithub"

  stable do
    url "https://dl.webhippie.de/misc/mygithub/1.0.0/mygithub-1.0.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/mygithub/1.0.0/mygithub-1.0.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "1.0.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/mygithub/master/mygithub-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/mygithub/master/mygithub-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/webhippie/mygithub.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/mygithub", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/mygithub"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "mygithub"
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
