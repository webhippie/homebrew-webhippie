# require "formula"
# require "language/go"
# require "fileutils"
# require "open-uri"

# class Medialize < Formula
#   desc "a template processor for environment variables"
#   homepage "https://github.com/webhippie/templater"

#   head do
#     url "https://github.com/webhippie/templater.git", :branch => "master"
#     depends_on "go" => :build
#   end

#   # stable do
#   #   url "https://dl.webhippie.de/misc/templater/1.0.0/templater-1.0.0-darwin-10.6-amd64"
#   #   sha256 open("https://dl.webhippie.de/misc/templater/1.0.0/templater-1.0.0-darwin-10.6-amd64.sha256").read.split(" ").first
#   #   version "1.0.0"
#   # end

#   devel do
#     url "https://dl.webhippie.de/misc/templater/master/templater-master-darwin-10.6-amd64"
#     sha256 open("https://dl.webhippie.de/misc/templater/master/templater-master-darwin-10.6-amd64.sha256").read.split(" ").first
#     version "master"
#   end

#   test do
#     system "#{bin}/templater", "--version"
#   end

#   def install
#     case
#     when build.head?
#       ENV["GOPATH"] = buildpath
#       ENV["GOHOME"] = buildpath
#       ENV["CGO_ENABLED"] = 1
#       ENV["TAGS"] = ""

#       ENV.prepend_create_path "PATH", buildpath/"bin"

#       currentpath = buildpath/"src/github.com/webhippie/templater"
#       currentpath.install Dir["*"]
#       Language::Go.stage_deps resources, buildpath/"src"

#       cd currentpath do
#         system "make", "retool", "sync", "generate", "test", "build"

#         bin.install "bin/templater" => "templater"
#         # bash_completion.install "contrib/bash-completion/_templater"
#         # zsh_completion.install "contrib/zsh-completion/_templater"
#         prefix.install_metafiles
#       end
#     when build.devel?
#       bin.install "#{buildpath}/templater-master-darwin-10.6-amd64" => "templater"
#     else
#       bin.install "#{buildpath}/templater-1.0.0-darwin-10.6-amd64" => "templater"
#     end
#   end
# end
