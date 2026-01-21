class Zcompact < Formula
  desc "JSON compaction with queryable ID index"
  homepage "https://github.com/zzmarks26/Zcompact"
  url "https://github.com/zzmarks26/Zcompact/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "954583cb0e1e28396097c47e3c7abc311aabb9dd3b977df70a68a3deeaaadd0f"
  license "MIT"
  head "https://github.com/zzmarks26/Zcompact.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cli11"
  depends_on "nlohmann-json"
  depends_on "zstd"
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DZCOMPACT_USE_SYSTEM_DEPS=ON",
           *std_cmake_args
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
