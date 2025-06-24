param(
    [string]$Prefix = 'C:\djgpp'
)

$Version = 'v3.4'
$Archive = 'djgpp-mingw-gcc1220.zip'
$Sha256 = '49defad7bcf4228cddd5f36c0ad570a9a1560db686e3b34f3cc6b4b2eed2c842'
$Url = "https://github.com/andrewwutw/build-djgpp/releases/download/$Version/$Archive"

$TempFile = [System.IO.Path]::GetTempFileName()
Invoke-WebRequest -Uri $Url -OutFile $TempFile
$ActualHash = (Get-FileHash -Algorithm SHA256 $TempFile).Hash.ToLower()
if ($ActualHash -ne $Sha256) {
    Write-Error "SHA256 mismatch. Expected $Sha256 but got $ActualHash"
    exit 1
}

Expand-Archive -Path $TempFile -DestinationPath $Prefix -Force
Remove-Item $TempFile

Write-Host "DJGPP cross compiler installed to $Prefix."
Write-Host "Add $Prefix\bin to your PATH and restart your shell."
