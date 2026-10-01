class GitFoundry < Formula
  desc "Personal git hooks config (lefthook protect-main guard)"
  homepage "https://github.com/vim89/git-foundry"
  url "https://github.com/vim89/git-foundry/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c9255beb9d777641398b79dcd9d881274434086d7b6c14e91827c8dac1e115f0"
  version "0.1.0"
  license "MIT"

  depends_on "lefthook"

  def install
    bin.install "bin/git-foundry"
    pkgshare.install "lefthook.yml"
  end

  test do
    assert_match "Usage: git-foundry", shell_output("#{bin}/git-foundry 2>&1", 1)
  end
end
