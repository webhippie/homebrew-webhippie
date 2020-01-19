# require "formula"
# require "language/go"
# require "fileutils"
# require "open-uri"

# class LdapProxy < Formula
#   desc "proxy for authentication via ldap"
#   homepage "https://github.com/webhippie/ldap-proxy"

#   head do
#     url "https://github.com/webhippie/ldap-proxy.git", :branch => "master"
#     depends_on "go" => :build
#   end

#   # stable do
#   #   url "https://dl.webhippie.de/misc/ldap-proxy/0.1.0/ldap-proxy-0.1.0-darwin-10.6-amd64"
#   #   sha256 open("https://dl.webhippie.de/misc/ldap-proxy/0.1.0/ldap-proxy-0.1.0-darwin-10.6-amd64.sha256").read.split(" ").first
#   #   version "0.1.0"
#   # end

#   devel do
#     url "https://dl.webhippie.de/misc/ldap-proxy/master/ldap-proxy-master-darwin-10.6-amd64"
#     sha256 open("https://dl.webhippie.de/misc/ldap-proxy/master/ldap-proxy-master-darwin-10.6-amd64.sha256").read.split(" ").first
#     version "master"
#   end

#   test do
#     system "#{bin}/ldap-proxy", "--version"
#   end

#   def install
#     case
#     when build.head?
#       ENV["GOPATH"] = buildpath
#       ENV["GOHOME"] = buildpath
#       ENV["CGO_ENABLED"] = 1
#       ENV["TAGS"] = ""

#       ENV.prepend_create_path "PATH", buildpath/"bin"

#       currentpath = buildpath/"src/github.com/webhippie/ldap-proxy"
#       currentpath.install Dir["*"]
#       Language::Go.stage_deps resources, buildpath/"src"

#       cd currentpath do
#         system "make", "retool", "sync", "generate", "test", "build"

#         bin.install "bin/ldap-proxy" => "ldap-proxy"
#         # bash_completion.install "contrib/bash-completion/_ldap-proxy"
#         # zsh_completion.install "contrib/zsh-completion/_ldap-proxy"
#         prefix.install_metafiles
#       end
#     when build.devel?
#       bin.install "#{buildpath}/ldap-proxy-master-darwin-10.6-amd64" => "ldap-proxy"
#     else
#       bin.install "#{buildpath}/ldap-proxy-0.1.0-darwin-10.6-amd64" => "ldap-proxy"
#     end

#     FileUtils.touch("ldap-proxy.conf")
#     etc.install "ldap-proxy.conf" => "ldap-proxy.conf"
#   end

#   plist_options :startup => true

#   def plist
#     <<~EOS
#       <?xml version="1.0" encoding="UTF-8"?>
#       <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#       <plist version="1.0">
#         <dict>
#           <key>Label</key>
#           <string>#{plist_name}</string>
#           <key>EnvironmentVariables</key>
#           <dict>
#             <key>LDAP_PROXY_ENV_FILE</key>
#             <string>#{etc}/ldap-proxy.conf</string>
#           </dict>
#           <key>ProgramArguments</key>
#           <array>
#             <string>#{opt_bin}/ldap-proxy</string>
#             <string>server</string>
#           </array>
#           <key>RunAtLoad</key>
#           <true/>
#           <key>KeepAlive</key>
#           <true/>
#         </dict>
#       </plist>
#     EOS
#   end
# end
