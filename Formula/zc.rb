class Zc < Formula
  desc "Command line for ZedCloud: describe, stage and diagnose deployments"
  homepage "https://github.com/BrianPhiri/zc"

  on_macos do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.4.0/zc_0.4.0_darwin_arm64.tar.gz"
      sha256 "4e61c4cb6e905651b67f6bb54d11b628eaf1436a5fbf39778db7105ac86c7463"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.4.0/zc_0.4.0_darwin_amd64.tar.gz"
      sha256 "8b543938b19a4a7ac4356372dcd4fc1939040c89fcaa5b3bb81422ef0eeb1dc5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.4.0/zc_0.4.0_linux_arm64.tar.gz"
      sha256 "24b8476c87e1918d00e5b9dd57070d2d4483e9833fbb66a6f460099d6491a87c"
    end
    on_intel do
      url "https://github.com/BrianPhiri/zc/releases/download/v0.4.0/zc_0.4.0_linux_amd64.tar.gz"
      sha256 "541e05e2483bd2a8d95466aa16a71b4e784f18172b4883976fdef9f4dd1c66c7"
    end
  end

  def install
    bin.install "zc"
  end

  test do
    assert_match "zc 0.4.0", shell_output("#{bin}/zc version")
  end
end
