class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.16.2.tar.gz"
  sha256 "a062d206d78ac1b8010c4c88603d65c6a089a13d0bce01ff766261bbe350741b"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d5e8efdbb9e0d28d136e4849bee70e53f00e108b2673bc1f41e872ef3b1f678" => :catalina
    sha256 "ad701d55b533c834fd6804457ed0d46d297e66c32f0c11cd6a4e42183c09b65a" => :mojave
    sha256 "f72870e3a3f2bc9b05c66700b2311bdf029ebf1ac71200c931661942fef8a170" => :high_sierra
    sha256 "08c0dd14f94f1faa0f0c23ea0623113d07be7d3845ee97d8807ee1987a94a3bf" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
