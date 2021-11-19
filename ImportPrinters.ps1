#Transfer Printers
Write-Host "Beginning to Restore Printers, this may take a few minutes and will generate a few errors."

$CurrentPrinters =  Get-Printer | Where-Object {$_.Type -ne "Local"} | Select-Object Name

Import-Csv -LiteralPath "C:\Temp\Printers.csv" | ForEach-Object {
    if ($CurrentPrinters.Name -contains $_.Name) {
        Write-Host "The following printer is already installed $($_.Name)"
    }else{
        Write-Host "Adding Printer $($_.Name)"
        #Add-Printer -ConnectionName $_.Name -erroraction 'silentlycontinue'
        (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection($_.Name)
    }
    if ($_.Default -eq $true -and (Get-Printer | Where-Object {$_.Type -ne "Local"} | Select-Object Name) -contains (-not($_.Name))) {
        Write-Host "Setting printer $($_.Name) as default"
        (New-Object -ComObject WScript.Network).SetDefaultPrinter($_.Name)
    }
}