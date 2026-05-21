# Gera a pasta dist/ para upload na Hostinger
$ErrorActionPreference = "Stop"
$root = (Resolve-Path $PSScriptRoot).Path
$dist = Join-Path $root "dist"

if (Test-Path -LiteralPath $dist) {
  Remove-Item -LiteralPath $dist -Recurse -Force
}
New-Item -ItemType Directory -LiteralPath $dist -Force | Out-Null
New-Item -ItemType Directory -LiteralPath (Join-Path $dist "assets") -Force | Out-Null

$deployExtras = Join-Path $root "deploy"
if (Test-Path -LiteralPath $deployExtras) {
  Copy-Item -LiteralPath (Join-Path $deployExtras "*") -Destination $dist -Force
}

$rootFiles = @(
  "index.html",
  "hero.jpg",
  "dr-wellington.jpg",
  "logo-cutout.png",
  "favicon.png",
  "whatsapp.png",
  "reel-prova-vida.jpg",
  "reel-beneficio-inss.jpg",
  "reel-quilombolas.jpg"
)

foreach ($f in $rootFiles) {
  $src = Join-Path $root $f
  if (-not (Test-Path -LiteralPath $src)) {
    throw "Arquivo obrigatorio ausente: $f"
  }
  Copy-Item -LiteralPath $src -Destination (Join-Path $dist $f) -Force
}

$assetFiles = @(
  "hero.jpg",
  "dr-wellington.jpg",
  "logo-cutout.png",
  "favicon.png",
  "whatsapp.png"
)

foreach ($f in $assetFiles) {
  $src = Join-Path $root $f
  if (Test-Path -LiteralPath $src) {
    Copy-Item -LiteralPath $src -Destination (Join-Path $dist "assets" $f) -Force
  }
}

Write-Host ""
Write-Host "dist/ gerado com sucesso:" -ForegroundColor Green
Write-Host $dist
Write-Host ""
Get-ChildItem -LiteralPath $dist -Recurse -File | Select-Object @{N='Arquivo';E={$_.FullName.Replace($dist + '\', '')}}, @{N='KB';E={[math]::Round($_.Length/1KB,1)}}
