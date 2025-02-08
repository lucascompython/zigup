$download_url = "https://ziglang.org/download/index.json"

Write-Output "Checking for the latest version of Zig..."
$json = Invoke-RestMethod -Uri $download_url

$latest_version = $json.master.version

$installed_version = Get-Content -Path "zigversion.txt" -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) {
    $installed_version = "NONE"
}

if ($latest_version -eq $installed_version) {
    Write-Output "Zig version $latest_version is already installed"
    exit
}

Write-Output "Current installed version is $installed_version"
Write-Output "Installing Zig version $latest_version"

$tarball = $json.master."x86_64-windows".tarball

Invoke-WebRequest -Uri $tarball -OutFile "zig.tar.xz"

Write-Output "Extracting..."

New-Item -ItemType Directory -Path "zig" -Force | Out-Null

tar -xJf "zig.tar.xz" -C "zig" --strip-components 1

Remove-Item -Path "zig.tar.xz"

$zigPath = Join-Path -Path (Get-Location) -ChildPath "zig"


if ($env:Path -split ";" -notcontains $zigPath) {
    $env:Path = $env:Path + ";$zigPath"
    [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
}

Set-Content -Path "zigversion.txt" -Value $latest_version

Write-Output "Zig version $latest_version installed successfully"