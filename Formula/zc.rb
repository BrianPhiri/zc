class Zc < Formula
  desc "Command line for ZedCloud: describe, stage and diagnose deployments"
  homepage "https://github.com/BrianPhiri/zc"

  on_macos do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.5.0/zc_0.5.0_darwin_arm64.tar.gz"
      sha256 "b8b6c614e2c86d6cce69ca30134f216a079cceb2b9c60767dfde50346f8795b0"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.5.0/zc_0.5.0_darwin_amd64.tar.gz"
      sha256 "04149321b6099289ec96d984e9082395debc138b998e75b1b575d6a8e25a8b1b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.5.0/zc_0.5.0_linux_arm64.tar.gz"
      sha256 "0659325ccc3d76fb4e6845fadacba2086172c13edbf2229f877d88659cb08951"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.5.0/zc_0.5.0_linux_amd64.tar.gz"
      sha256 "2fb0cf7f574ab62a4a07540988b6eceb229c3d747ee4873beb1c668ede16d40c"
    end
  end

  def install
    bin.install "zc"
  end

  test do
    assert_match "zc 0.5.0", shell_output("#{bin}/zc version")
  end
end
