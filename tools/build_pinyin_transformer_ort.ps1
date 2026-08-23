param(
    [string]$Configuration = 'Release',
    [string]$VcVarsPath = ''
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root 'src\host\native\nc_pinyin_transformer_ort.cpp'
$include = Join-Path $root 'third_party\onnxruntime\include'
$onnxLibrary = Join-Path $root 'third_party\onnxruntime\win64\onnxruntime.lib'
$output = Join-Path $root 'out\nc_pinyin_transformer_ort.dll'
$object = Join-Path $root 'out\nc_pinyin_transformer_ort.obj'
$importLibrary = Join-Path $root 'out\nc_pinyin_transformer_ort.lib'
$pdb = Join-Path $root 'out\nc_pinyin_transformer_ort.pdb'
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

foreach ($path in @($source, $include, $onnxLibrary, $vcvars)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing native build dependency: $path"
    }
}

$optimization = if ($Configuration -ieq 'Debug') { '/Od /Zi' } else { '/O2 /GL' }
$command = 'call "{0}" >nul && cl.exe /nologo /std:c++17 /EHsc /MD /LD {1} ' +
    '/I"{2}" "{3}" /Fo"{4}" /link /LTCG /OUT:"{5}" ' +
    '/IMPLIB:"{6}" /PDB:"{7}" "{8}"'
$command = $command -f $vcvars, $optimization, $include, $source, $object,
    $output, $importLibrary, $pdb, $onnxLibrary

& cmd.exe /d /s /c $command
if ($LASTEXITCODE -ne 0) {
    throw "Native ONNX wrapper build failed with exit code $LASTEXITCODE"
}

Write-Host "[pinyin-transformer] built $output"
