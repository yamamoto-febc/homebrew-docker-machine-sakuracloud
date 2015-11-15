require "language/go"

class DockerMachineSakuracloud < Formula
  desc "Docker Machine SAKURA CLOUD Driver"
  homepage "https://github.com/yamamoto-febc/docker-machine-sakuracloud"
  url "https://github.com/yamamoto-febc/docker-machine-sakuracloud/archive/v0.0.3.tar.gz"
  sha256 "f458e8fb4068a4bed326e373076668c18d407830c2a2064cc0b94cde2b35aa41"
  head "https://github.com/yamamoto-febc/docker-machine-sakuracloud.git"

  bottle do
    root_url "https://bintray.com/artifact/download/yamamoto-febc/bottles"
    cellar :any_skip_relocation
    sha256 "1968078799a76c827148a7e1a9f2bec648dfee299ce4772a7d457e1d22a0711e" => :el_capitan
    sha256 "9c05c828be74f4dd4ee86d621145a1337573537cb18ee3060874a56a7ccc10f1" => :yosemite
    sha256 "6eb154b93295a1fd36528fddd8b6ba5dd1ee792eb88902396a188fcc3aa801cd" => :mavericks
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
