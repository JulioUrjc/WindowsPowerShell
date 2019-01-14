
# GetInfo localhost
Function GetInfo
{
    [CmdletBinding()]
    #PARAM ($ComputerName)
    # Computer System
    $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName "localhost" #$ComputerName
    # Operating System
    $OperatingSystem = Get-WmiObject -Class win32_OperatingSystem -ComputerName "localhost" #$ComputerName
    # BIOS
    $Bios = Get-WmiObject -class win32_BIOS -ComputerName "localhost" #$ComputerName
    
    # Prepare Output
    $Properties = @{
        ComputerName = "localhost" #$ComputerName
        Manufacturer = $ComputerSystem.Manufacturer
        Model = $ComputerSystem.Model
        OperatingSystem = $OperatingSystem.Caption
        OperatingSystemVersion = $OperatingSystem.Version
        SerialNumber = $Bios.SerialNumber
    }
    
    # Output Information
    New-Object -TypeName PSobject -Property $Properties
    Get-WmiObject -query "select * from CIM_Processor" | Group-Object Description
    MSINFO32
    
}

# GetProgsVersion
Function GetProgsVersion{
    $phpversion =  php -v | grep ^PHP | cut -d' ' -f2
    "PHP version: $phpversion" 
    echo ""

    $pythonversion = python --version
    "Python version: $pythonversion" 
    echo ""

    "PowerShell version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"
    echo ""
}

# Function word
Function word{

    $file = "C:\Users\jmn6\Desktop\word.docx"
    $i= 0       

    while(Test-Path $file)
    {
        $i++
        $file = "C:\Users\jmn6\Desktop\word($i).docx"
    }

    touch $file 
    wordexe $file  
}

# Function serial
Function serial{
  wmic path softwarelicensingservice get OA3xOriginalProductKey
}