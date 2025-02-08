# Zigup

A small utility to update your Zig installation to the latest version.  
It's not supposed to be a Zig compiler manager, just a simple way to keep your Zig installation up to date.  
Only works for x86_64-linux.

## How does it work?

It downloads the latest version of master branch from the [official download page](https://ziglang.org/download/) and replaces the current installation with the new one.  
It's the simple.  
A symlink is created in /usr/local/bin/zig to the zig binary.
