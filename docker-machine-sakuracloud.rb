require "language/go"

class DockerMachineSakuracloud < Formula
  desc "Docker Machine SAKURA CLOUD Driver"
  homepage "https://github.com/yamamoto-febc/docker-machine-sakuracloud"
  url "https://github.com/yamamoto-febc/docker-machine-sakuracloud/archive/v0.0.7.tar.gz"
  sha256 "2de357884d466eec33b38cbe453cbfebe9fbd063a56afabf015b29037615f698"
  head "https://github.com/yamamoto-febc/docker-machine-sakuracloud.git"

  bottle do
    root_url "https://bintray.com/artifact/download/yamamoto-febc/bottles"
    cellar :any_skip_relocation
    sha256 "600c1977c1bfff81bb8a580f9c61c3f7b6a1955f9fbe5d3feb617843930f0584" => :el_capitan
    sha256 "944249881d1260228da1d9dd3c15e02bafd51bef4ff38616731ca7b644b9dd79" => :yosemite
    sha256 "d28a39ee31aca4cb26a0c958984102fca86c18011fc5b337ce44e9d943a028d5" => :mavericks
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
