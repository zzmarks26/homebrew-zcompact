class Zcompact < Formula
  desc "JSON compaction with queryable ID index"
  homepage "https://github.com/zackmarks/zcompact"
  license "MIT"
  head "https://github.com/zackmarks/zcompact.git", branch: "main"

  # Uncomment and update when you create a release:
  # url "https://github.com/zackmarks/zcompact/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "REPLACE_WITH_ACTUAL_SHA256"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zstd"
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    bin.install "build/zcompact"
    man1.install "man/zcompact.1"
  end

  test do
    # Create test data
    (testpath/"test.json").write <<~EOS
      {"id":"1","name":"Alice"}
      {"id":"2","name":"Bob"}
    EOS
    system "gzip", "test.json"

    # Create archive
    system bin/"zcompact", "create", "test.jcpk", "test.json.gz"

    # Query
    output = shell_output("#{bin}/zcompact get test.jcpk 1")
    assert_match "Alice", output

    # Stats
    output = shell_output("#{bin}/zcompact stats test.jcpk")
    assert_match "Active records: 2", output
  end
end
