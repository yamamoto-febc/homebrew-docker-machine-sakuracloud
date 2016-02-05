require "language/go"

class DockerMachineSakuracloud < Formula
  desc "Docker Machine SAKURA CLOUD Driver"
  homepage "https://github.com/yamamoto-febc/docker-machine-sakuracloud"
  url "https://github.com/yamamoto-febc/docker-machine-sakuracloud/archive/v0.0.8.tar.gz"
  sha256 "291b2a8f0841514d9011e8d8182bffc245b3bfaa8de84aa8fd6493186c1b7f65"
  head "https://github.com/yamamoto-febc/docker-machine-sakuracloud.git"

  bottle do
    root_url "https://bintray.com/artifact/download/yamamoto-febc/bottles"
    cellar :any_skip_relocation
    sha256 "ccb04ab7303dc236cf6a31ffbcd00c665393cfee789e7df5a57f6ac28de92873" => :el_capitan
    sha256 "da194a3eba25f7e8ebc62b84abb1e0af38e2af8b6c3ea0da8cb08ba63739d0ae" => :yosemite
    sha256 "df55d46e4ed405663ccd7f8e2a0289331d0d792e00733654c3a651975a495b17" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/docker" do
    # Docker v1.9.1 release
    url "https://github.com/docker/docker.git", :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  end

  go_resource "github.com/docker/machine" do
    # Docker Machine v0.5.5 release
    url "https://github.com/docker/machine.git", :revision => "02c4254cb4c93a4bbb5dc4ca0467abeb12d72546"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "f18420efc3b4f8e9f3d51f6bd2476e92c46260e9"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :tag => "v1.2.0", :revision => "565493f259bf868adb54d45d5f4c68d405117adf"
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
