#!/usr/bin/env bash

update_zls=false

if [ $# -gt 0 ]; then
    if [ "$1" = "zls" ]; then
        echo "Checking ZLS..."
        update_zls=true
    else
        echo "Invalid argument: $1"
        exit 1
    fi
fi

zig_download_url="https://ziglang.org/download/index.json"

echo "Checking for the latest version of Zig..."
json=$(curl -# $zig_download_url)

zig_latest_version=$(echo $json | jq -r '.master.version')

zig_installed_version=$(cat zigversion.txt 2>/dev/null)

if [ $? -ne 0 ]; then
    zig_installed_version="NONE"
fi

if [ "$update_zls" = true ]; then

    zls_encoded_version=$(echo $zig_latest_version | jq -Rr @uri)

    zls_download_url="https://releases.zigtools.org/v1/zls/select-version?zig_version=$zls_encoded_version&compatibility=only-runtime"

    zls_json=$(curl -# $zls_download_url)

    zls_latest_version=$(echo $zls_json | jq -r '.version')

    zls_installed_version=$(cat zlsversion.txt 2>/dev/null)

    if [ $? -ne 0 ]; then
        zls_installed_version="NONE"
    fi

    if [ "$zls_installed_version" = "$zls_latest_version" ]; then
        echo "ZLS version $zls_installed_version is already installed"
    fi

    echo "Current ZLS version is $zls_installed_version"
    echo "Installing ZLS version $zls_latest_version"

    zls_tarball="https://builds.zigtools.org/zls-linux-x86_64-$zls_latest_version.tar.xz"

    echo "Tarball: $zls_tarball"

    curl -o zls.tar.xz $zls_tarball

    echo "Extracting ZLS..."

    mkdir -p zls
    pv zls.tar.xz | tar -xJf - -C zls

    rm zls.tar.xz

    sudo ln -s $(pwd)/zls/zls /usr/local/bin/zls 2>/dev/null
    echo $zls_latest_version > zlsversion.txt

    echo "ZLS version $zls_latest_version installed successfully"
fi

if [ "$zig_latest_version" = "$zig_installed_version" ]; then
    echo "Zig version $zig_latest_version is already installed"
    exit 0
fi


echo "Current installed version is $zig_installed_version"
echo "Installing Zig version $zig_latest_version"

zig_tarball=$(echo $json | jq -r '.master."x86_64-linux".tarball')

curl -o zig.tar.xz $zig_tarball

echo "Extracting Zig..."

mkdir -p zig
pv zig.tar.xz | tar -xJf - -C zig --strip-components 1

rm zig.tar.xz

sudo ln -s $(pwd)/zig/zig /usr/local/bin/zig 2>/dev/null
echo $zig_latest_version > zigversion.txt

echo "Zig version $zig_latest_version installed successfully"
