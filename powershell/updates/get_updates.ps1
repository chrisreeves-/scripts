Install-Module -Name PSWindowsUpdate -Force
$updates = Get-WindowsUpdate
if ($updates.Count -eq 0) {
    Write-Host "No updates found."
} else {
    Write-Host "Found $($updates.Count) update(s). Installing..."
    Install-WindowsUpdate -AcceptAll #-AutoReboot
}