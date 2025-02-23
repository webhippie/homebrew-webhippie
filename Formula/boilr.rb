# frozen_string_literal: true

# Definition of the boilr formula
class Boilr < Formula
  desc "Boilerplate template manager that generates files from template repos"
  homepage "https://github.com/Ilyes512/boilr"
  license "Apache-2.0"

  url "https://github.com/Ilyes512/boilr/archive/refs/tags/0.5.0.tar.gz"
  sha256 "8df4ffb5fd893ec1fe38d2b4a422bcc683444f0485eb186e67e9a369d6a6b76c"
  head "https://github.com/Ilyes512/boilr.git", branch: "master"

  test do
    system bin / "boilr", "version"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s
      -w
      -X github.com/Ilyes512/boilr/pkg/boilr.Version=#{url.split('/').last.gsub('.tar.gz', '')}
      -X github.com/Ilyes512/boilr/pkg/boilr.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/Ilyes512/boilr/pkg/boilr.Commit=#{Utils.git_short_head(length: 8)}
    ]

    system "go", "build", *std_go_args(output: bin / "boilr", ldflags:),
           "-tags", "netgo", "."
  end
end
