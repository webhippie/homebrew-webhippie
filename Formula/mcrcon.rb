require "formula"
require "language/go"
require "fileutils"
require "open-uri"

class Mcrcon < Formula
  desc "Rcon client for Minecraft"
  homepage "https://github.com/Tiiffi/mcrcon"

  url "https://github.com/Tiiffi/mcrcon/archive/v0.7.1.tar.gz"
  sha256 "69597079fa35bb246087671a77c825e015d51d16f7b8d0064915b84d78dd3c8f"
  head "https://github.com/Tiiffi/mcrcon.git", :shallow => false

  test do
    system bin/"mcrcon", "-v"
  end

  def install
    bin.mkpath
    man1.mkpath

    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.gsub! "	$(INSTALL) -vD $(EXENAME) $(DESTDIR)$(PREFIX)/bin/$(EXENAME)", "	install -v $(EXENAME) $(DESTDIR)$(PREFIX)/bin/$(EXENAME)"
      s.gsub! "	$(INSTALL) -vD -m 0644 mcrcon.1 $(DESTDIR)$(PREFIX)/share/man/man1/mcrcon.1", "	install -v -m 0644 mcrcon.1 $(DESTDIR)$(PREFIX)/share/man/man1/mcrcon.1"
    end

    system "make"
    system "make", "install"
  end
end
