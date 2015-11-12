require "language/go"

class DockerMachineSakuracloud < Formula
  desc "Docker Machine SAKURA CLOUD Driver"
  homepage "https://github.com/yamamoto-febc/docker-machine-sakuracloud"
  url "https://github.com/yamamoto-febc/docker-machine-sakuracloud/archive/v0.0.2.tar.gz"
  sha256 "ff5262b484272c7f566fed859316612eb8052b281c12beea9103135568bd8fcb"
  head "https://github.com/yamamoto-febc/docker-machine-sakuracloud.git"

  bottle do
    root_url "https://bintray.com/artifact/download/yamamoto-febc/bottles"
    cellar :any_skip_relocation
    sha256 "f4dbceb12fa931c4920ed2120d1fd57c74ee962914ccc19238d17d4f2c4d1cfc" => :el_capitan
    sha256 "fbcef6c5fb0f0d659ee45ef816dc68933c1b5f95cafb0da0a49dcdf37fcc6392" => :yosemite
    sha256 "9da259110485d66d50ff00f15eb7ba0e50f5c6c3d3505de1139802d7841510c4" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git", :revision => "76d6bc9a9f1690e16f3721ba165364688b626de2"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git", :revision => "04cfa58445f063509699cdde41080a410330c4df"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git", :revision => "8b27f58b78dbd60e9a26b60b0d908ea642974b6d"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/yamamoto-febc/"
    ln_sf buildpath, buildpath/"src/github.com/yamamoto-febc/docker-machine-sakuracloud"
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "build"
    bin.install "bin/docker-machine-driver-sakuracloud"
  end

  test do
    assert_match "sakuracloud-access-token", shell_output("docker-machine create -d sakuracloud -h")
  end
end
