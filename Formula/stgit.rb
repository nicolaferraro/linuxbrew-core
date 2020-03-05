class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/releases/download/v0.21/stgit-0.21.tar.gz"
  sha256 "0f67a3c0ed3e0408aa8e9be6ff6c7be0a2981ca43639bc94bda7b6124717e71f"
  revision 1 unless OS.mac?
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "736d0fb7ba2e2f09acb9f3c12e7a232d975c1f20306b1d6b56dbc8fa9622bb0e" => :catalina
    sha256 "a8c5a52941bb5c524f97bddf295dbf65b79ec74b4ec5a0d0ebcdb25429e1e03d" => :mojave
    sha256 "a8c5a52941bb5c524f97bddf295dbf65b79ec74b4ec5a0d0ebcdb25429e1e03d" => :high_sierra
    sha256 "bb7b0df0dfa1ca08d938b18b0584759e17f297ca3312b7b9e909b9e4c3744fce" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    if ENV["CI"]
      system "git", "config", "--global", "user.email", "you@example.com"
      system "git", "config", "--global", "user.name", "Your Name"
    end
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
