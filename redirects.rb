require "formula"
require "language/go"

class Redirects < Formula
  desc "Simple pattern-based redirect server"
  homepage "https://github.com/webhippie/redirects"

  stable do
    url "https://dl.webhippie.de/misc/redirects/0.1.0/redirects-0.1.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/redirects/0.1.0/redirects-0.1.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/redirects/master/redirects-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/redirects/master/redirects-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/webhippie/redirects.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/redirects", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/redirects"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "redirects"
        # bash_completion.install "contrib/bash-completion/_redirects"
        # zsh_completion.install "contrib/zsh-completion/_redirects"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/redirects-master-darwin-10.6-amd64" => "redirects"
    else
      bin.install "#{buildpath}/redirects-0.1.0-darwin-10.6-amd64" => "redirects"
    end
  end
end
