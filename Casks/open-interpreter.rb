cask "open-interpreter" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-musl"

  version "0.0.42"
  sha256 arm:          "ae4c00ed33e2923d81b09aebadf2aa2bffac5283931d79ba98e63a2cae71c7c7",
         intel:        "8d12c1d00c6392fa7d4fa39bedaa371a5cb45443ff87179af0612ff669076150",
         arm64_linux:  "8d2e08d7ed1837c0245b558bed4f9f520e052b7de1d59f133553489dab00ef2e",
         x86_64_linux: "a3b5eba008ffddd22617322c31efb7036e89c7d38b7472b060548ecf6e92b4e2"

  url "https://github.com/openinterpreter/openinterpreter/releases/download/rust-v#{version}/open-interpreter-package-#{arch}-#{os}.tar.gz"
  name "Open Interpreter"
  desc "Coding agent for open models, forked from OpenAI Codex"
  homepage "https://github.com/openinterpreter/openinterpreter"

  livecheck do
    url :url
    regex(/^rust[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  binary "bin/interpreter"
  binary "bin/codex-code-mode-host"
  generate_completions_from_executable "bin/interpreter", "completion"

  zap rmdir: "~/.openinterpreter"
end
