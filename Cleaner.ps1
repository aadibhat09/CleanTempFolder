$initialSize = 0
$clearedSize = 0

$tempFolders = @("C:\Windows\Temp\*",
                 "C:\Windows\SoftwareDistribution\Download\*",
                 "C:\Windows\Minidump\*",
                 "$home\AppData\Local\Temp\*",
                 "$home\AppData\Local\Microsoft\Windows\*"
                )

# Get initial folder sizes
foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        $files = Get-ChildItem -Path $folder -Recurse -ErrorAction SilentlyContinue
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
        $initialSize += $totalSize
    }
}

# Clear temp files
foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force 2>$null
    }
}

# Get the new folder sizes
foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        $files = Get-ChildItem -Path $folder -Recurse -ErrorAction SilentlyContinue
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
        $clearedSize += $totalSize
    }
}

# Calculate the space cleared in MB
$spaceClearedMB = [math]::Max([math]::Round(($initialSize - $clearedSize) / 1MB, 2), 0)

# Send notification
New-BurntToastNotification -Text "Temp files cleared", "$spaceClearedMB MB of temporary files have been cleared." -AppLogo "recycle.png"