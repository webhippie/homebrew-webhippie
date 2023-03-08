# frozen_string_literal: true

require 'formula'
require 'language/go'
require 'fileutils'
require 'open-uri'

class PromToAptDater < Formula
  desc ''
  homepage 'https://github.com/webhippie/prom-to-apt-dater'

  head do
    url 'https://github.com/webhippie/prom-to-apt-dater.git', branch: 'master'
    depends_on 'go' => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/prom-to-apt-dater/0.1.0/prom-to-apt-dater-0.1.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/prom-to-apt-dater/0.1.0/prom-to-apt-dater-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "0.1.0"
  # end

  test do
    system "#{bin}/prom-to-apt-dater", '--version'
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      ENV['GOHOME'] = buildpath
      ENV['CGO_ENABLED'] = 1
      ENV['TAGS'] = ''

      ENV.prepend_create_path 'PATH', buildpath / 'bin'

      currentpath = buildpath / 'src/github.com/webhippie/prom-to-apt-dater'
      currentpath.install Dir['*']
      Language::Go.stage_deps resources, buildpath / 'src'

      cd currentpath do
        system 'make', 'retool', 'sync', 'generate', 'test', 'build'

        bin.install 'bin/prom-to-apt-dater' => 'prom-to-apt-dater'
        # bash_completion.install "contrib/bash-completion/_prom-to-apt-dater"
        # zsh_completion.install "contrib/zsh-completion/_prom-to-apt-dater"
        prefix.install_metafiles
      end
    elsif build.devel?
      bin.install "#{buildpath}/prom-to-apt-dater-master-darwin-10.6-amd64" => 'prom-to-apt-dater'
    else
      bin.install "#{buildpath}/prom-to-apt-dater-0.1.0-darwin-10.6-amd64" => 'prom-to-apt-dater'
    end

    FileUtils.touch('prom-to-apt-dater.conf')
    etc.install 'prom-to-apt-dater.conf' => 'prom-to-apt-dater.conf'
  end

  plist_options startup: true

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
            <string>#{etc}/prom-to-apt-dater.conf</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/prom-to-apt-dater</string>
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
