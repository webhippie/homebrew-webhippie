class Boilr < Formula
  desc "Boilerplate template manager that generates files from template repo"
  homepage "https://github.com/Ilyes512/boilr"

  url "https://github.com/Ilyes512/boilr/releases/download/0.4.5/boilr_0.4.5_macOS_64-bit.tar.gz"
  version "0.4.5"
  sha256 "25c4e890e227602ba17abdd22cffdf18808c3bb5b81a3858d23eb1084103b495"

  test do
    system bin/"boilr", "--help"
  end

  def install
    bin.install "boilr"
  end
end
