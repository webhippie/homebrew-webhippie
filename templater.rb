require "formula"
require "language/go"

class Templater < Formula
  desc "A template processor for environment variables"
  homepage "https://github.com/webhippie/templater"

  stable do
    url "https://dl.webhippie.de/misc/templater/1.0.0/templater-1.0.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/templater/1.0.0/templater-1.0.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "1.0.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/templater/master/templater-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/templater/master/templater-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/webhippie/templater.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/templater", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/templater"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "templater"
        # bash_completion.install "contrib/bash-completion/_templater"
        # zsh_completion.install "contrib/zsh-completion/_templater"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/templater-master-darwin-10.6-amd64" => "templater"
    else
      bin.install "#{buildpath}/templater-1.0.0-darwin-10.6-amd64" => "templater"
    end
  end
end
