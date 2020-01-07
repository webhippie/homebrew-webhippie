require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Errors < Formula
  desc "display proper error documents"
  homepage "https://github.com/webhippie/errors"

  head do
    url "https://github.com/webhippie/errors.git", :branch => "master"
    depends_on "go" => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/misc/errors/0.1.0/errors-0.1.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/misc/errors/0.1.0/errors-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "0.1.0"
  # end

  devel do
    url "https://dl.webhippie.de/misc/errors/master/errors-master-darwin-10.6-amd64"
    sha256 open("https://dl.webhippie.de/misc/errors/master/errors-master-darwin-10.6-amd64.sha256").read.split(" ").first
    version "master"
  end

  test do
    system "#{bin}/errors", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/errors"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/errors" => "errors"
        # bash_completion.install "contrib/bash-completion/_errors"
        # zsh_completion.install "contrib/zsh-completion/_errors"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/errors-master-darwin-10.6-amd64" => "errors"
    else
      bin.install "#{buildpath}/errors-0.1.0-darwin-10.6-amd64" => "errors"
    end

    FileUtils.touch("errors.conf")
    etc.install "errors.conf" => "errors.conf"
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
            <key>ERRORS_ENV_FILE</key>
            <string>#{etc}/errors.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/errors</string>
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
