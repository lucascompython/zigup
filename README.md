# Zigup

A small utility to update your `Zig` and `ZLS` installation to the latest version.
It's not supposed to be a full-blown version manager, just a simple way to keep your `Zig` and `ZLS` installation up to date with the latest master branch.
Only works for `x86_64-linux` and `x86_64-windows`.

Since this updates to the latest master branch it's recommended to also use the latest `ZLS` version.

## How does it work?

It downloads the latest version of master branch from the [official download page](https://ziglang.org/download/) and replaces the current installation with the new one.
It's that simple.
For Linux symlinks are created in `/usr/local/bin/zig` and `/usr/local/bin/zls` to the `zig` and `zls` binary respectively.
For Windows the `PATH` environment variable is updated to include the `zig` and `zls` path.

## How to use it?

```bash
# Linux
./zigup.sh zls # to also install/update to the latest ZLS version

# Windows
./zigup.ps1 zls
```
