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

Function cuenta
{
   <#
    .SYNOPSIS
      Inicia una cuenta
    .DESCRIPTION 
      Inicia una cuenta hasta un tiempo dado en milisegundos
    
    .EXAMPLE 
      cuenta $time  
   #> 
    PARAM(
        [int]$time = 10
    )

    Write-Host -NoNewLine "Counting from 1 to ${time} (in seconds):  "

    $tercio = $time * 1/3

    if ($time -eq 1)
    {
         Write-Host -NoNewLine  "1 " -BackgroundColor "Green" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
    }

    if($time -gt 1)
    {
       $tercio = $time * 1/3
       foreach($element in 1..$tercio){
         Write-Host -NoNewLine  "${element} " -BackgroundColor "Green" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
       }
    

       if($time -gt 2)
       {
          $tercio++
          $dostercios = $time * 2/3
          foreach($element in $tercio..$dostercios){
            Write-Host -NoNewLine  "${element} " -BackgroundColor "Yellow" -ForegroundColor "Black"
            Start-Sleep -Seconds 1
          }
       }else{
         Write-Host -NoNewLine  "2 " -BackgroundColor "Yellow" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
       }

       if($time -gt 2)
       {
          $dostercios++
          foreach($element in $dostercios..$time){
            Write-Host -NoNewLine  "${element} " -BackgroundColor "Red" -ForegroundColor "Black"
            Start-Sleep -Seconds 1
          }
       }
    }

    Write-Host ""
    Write-Host ""
    Write-Host "FIN !!!"
}

Function seguridad{  Get-ExecutionPolicy -List}

Function inicio{ Get-WmiObject -Class win32_startupCommand }

Function shader {glslangValidator -V $args[0]}

Export-ModuleMember -function GetInfo, GetProgsVersion, word, serial, cuentaAtras, seguridad, inicio, shader, cuenta

