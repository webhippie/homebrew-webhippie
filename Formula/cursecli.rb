# frozen_string_literal: true

require 'formula'
require 'language/go'
require 'fileutils'
require 'open-uri'

class Cursecli < Formula
  desc ''
  homepage 'https://github.com/webhippie/cursecli'

  head do
    url 'https://github.com/webhippie/cursecli.git', branch: 'master'
    depends_on 'go' => :build
  end

  # stable do
  #   url "https://dl.webhippie.de/cursecli/1.0.0/cursecli-1.0.0-darwin-10.6-amd64"
  #   sha256 open("https://dl.webhippie.de/cursecli/1.0.0/cursecli-1.0.0-darwin-10.6-amd64.sha256").read.split(" ").first
  #   version "1.0.0"
  # end

  test do
    system "#{bin}/cursecli", '--version'
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      ENV['GOHOME'] = buildpath
      ENV['CGO_ENABLED'] = 1
      ENV['TAGS'] = ''

      ENV.prepend_create_path 'PATH', buildpath / 'bin'

      currentpath = buildpath / 'src/github.com/webhippie/cursecli'
      currentpath.install Dir['*']
      Language::Go.stage_deps resources, buildpath / 'src'

      cd currentpath do
        system 'make', 'retool', 'sync', 'generate', 'test', 'build'

        bin.install 'bin/cursecli' => 'cursecli'
        # bash_completion.install "contrib/bash-completion/_cursecli"
        # zsh_completion.install "contrib/zsh-completion/_cursecli"
        prefix.install_metafiles
      end
    elsif build.devel?
      bin.install "#{buildpath}/cursecli-master-darwin-10.6-amd64" => 'cursecli'
    else
      bin.install "#{buildpath}/cursecli-1.0.0-darwin-10.6-amd64" => 'cursecli'
    end
  end
end
