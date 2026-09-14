# typed: false
# frozen_string_literal: true

class Microsandbox < Formula
  desc "Spins up lightweight VMs in milliseconds from SDKs"
  homepage "https://microsandbox.dev"
  version "0.6.18"
  license "Apache-2.0"

  # libkrunfw ABI soname the release binaries load
  LIBKRUNFW_ABI = "5"

  on_macos do
    on_arm do
      url "https://github.com/superradcompany/microsandbox/releases/download/v#{version}/microsandbox-darwin-aarch64.tar.gz"
      sha256 "1e8c40859142cd38fb99b301bdb1fb4095a985a4065d080f99b3a3e7cb9a6305"
    end

    on_intel do
      odie "microsandbox requires Apple Silicon (M1+). x86_64 macOS is not supported."
    end
  end

  on_linux do
    # msb links libcap-ng, which the release bundle does not ship.
    depends_on "libcap-ng"

    on_arm do
      url "https://github.com/superradcompany/microsandbox/releases/download/v#{version}/microsandbox-linux-aarch64.tar.gz"
      sha256 "e53098e7601fddd85af7e943d4af3d4370ace276d9e863a89456338f2d076d1b"
    end

    on_intel do
      url "https://github.com/superradcompany/microsandbox/releases/download/v#{version}/microsandbox-linux-x86_64.tar.gz"
      sha256 "b001b3c6b980ab1ffcceb817496648c1520dba36b9e0caac37ea8d2f4acd9bdd"
    end
  end

  def install
    # Keep msb and its private libkrunfw together in libexec, then expose msb on
    # PATH through a wrapper script. The binary already carries an
    # @executable_path rpath, so it finds the library sitting beside it without
    # any install_name_tool edit. That matters on macOS: modifying the binary
    # would invalidate its code signature, and the release binary is signed with
    # the com.apple.security.hypervisor and disable-library-validation
    # entitlements it needs to boot VMs. Leaving the binary untouched preserves
    # the signature and those entitlements; a modified binary would be killed on
    # launch or lose the entitlements.
    libexec.install "msb"

    if OS.mac?
      # Tarball contains: libkrunfw.5.dylib
      libexec.install "libkrunfw.#{LIBKRUNFW_ABI}.dylib"
      libexec.install_symlink libexec/"libkrunfw.#{LIBKRUNFW_ABI}.dylib" => "libkrunfw.dylib"
    end

    if OS.linux?
      # Tarball contains a single versioned library, e.g. libkrunfw.so.5.6.1.
      # Borrowing the discovery process from `scripts/install.sh` to ensure msb
      # uses the bundled version.
      libkrunfw = Dir["libkrunfw.so.*.*.*"]
      odie "release bundle must contain exactly one versioned libkrunfw shared library" if libkrunfw.length != 1
      libkrunfw = libkrunfw.first
      abi = libkrunfw.delete_prefix("libkrunfw.so.").split(".").first
      libexec.install libkrunfw
      libexec.install_symlink libexec/libkrunfw => "libkrunfw.so.#{abi}"
      libexec.install_symlink libexec/libkrunfw => "libkrunfw.so"
    end

    bin.mkpath
    if OS.linux?
      # Wrap msb to ensure msb uses dependencies (libcap-ng) from Homebrew.
      File.write(bin/"msb", <<~SH)
        #!/bin/bash
        export LD_LIBRARY_PATH="#{formula_opt_lib("libcap-ng")}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec "#{libexec}/msb" "$@"
      SH
    else
      File.write(bin/"msb", <<~SH)
        #!/bin/bash
        exec "#{libexec}/msb" "$@"
      SH
    end
    chmod 0755, bin/"msb"
  end

  def caveats
    <<~EOS
      msb has its own updater, but Homebrew owns this installation. Don't use
      `msb self update`, `msb self downgrade` and `msb self uninstall`; these
      the modify brew-managed files. Only use `brew upgrade microsandbox` for
      new releases and `brew uninstall microsandbox` to remove them.

      Run `msb doctor` before your first sandbox to check that this host can
      boot one.

      On Linux, the wrapper fixes the LD_LIBRARY_PATH so msb can find brew's
      version of the libcap-ng dependency.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msb --version")
  end
end
