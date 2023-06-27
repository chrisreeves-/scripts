Install-Module -Name PSWindowsUpdate -Force
$updates = Get-WindowsUpdate -MaxUpdatesPerDownload 100 -MaxUpdatesPerInstall 100
if ($updates.Count -eq 0) {
    Write-Host "No updates found."
} else {
    Write-Host "Found $($updates.Count) update(s). Installing..."
    Install-WindowsUpdate -AcceptAll #-AutoReboot
}