class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.15.tar.gz"
  sha256 "adce8152c3e802b8fe71b26d7252944944c49954ba6b5ba9fbb7fa5c4aad93dc"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "572754ab8b5981b13b496cef56f222524a7d1daeced9b7d4515a6a128adc8e42" => :catalina
    sha256 "5d7da12767371c227933a29fe69104a361ce73055977da6cbaa5a967be040b6f" => :mojave
    sha256 "9d2b2e8a004142f21d73717a61e94d02f0147874f13094a8c7936cb55dea86da" => :high_sierra
    sha256 "f7e47979083f1d8d467a34a08fa8ce70ee2f8335c14d4d230c256d36173b9cf5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
