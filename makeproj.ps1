param (
    [switch]$build
)
Set-Location -Path $PSScriptRoot
# make build directory exists
$BuildDir = "build"
if (!(Test-Path $BuildDir)) {
    New-Item $BuildDir -ItemType Directory
}
# move into build directory
if (!(Push-Location -Path $BuildDir -PassThru)) {
    Write-Host "${BuildDir} is not a directory."
    Exit 1
}
# execute cmake
cmake .. -G"Visual Studio 17 2022" -T ClangCL
# build project
if ($build) {
    Write-Host "build project"
    cmake --build .
}