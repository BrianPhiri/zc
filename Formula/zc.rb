class Zc < Formula
  desc "Command line for ZedCloud: describe, stage and diagnose deployments"
  homepage "https://github.com/BrianPhiri/zc"

  on_macos do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.3.0/zc_0.3.0_darwin_arm64.tar.gz"
      sha256 "5c5e328bf3063e29f984bdd4189fd3df9fd74e4b83c02fe57dce2d4daa70901e"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.3.0/zc_0.3.0_darwin_amd64.tar.gz"
      sha256 "567f50e3d0e6540722b0c04fce2504d80af2ede942b6f6d77e3dbd8c4a8aa323"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.3.0/zc_0.3.0_linux_arm64.tar.gz"
      sha256 "c5793614b73afa32d1c5d267601a53d75a4778808f2c4f446c6ee723efd9b6d7"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.3.0/zc_0.3.0_linux_amd64.tar.gz"
      sha256 "b8d26cb85e4eee6d56d3a45cacd31462480c2822bf2d335d37651b17b885b2ed"
    end
  end

  def install
    bin.install "zc"
  end

  test do
    assert_match "zc 0.3.0", shell_output("#{bin}/zc version")
  end
end
