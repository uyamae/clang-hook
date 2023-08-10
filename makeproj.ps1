param (
    [switch]$build,
    [int]$DebugFlags=0
)
if (($DebugFlags -band 1) -ne 0) {
    $DebugPreference = "Continue"
}
Set-Location -Path $PSScriptRoot
$BuildDir = "build"
if ($false) {
# make build directory exists
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
} else {
# execute cmake
cmake -S . -B ${BuildDir} -G"Visual Studio 17 2022" -T ClangCL
# move into build directory
if (!(Push-Location -Path $BuildDir -PassThru)) {
    Write-Host "${BuildDir} is not a directory."
    Exit 1
}
}
# edit test.vcxproj
$testprojpath = ".\test\test.vcxproj"
if (Test-Path $testprojpath) {
    $testproj = [xml](Get-Content $testprojpath -Encoding UTF8)
    $NsMgr = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $testproj.NameTable
    $xmlns = $testproj.DocumentElement.GetAttribute("xmlns")
    $NsMgr.AddNamespace("ns", $xmlns)
    #Write-Host $testproj.OuterXml
    #$PropGroups = $testproj.Project.Descendants("PropertyGroup").ToList()
    $PropGroups = $testproj.SelectNodes("ns:Project/ns:PropertyGroup", $NsMgr)
    #$PropGroups = Select-Xml -Xml $testproj.Project -XPath "./PropertyGroup"
    $exists = $false
    foreach ($PropGroup in $PropGroups) {
        $tool = $PropGroup.SelectSingleNode("ns:CLToolExe", $NsMgr)
        if ($tool -eq $null) {
            continue;
        }
        $toolpath = $PropGroup.SelectSingleNode("ns:ExecutablePath", $NsMgr)
        if ($toolpath -eq $null) {
            continue;
        }
        $exists = $true
        break
    }
    if (!$exists) {
        $propgroup = $testproj.CreateElement("PropertyGroup", $xmlns)
        $testproj.Project.AppendChild($propgroup)

        $tool = $testproj.CreateElement("CLToolExe", $xmlns)
        $tool.InnerXml = "clang-hook.exe"
        $propgroup.AppendChild($tool)

        $toolpath = $testproj.CreateElement("ExecutablePath", $xmlns)
        $toolpath.InnerXml = "`$(SolutionDir)hook\`$(Configuration);`$(ExecutablePath)"
        $propgroup.AppendChild($toolpath)
        if (($DebugFlags -band 2) -eq 0) {
            $file = Get-Item $testprojpath
            $testproj.Save($file.FullName)
        }
    }
    Write-Debug $testproj.OuterXml
}
# build project
if ($build) {
    Write-Host "build project"
    cmake --build .
}