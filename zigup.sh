#!/usr/bin/env bash

download_url="https://ziglang.org/download/index.json"

echo "Checking for the latest version of Zig..."
json=$(curl -# $download_url)

latest_version=$(echo $json | jq -r '.master.version')

installed_version=$(cat zigversion.txt 2>/dev/null)

if [ $? -ne 0 ]; then
    installed_version="NONE"
fi

if [ "$latest_version" = "$installed_version" ]; then
    echo " Zig version $latest_version is already installed"
    exit 0
fi

echo "Current installed version is $installed_version"
echo "Installing Zig version $latest_version"

tarball=$(echo $json | jq -r '.master."x86_64-linux".tarball')

curl -o zig.tar.xz $tarball

echo "Extracting..."

mkdir -p zig
pv zig.tar.xz | tar -xJf - -C zig --strip-components 1

rm zig.tar.xz

sudo ln -s $(pwd)/zig/zig /usr/local/bin/zig 2>/dev/null
echo $latest_version > zigversion.txt

echo "Zig version $latest_version installed successfully"

