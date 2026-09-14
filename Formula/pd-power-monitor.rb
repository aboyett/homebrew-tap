class PdPowerMonitor < Formula
  desc "System tray indicator for USB-C Power Delivery wattage and battery status"
  homepage "https://github.com/DhilipBinny/pd-power-monitor"
  url "https://github.com/DhilipBinny/pd-power-monitor/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "00c02f98519f85a894f36dca31d049e5c68acc854bf9cb4bd438f92b0f2b0c5b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    # The Linux tray talks D-Bus in pure Go; macOS needs cgo for macos menu integration
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    args = std_go_args(output: bin/"power-monitor", ldflags: ["-X main.version=v#{version}"])
    system "go", "build", *args, "-buildvcs=false", "."
  end

  def caveats
    <<~TEXT
      Register the tray to start on login with:
        power-monitor autostart on

      The indicator itself is started with `power-monitor start`; the `upgrade`
      subcommand writes over Homebrew's install, so use `brew upgrade
      pd-power-monitor` instead.
    TEXT
  end

  test do
    assert_match "power-monitor v#{version}", shell_output("#{bin}/power-monitor version")
  end
end
