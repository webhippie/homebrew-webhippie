require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Terrastate < Formula
  desc "terraform http remote state storage"
  homepage "https://github.com/webhippie/terrastate"

  head do
    url "https://github.com/webhippie/terrastate.git", :branch => "master"
    depends_on "go" => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/terrastate/0.1.0/terrastate-0.1.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/terrastate/0.1.0/terrastate-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "0.1.0"
  # end

  test do
    system "#{bin}/terrastate", "--version"
  end

  def install
    case
    when build.head?
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["CGO_ENABLED"] = 1
      ENV["TAGS"] = ""

      ENV.prepend_create_path "PATH", buildpath/"bin"

      currentpath = buildpath/"src/github.com/webhippie/terrastate"
      currentpath.install Dir["*"]
      Language::Go.stage_deps resources, buildpath/"src"

      cd currentpath do
        system "make", "retool", "sync", "generate", "test", "build"

        bin.install "bin/terrastate" => "terrastate"
        # bash_completion.install "contrib/bash-completion/_terrastate"
        # zsh_completion.install "contrib/zsh-completion/_terrastate"
        prefix.install_metafiles
      end
    when build.devel?
      bin.install "#{buildpath}/terrastate-master-darwin-10.6-amd64" => "terrastate"
    else
      bin.install "#{buildpath}/terrastate-0.1.0-darwin-10.6-amd64" => "terrastate"
    end

    FileUtils.touch("terrastate.conf")
    etc.install "terrastate.conf" => "terrastate.conf"
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
            <key>TERRASTATE_ENV_FILE</key>
            <string>#{etc}/terrastate.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/terrastate</string>
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
