# frozen_string_literal: true

class Boilr < Formula
  desc 'Boilerplate template manager that generates files from template repo'
  homepage 'https://github.com/Ilyes512/boilr'

  url 'https://github.com/Ilyes512/boilr/archive/0.4.6.tar.gz'
  version '0.4.5'
  sha256 '362e7af96528cc6c01ab1caf3f4e8433baf2aabd8878fc953b3be7ff14ab420d'

  test do
    system bin / 'boilr', '--help'
  end

  def install
    bin.install 'boilr'
  end
end
