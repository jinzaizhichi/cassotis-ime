param(
    [string]$Configuration = 'Release',
    [string]$VcVarsPath = '',
    [switch]$EnableExperimentalContextualRecall,
    [switch]$EnableExperimentalTop32CrossRanker
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root 'src\host\native\nc_pinyin_transformer_ort.cpp'
$include = Join-Path $root 'third_party\onnxruntime\include'
$onnxLibrary = Join-Path $root 'third_party\onnxruntime\win64\onnxruntime.lib'
$versionProps = Join-Path $root 'version.props'
$output = Join-Path $root 'out\cassotis_pinyin_transformer_ort.dll'
$intermediateDir = Join-Path $root 'out\_tmp_build\pinyin_transformer_ort'
$object = Join-Path $intermediateDir 'cassotis_pinyin_transformer_ort.obj'
$importLibrary = Join-Path $intermediateDir 'cassotis_pinyin_transformer_ort.lib'
$pdb = Join-Path $intermediateDir 'cassotis_pinyin_transformer_ort.pdb'
$resourceScript = Join-Path $intermediateDir 'cassotis_pinyin_transformer_ort.rc'
$resource = Join-Path $intermediateDir 'cassotis_pinyin_transformer_ort.res'
$vcvars = $VcVarsPath
if ($vcvars.Trim() -eq '') {
    $vcvars = @(
        'C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat',
        'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat',
        'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat',
        'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat'
    ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}
if ([string]::IsNullOrWhiteSpace($vcvars)) {
    throw 'Cannot find Visual Studio 2022 C++ vcvars64.bat. Use -VcVarsPath to specify it.'
}
$vcvars = (Resolve-Path -LiteralPath $vcvars).Path

foreach ($path in @($source, $include, $onnxLibrary, $versionProps, $vcvars)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing native build dependency: $path"
    }
}

New-Item -ItemType Directory -Path $intermediateDir -Force | Out-Null

[xml]$versionDocument = Get-Content -LiteralPath $versionProps -Encoding UTF8 -Raw
$versionNode = $versionDocument.SelectSingleNode(
    "/*[local-name()='Project']/*[local-name()='PropertyGroup']/*[local-name()='CassotisVersionQuad']")
if ($null -eq $versionNode) {
    throw "CassotisVersionQuad is missing from $versionProps"
}
$versionQuad = $versionNode.InnerText.Trim()
$versionParts = @($versionQuad.Split('.'))
if (($versionParts.Count -ne 4) -or
    ($versionParts | Where-Object {
        ($_ -notmatch '^\d+$') -or ([int64]$_ -gt 65535)
    })) {
    throw "Invalid CassotisVersionQuad in ${versionProps}: $versionQuad"
}
$versionComma = $versionParts -join ','
$resourceContent = @"
#include <windows.h>

1 VERSIONINFO
 FILEVERSION $versionComma
 PRODUCTVERSION $versionComma
 FILEFLAGSMASK 0x3fL
 FILEFLAGS 0x0L
 FILEOS VOS_NT_WINDOWS32
 FILETYPE VFT_DLL
 FILESUBTYPE 0x0L
BEGIN
    BLOCK "StringFileInfo"
    BEGIN
        BLOCK "040904B0"
        BEGIN
            VALUE "CompanyName", "Cassotis IME\0"
            VALUE "FileDescription", "Cassotis Pinyin Transformer ONNX Runtime Bridge\0"
            VALUE "FileVersion", "$versionQuad\0"
            VALUE "InternalName", "cassotis_pinyin_transformer_ort\0"
            VALUE "OriginalFilename", "cassotis_pinyin_transformer_ort.dll\0"
            VALUE "ProductName", "Cassotis IME\0"
            VALUE "ProductVersion", "$versionQuad\0"
        END
    END
    BLOCK "VarFileInfo"
    BEGIN
        VALUE "Translation", 0x0409, 1200
    END
END
"@
[System.IO.File]::WriteAllText($resourceScript, $resourceContent,
    (New-Object System.Text.UTF8Encoding($false)))

$optimization = if ($Configuration -ieq 'Debug') { '/Od /Zi' } else { '/O2 /GL' }
$experimentalDefines = @()
if ($EnableExperimentalContextualRecall) {
    $experimentalDefines += '/DCASSOTIS_EXPERIMENTAL_CONTEXTUAL_RECALL'
}
if ($EnableExperimentalTop32CrossRanker) {
    $experimentalDefines += '/DCASSOTIS_EXPERIMENTAL_TOP32_CROSS_RANKER'
}
$experimentalDefine = $experimentalDefines -join ' '
$command = 'call "{0}" >nul && rc.exe /nologo /fo"{9}" "{10}" && ' +
    'cl.exe /nologo /std:c++17 /EHsc /MD /LD {1} {11} ' +
    '/I"{2}" "{3}" /Fo"{4}" /link /LTCG /OUT:"{5}" ' +
    '/IMPLIB:"{6}" /PDB:"{7}" "{8}" "{9}"'
$command = $command -f $vcvars, $optimization, $include, $source, $object,
    $output, $importLibrary, $pdb, $onnxLibrary, $resource, $resourceScript,
    $experimentalDefine

& cmd.exe /d /s /c $command
if ($LASTEXITCODE -ne 0) {
    throw "Native ONNX wrapper build failed with exit code $LASTEXITCODE"
}

$builtVersionInfo = (Get-Item -LiteralPath $output).VersionInfo
if (($builtVersionInfo.FileVersion.Trim() -ne $versionQuad) -or
    ($builtVersionInfo.ProductVersion.Trim() -ne $versionQuad)) {
    throw "Native ONNX wrapper version resource mismatch: expected $versionQuad, " +
        "got file=$($builtVersionInfo.FileVersion) product=$($builtVersionInfo.ProductVersion)"
}

# Keep only the runtime DLL in out; linker artifacts are not release inputs.
$staleReleaseArtifacts = @(
    (Join-Path $root 'out\cassotis_pinyin_transformer_ort.exp'),
    (Join-Path $root 'out\cassotis_pinyin_transformer_ort.lib'),
    (Join-Path $root 'out\cassotis_pinyin_transformer_ort.obj')
)
foreach ($artifact in $staleReleaseArtifacts) {
    if (Test-Path -LiteralPath $artifact) {
        Remove-Item -LiteralPath $artifact -Force
    }
}

Write-Host "[pinyin-transformer] built $output version=$versionQuad"
