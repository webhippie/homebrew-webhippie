require "formula"
require "language/go"

class Oauth2Proxy < Formula
  desc "Proxy to authenticate any application via OAuth2"
  homepage "https://github.com/webhippie/oauth2-proxy"

  stable do
    url "https://dl.webhippie.de/misc/oauth2-proxy/0.1.0/oauth2-proxy-0.1.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/oauth2-proxy/0.1.0/oauth2-proxy-0.1.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/oauth2-proxy/master/oauth2-proxy-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/oauth2-proxy/master/oauth2-proxy-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/webhippie/oauth2-proxy.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/oauth2-proxy", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/oauth2-proxy"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "oauth2-proxy"
        # bash_completion.install "contrib/bash-completion/_oauth2-proxy"
        # zsh_completion.install "contrib/zsh-completion/_oauth2-proxy"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/oauth2-proxy-master-darwin-10.6-amd64" => "oauth2-proxy"
    else
      bin.install "#{buildpath}/oauth2-proxy-0.1.0-darwin-10.6-amd64" => "oauth2-proxy"
    end
  end
end
