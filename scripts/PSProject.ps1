<# 
Christopher Ross
cross25@uis.edu
CSC386 Powershell Project
10/25/2017

PowerShell Project

Sources Used:

how to use -fragment to break up html output
https://stackoverflow.com/questions/16542729/send-multiple-outputs-to-the-same-html-file-in-powershell#16547049

-how to add more css style
https://technet.microsoft.com/en-us/library/ff730936.aspx

how to return only the value of a property:
https://www.reddit.com/r/PowerShell/comments/3lyaxt/selectobject_and_return_only_the_value_not_the/

converting bytes to gygabytes
https://stackoverflow.com/questions/17748325/powershell-converting-from-bytes-into-gigabytes

sorting using the sort-object
https://technet.microsoft.com/en-us/library/ee176968.aspx
#>

#create and assign html file to a variable
$html = "SystemInfo.html"

#set style variables to format html
$a = "<style>"
$a = $a + "BODY{background-color:#000033;}"
$a = $a + "H1{color:white; text-align: center;}"
$a = $a + "H2{color:#90c8ff;}"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 2px;padding: 4px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 2px;padding: 4px;border-style: solid;border-color: black;background-color:#e6e6e6}"
$a = $a + "</style>"

#variables to be displayed in html, many of which use ConvertTo-Html fragments
$SysName = Get-WmiObject -Class Win32_BIOS | Select -ExpandProperty PSComputerName 
$Date = Get-Date
$System = Get-CimInstance -ClassName Win32_ComputerSystem | Select Manufacturer, Model, 
                SystemType, TotalPhysicalMemory, Domain | ConvertTo-Html -As Table -Fragment
$Boot = Get-WmiObject -Class Win32_BootConfiguration | Select BootDirectory, 
                Description |  ConvertTo-Html -As Table -Fragment
$Bios = Get-CimInstance -ClassName Win32_BIOS | Select Manufacturer, SMBIOSBIOSVersion, 
                Version, SerialNumber, ReleaseDate | ConvertTo-Html -As Table -Fragment
$OS = Get-WmiObject -Class Win32_OperatingSystem | Select Caption, Version, BuildNumber, 
                OSArchitecture, OSLanguage | ConvertTo-Html -As Table -Fragment
$TimeZone = Get-WmiObject -Class Win32_TimeZone | Select StandardName, Caption | 
                ConvertTo-Html -As Table -Fragment
$LogicalDisk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType='3'" | Select Caption, Description, 
                FileSystem, @{n='FreeSpace(GB)';e={[int]($_.FreeSpace/1GB)}},
                @{n='Size(GB)';e={[int]($_.Size/1GB)}} | ConvertTo-Html -As Table -Fragment
$Processor = Get-WmiObject -Class Win32_Processor | select Name, Manufacturer, NumberOfCores,ThreadCount, 
                MaxClockSpeed, CurrentClockSpeed | ConvertTo-Html -As Table -Fragment
$Memory = Get-WmiObject -Class Win32_PhysicalMemory  | select Tag, Manufacturer, SerialNumber, PartNumber,
                @{n='Capacity(GB)';e={[int]($_.Capacity/1GB)}}, DeviceLocator | 
                ConvertTo-Html -As Table -Fragment
$Product = Get-WmiObject -Class Win32_Product | Select Vendor, Name, Version, Caption | Sort-Object Vendor |
                ConvertTo-Html -As Table -Fragment

#Converts all the Html fragments generated above into a single html document with appropriate headers
ConvertTo-HTML -head $a  -Body "<H1>$SysName $Date</h1> 
    <H2>Computer System Information</H2> $System
    <H2>Boot Partition Information</H2> $Boot
    <H2>System BIOS Information</H2> $Bios
    <H2>Operating System Information</H2> $OS
    <H2>Time Zone Data</H2> $TimeZone
    <H2>Logical Disk Information</H2> $LogicalDisk
    <H2>System Processor Information</H2> $Processor
    <H2>Physical Memory</H2> $Memory
    <H2>Installed Software Inventory</H2> $Product" | Out-File $html

#Open the html file to display results
ii $html