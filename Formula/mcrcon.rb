# frozen_string_literal: true

class Mcrcon < Formula
  desc 'Rcon client for Minecraft'
  homepage 'https://github.com/Tiiffi/mcrcon'

  url 'https://github.com/Tiiffi/mcrcon/archive/v0.7.2.tar.gz'
  sha256 '1743b25a2d031b774e805f4011cb7d92010cb866e3b892f5dfc5b42080973270'
  head 'https://github.com/Tiiffi/mcrcon.git', shallow: false

  test do
    system bin / 'mcrcon', '-v'
  end

  def install
    bin.mkpath
    man1.mkpath

    inreplace 'Makefile' do |s|
      s.change_make_var! 'PREFIX', prefix
      s.gsub! "\t$(INSTALL) -vD $(EXENAME) $(DESTDIR)$(PREFIX)/bin/$(EXENAME)",
              "\tinstall -v $(EXENAME) $(DESTDIR)$(PREFIX)/bin/$(EXENAME)"
      s.gsub! "\t$(INSTALL) -vD -m 0644 mcrcon.1 $(DESTDIR)$(PREFIX)/share/man/man1/mcrcon.1",
              "\tinstall -v -m 0644 mcrcon.1 $(DESTDIR)$(PREFIX)/share/man/man1/mcrcon.1"
    end

    system 'make'
    system 'make', 'install'
  end
end
