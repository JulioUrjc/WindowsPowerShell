
# GetInfo -ComputerName localhost
Function GetInfo
{
    [CmdletBinding()]
    PARAM ($ComputerName)
    # Computer System
    $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName
    # Operating System
    $OperatingSystem = Get-WmiObject -Class win32_OperatingSystem -ComputerName $ComputerName
    # BIOS
    $Bios = Get-WmiObject -class win32_BIOS -ComputerName $ComputerName
    
    # Prepare Output
    $Properties = @{
        ComputerName = $ComputerName
        Manufacturer = $ComputerSystem.Manufacturer
        Model = $ComputerSystem.Model
        OperatingSystem = $OperatingSystem.Caption
        OperatingSystemVersion = $OperatingSystem.Version
        SerialNumber = $Bios.SerialNumber
    }
    
    # Output Information
    New-Object -TypeName PSobject -Property $Properties
    
}

# GetProgsVersion
function GetProgsVersion{
    $phpversion =  php -v | grep ^PHP | cut -d' ' -f2
    "PHP version: $phpversion" 
    echo ""

    $pythonversion = python --version
    "Python version: $pythonversion" 
    echo ""

    "PowerShell version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"
    echo ""
}