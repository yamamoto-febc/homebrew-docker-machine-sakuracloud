require "language/go"

class DockerMachineSakuracloud < Formula
  desc "Docker Machine SAKURA CLOUD Driver"
  homepage "https://github.com/yamamoto-febc/docker-machine-sakuracloud"
  url "https://github.com/yamamoto-febc/docker-machine-sakuracloud/archive/v0.0.5.tar.gz"
  sha256 "b8c0cd4b533121bd9d0ae792a435855e2a832eccbe0e4b92fc3d30e21c7f7f37"
  head "https://github.com/yamamoto-febc/docker-machine-sakuracloud.git"

  bottle do
    root_url "https://bintray.com/artifact/download/yamamoto-febc/bottles"
    cellar :any_skip_relocation
    sha256 "598fc1842fc69c6da7f93a305f452258f7d2c251e0a83feb8b96bb7ef2ed1434" => :el_capitan
    sha256 "aff90cf42a4ca5408640fa5c4283f8dc7056fd3dec727fbc8d0af0f15fc8f9f7" => :yosemite
    sha256 "7cd82dbae689813d4e46f0895e8fecc4e2713eeb0e9f37dcbf991d0ffa8bf5fe" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/docker" do
    # Docker v1.9.1 release
    url "https://github.com/docker/docker.git", :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  end

  go_resource "github.com/docker/machine" do
    # Docker Machine v0.5.1 release
    url "https://github.com/docker/machine.git", :revision => "7e8e38e1485187c0064e054029bb1cc68c87d39a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "beef0f4390813b96e8e68fd78570396d0f4751fc"
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
