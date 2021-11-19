$host.ui.RawUI.WindowTitle = "Printer Export"

$PrinterDefault = Get-WmiObject win32_printer | Where-Object {$_.Default -eq $true} | Select-Object Name
$Printers =  Get-Printer | Where-Object {$_.Type -ne "Local"} | Select-Object Name
$PrinterList = @()

foreach($Printer in $Printers){
    $default = $null
    if ($Printer.Name -like $PrinterDefault.Name) {
        $default = $true
    }
    [array]$PrinterList += [pscustomobject]@{
        'Name' = $Printer.Name
        'Default' = $default
    }
}

$PrinterList | Export-Csv C:\Temp\Printers.csv -NoTypeInformation