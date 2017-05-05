require "formula"
require "language/go"

class LdapProxy < Formula
  desc "Proxy to authenticate any application via LDAP"
  homepage "https://github.com/webhippie/ldap-proxy"

  stable do
    url "https://dl.webhippie.de/misc/ldap-proxy/0.1.0/ldap-proxy-0.1.0-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/ldap-proxy/0.1.0/ldap-proxy-0.1.0-darwin-10.6-amd64.sha256`.split(" ").first
    version "0.1.0"
  end

  devel do
    url "https://dl.webhippie.de/misc/ldap-proxy/master/ldap-proxy-master-darwin-10.6-amd64"
    sha256 `curl -Ls https://dl.webhippie.de/misc/ldap-proxy/master/ldap-proxy-master-darwin-10.6-amd64.sha256`.split(" ").first
    version "master"
  end

  head do
    url "https://github.com/webhippie/ldap-proxy.git", :branch => "master"
    depends_on "go" => :build
  end

  test do
    system "#{bin}/ldap-proxy", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 0
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/ldap-proxy"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "test", "build"

        bin.install "ldap-proxy"
        # bash_completion.install "contrib/bash-completion/_ldap-proxy"
        # zsh_completion.install "contrib/zsh-completion/_ldap-proxy"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/ldap-proxy-master-darwin-10.6-amd64" => "ldap-proxy"
    else
      bin.install "#{buildpath}/ldap-proxy-0.1.0-darwin-10.6-amd64" => "ldap-proxy"
    end
  end
end
