# aboyett homebrew-tap

Third-party [Homebrew](https://brew.sh) tap.

## Install

```sh
brew tap aboyett/tap https://github.com/aboyett/homebrew-tap
brew install --cask aboyett/tap/open-interpreter
brew install aboyett/tap/pd-power-monitor
```

(Homebrew resolves `aboyett/tap` to this repo automatically; the explicit `brew tap`
step is only needed if you want to pin the URL.)

## Available formulae

| Formula | Description |
| --- | --- |
| [pd-power-monitor](Formula/pd-power-monitor.rb) | pd-power-monitor — USB-C Power Delivery wattage and battery tray indicator (installs `power-monitor`) |
| [microsandbox](Formula/microsandbox.rb) | microsandbox — lightweight VMs in milliseconds from SDKs (installs `msb`) |

## Available casks

| Cask | Description |
| --- | --- |
| [open-interpreter](Casks/open-interpreter.rb) | Open Interpreter — coding agent for open models (OpenAI Codex fork) |
