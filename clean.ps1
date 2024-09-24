$PathToTempFolder = "$home\AppData\Local\Temp"
$OriginalSize = (Get-ChildItem "$PathToTempFolder" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB

Remove-Item -Path $PathToTempFolder -Recurse -Force 2>$null

$NewSize = (Get-ChildItem "$PathToTempFolder" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
$SizeDifference = [int]($OriginalSize - $NewSize)

New-BurntToastNotification -Text "Temp folder cleared", "$SizeDifference MB has been cleared from the temp folder." -AppLogo "C:\Users\aadib\Aadi\Scripts\CleanTempFolder\recycle.png"