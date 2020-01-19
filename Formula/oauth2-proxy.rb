require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Oauth2Proxy < Formula
  desc "proxy for authentication via oauth2"
  homepage "https://github.com/webhippie/oauth2-proxy"

  head do
    url "https://github.com/webhippie/oauth2-proxy.git", :branch => "master"
    depends_on "go" => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/oauth2-proxy/0.1.0/oauth2-proxy-0.1.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/oauth2-proxy/0.1.0/oauth2-proxy-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "0.1.0"
  # end

  devel do
    url "https://dl.webhippie.de/oauth2-proxy/master/oauth2-proxy-0.0.0-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/oauth2-proxy/master/oauth2-proxy-0.0.0-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/oauth2-proxy", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/oauth2-proxy"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/oauth2-proxy" => "oauth2-proxy"
        # bash_completion.install "contrib/bash-completion/_oauth2-proxy"
        # zsh_completion.install "contrib/zsh-completion/_oauth2-proxy"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/oauth2-proxy-master-darwin-10.6-amd64" => "oauth2-proxy"
    else
      bin.install "#{buildpath}/oauth2-proxy-0.1.0-darwin-10.6-amd64" => "oauth2-proxy"
    end

    FileUtils.touch("oauth2-proxy.conf")
    etc.install "oauth2-proxy.conf" => "oauth2-proxy.conf"
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>EnvironmentVariables</key>
          <dict>
            <key>OAUTH2_PROXY_ENV_FILE</key>
            <string>#{etc}/oauth2-proxy.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/oauth2-proxy</string>
            <string>server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
        </dict>
      </plist>
    EOS
  end
end
