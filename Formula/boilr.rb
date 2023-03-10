# frozen_string_literal: true

# Definition of the boilr formula
class Boilr < Formula
  desc "Boilerplate template manager that generates files from template repos"
  homepage "https://github.com/Ilyes512/boilr"
  license "Apache-2.0"

  version "0.4.6"
  url "https://github.com/Ilyes512/boilr.git",
      tag: "0.4.6",
      revision: "ea67977b89b9a9d240a8f911ffb0badb762f5525"

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
      -X github.com/Ilyes512/boilr/pkg/boilr.Version=#{version}
      -X github.com/Ilyes512/boilr/pkg/boilr.BuildDate=#{Time.now.utc.iso8601}
      -X github.com/Ilyes512/boilr/pkg/boilr.Commit=#{Utils.git_short_head(length: 8)}
    ]

    system "go", "build", *std_go_args(output: bin / "boilr", ldflags: ldflags),
           "-tags", "netgo", "."
  end
end
