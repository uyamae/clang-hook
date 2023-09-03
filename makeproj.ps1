param (
    [switch]$build,
    [int]$DebugFlags=0
)
if (($DebugFlags -band 1) -ne 0) {
    $DebugPreference = "Continue"
}
Set-Location -Path $PSScriptRoot
$BuildDir = "build"
# execute cmake
cmake -S . -B ${BuildDir} -G"Visual Studio 17 2022" -T ClangCL
# move into build directory
if (!(Push-Location -Path $BuildDir -PassThru)) {
    Write-Host "${BuildDir} is not a directory."
    Exit 1
}
# create Directory.Build.targets to customize building process
$dirtargetspath = Join-Path $PSScriptRoot "build\test\Directory.Build.targets"
if (!(Test-Path $dirtargetspath)) {
    $xmldoc = New-Object System.Xml.XmlDocument
    $xmldoc.LoadXml(
        "<Project><PropertyGroup>"+
        "<CLToolExe>clang-hook.exe</CLToolExe>"+
        "<ExecutablePath>`$(SolutionDir)hook\`$(Configuration);`$(ExecutablePath)</ExecutablePath>"+
        "</PropertyGroup></Project>"
    )
    $xmldoc.Save($dirtargetspath)
}
# build project
if ($build) {
    Write-Host "build project"
    cmake --build .
}
Pop-Location
