####### MODULO EXTRAS #######

Function GetInfo
{
    <#
    .SYNOPSIS
      Muestra informacion del portatil
    .DESCRIPTION 
      Muestra informacion del portatil
    
    .EXAMPLE 
      GetInfo  
   #> 

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


Function GetProgsVersion{
    <#
    .SYNOPSIS
      Muestra versiones de programas
    .DESCRIPTION 
      Muestra versiones de los programas php, python y powershell
    
    .EXAMPLE 
      GetInfo  
   #> 

    $phpversion =  php -v | select-string ^PHP | cut -d' ' -f2
    "PHP version: $phpversion" 
    echo ""

    $pythonversion = python --version
    "Python version: $pythonversion" 
    echo ""

    "PowerShell version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"
    echo ""
}


Function word{
    <#
    .SYNOPSIS
      Inicia un word en el escritorio y lo abre
    .DESCRIPTION 
      Inicia un word en blanco en el escritorio y lo abre
    
    .EXAMPLE 
      word  
   #> 

    $file = "$env:userprofile\Desktop\word.docx"
    $i= 0       

    while(Test-Path $file)
    {
        $i++
        $file = "$env:userprofile\Desktop\word($i).docx"
    }

    touch $file 
    wordexe $file  
}

# Function serial
Function serial{
  (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
}


Function cuentaAtras
{
    <#
    .SYNOPSIS
      Inicia una cuenta atras
    .DESCRIPTION 
      Inicia una cuenta atras desde un tiempo dado en milisegundos
    
    .EXAMPLE 
      cuentaAtras $time  
   #> 

    $Longitud1 = 0
    $Longitud2 = 0
    ""
    Write-Host "Elemento N      " -NoNewLine
    $args[0]..0| ForEach{ `
        Start-Sleep -Milliseconds 5
        $Incremento = $Longitud1 - $Longitud2
        $Longitud1 = ("{0:N0}" -f ($_ + 1)).Length
        $Numero = "{0:N0}" -f $_
        $Longitud2 = $Numero.Length
        $Borrado = " " * ($Longitud1 - $Longitud2)
        $Retroceso = "`b" * ($Longitud1 + $Incremento)
        Write-Host "$Retroceso$Numero$Borrado" -NoNewLine
    }
}

Function seguridad{  Get-ExecutionPolicy -List}

Function inicio{ Get-WmiObject -Class win32_startupCommand }

Function shader {glslangValidator -V $args[0]}

<<<<<<< HEAD

Export-ModuleMember -function GetInfo, GetProgsVersion, word, cuentaAtras, seguridad, inicio, shader
=======
Export-ModuleMember -function GetInfo, GetProgsVersion, word, serial, cuentaAtras, seguridad, inicio
>>>>>>> 1ab11d943e0f83057ee3893ab50a01816dfd06a2
