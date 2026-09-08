# aboyett homebrew-tap

Third-party [Homebrew](https://brew.sh) tap.

## Install

```sh
brew tap aboyett/tap https://github.com/aboyett/homebrew-tap
brew install --cask aboyett/tap/open-interpreter
```

(Homebrew resolves `aboyett/tap` to this repo automatically; the explicit `brew tap`
step is only needed if you want to pin the URL.)

## Available casks

| Cask | Description |
| --- | --- |
| [open-interpreter](Casks/open-interpreter.rb) | Open Interpreter — coding agent for open models (OpenAI Codex fork) |
