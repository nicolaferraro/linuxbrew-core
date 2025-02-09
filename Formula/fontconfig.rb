class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2"
  sha256 "f655dd2a986d7aa97e052261b36aa67b0a64989496361eca8d604e6414006741"
  revision 1 unless OS.mac?

  bottle do
    sha256 "64ff208b28613dfe2a65b9d74fd9b0129f3ca7e423db78329144cdaf51b36f70" => :catalina
    sha256 "1c704a5a4249252bf42dc4f2a458f911a7858a931858ad257d9ec39978ca5095" => :mojave
    sha256 "3b763143a4d6e3c74b3a8b237d2e5a383696347ea3599d07957f73a3f6521d23" => :high_sierra
    sha256 "631531c4eb502bd97e4a5bef30760d1eef87dd50306ef2defb9460ac3338cfe1" => :sierra
    sha256 "40d70137a970e257de5cf1251b10d56d7db835faee88a9f4c020b4a4e4f82eb1" => :el_capitan
    sha256 "2aa79674e60e88f1afc613ed65d8e6e0e32f9b19eee7df7afb394b6357555caf" => :x86_64_linux
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX}."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  head do
    url "https://anongit.freedesktop.org/git/fontconfig", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  unless OS.mac?
    depends_on "gperf" => :build
    depends_on "gettext" => :build
    depends_on "json-c" => :build
    depends_on "util-linux" # for libuuid
  end

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "util-linux"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if MacOS.version >= :sierra

    system "autoreconf", "-iv" if build.head?
    ENV["UUID_CFLAGS"] = "-I#{Formula["util-linux"].include}" unless OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
