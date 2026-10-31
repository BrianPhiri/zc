class Zc < Formula
  desc "Command line for ZedCloud: describe, stage and diagnose deployments"
  homepage "https://github.com/BrianPhiri/zc"

  on_macos do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.2.0/zc_0.2.0_darwin_arm64.tar.gz"
      sha256 "2d7c3d934947b99eec0d7c5488e7e2082e6d1430e42cea74617f3ea200a88161"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.2.0/zc_0.2.0_darwin_amd64.tar.gz"
      sha256 "5af349ada92a0c492f4eccc7d5124b9731f25c6462e7fa2c7e7336e7b34d9cab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.2.0/zc_0.2.0_linux_arm64.tar.gz"
      sha256 "49a6bb4da1faca30779f78d70e628d326d103de1ec68305ab57ff53e6403f6a2"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.2.0/zc_0.2.0_linux_amd64.tar.gz"
      sha256 "d0c2134298e37a9e76d3f2164e3bff1d5c88d63750cacc134f7b38cbe431d2e1"
    end
  end

  def install
    bin.install "zc"
  end

  test do
    assert_match "zc 0.2.0", shell_output("#{bin}/zc version")
  end
end
