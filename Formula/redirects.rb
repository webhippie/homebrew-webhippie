require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Redirects < Formula
  desc "simple pattern-based redirect server"
  homepage "https://github.com/webhippie/redirects"

  head do
    url "https://github.com/webhippie/redirects.git", :branch => "master"
    depends_on "go" => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/redirects/0.1.0/redirects-0.1.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/redirects/0.1.0/redirects-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "0.1.0"
  # end

  devel do
    url "https://dl.webhippie.de/redirects/master/redirects-master-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/redirects/master/redirects-master-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/redirects", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/redirects"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/redirects" => "redirects"
        # bash_completion.install "contrib/bash-completion/_redirects"
        # zsh_completion.install "contrib/zsh-completion/_redirects"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/redirects-master-darwin-10.6-amd64" => "redirects"
    else
      bin.install "#{buildpath}/redirects-0.1.0-darwin-10.6-amd64" => "redirects"
    end

    FileUtils.touch("redirects.conf")
    etc.install "redirects.conf" => "redirects.conf"
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
            <key>REDIRECTS_ENV_FILE</key>
            <string>#{etc}/redirects.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/redirects</string>
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
