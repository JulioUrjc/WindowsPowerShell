function Get-prueba {
    [cmdletbinding()]
    param()
    Write-Output "Esto es una prueba"
    Write-Verbose "Verbose Message from internal function"    
}

function GetInfo{
    param($ComputerName)
    Get-WmiObject -ComputerName $ComputerName -Class Win32_BIOS
}

GetInfo -ComputerName localhost