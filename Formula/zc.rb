class Zc < Formula
  desc "Command line for ZedCloud: describe, stage and diagnose deployments"
  homepage "https://github.com/BrianPhiri/zc"

  on_macos do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.1.0/zc_0.1.0_darwin_arm64.tar.gz"
      sha256 "5c48f06b6cddd135f6ccaa2fdf6e911fef081b2c75c89a37a04920901863e07b"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.1.0/zc_0.1.0_darwin_amd64.tar.gz"
      sha256 "e36046f5323f148affc49170ca95a2423b3208cd209a17366a45cd8e6bc4cc60"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.1.0/zc_0.1.0_linux_arm64.tar.gz"
      sha256 "aaaae184ab9988c6b9d3df06e6a3011add637d47564baeb7ba0657cbc91d4f00"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.1.0/zc_0.1.0_linux_amd64.tar.gz"
      sha256 "1b7724fa5999ce6c85c9536707d85aeb9bc4f7f2f5d38a202016352cde48f88a"
    end
  end

  def install
    bin.install "zc"
  end

  test do
    assert_match "zc 0.1.0", shell_output("#{bin}/zc version")
  end
end
