####### MODULO INFO #######

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


Function GetVersion
{
    <#
    .SYNOPSIS
      Muestra versiones de programas
    .DESCRIPTION 
      Muestra versiones de los programas python, powershell, Ruby, Bundler, Jekyll
    
    .EXAMPLE 
      GetVersion  
   #> 

    $pythonversion = python --version
    "Python version: $pythonversion" 
    echo ""

    "PowerShell version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"
    echo ""

    $rubyversion = ruby -v
    "Ruby version: $rubyversion" 
    echo ""

    $bundlerversion = bundler -v
    "Bundler version: $bundlerversion" 
    echo ""

    $jekyllversion = bundle exec jekyll -v
    "Jekyll version: $jekyllversion" 
    echo ""
}


Function serial{
  <#  
    .SYNOPSIS  
       Muestra serial de windows  
    .DESCRIPTION 
       Muestra serial de windows    
    .EXAMPLE 
      serial 
   #> 
  (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
}

Function path{ 
   <#  
    .SYNOPSIS  
       Muestra el path  
    .DESCRIPTION 
       Muestra el path en una ventana    
    .EXAMPLE 
      path 
   #> 
  $pathJuly = $env:Path; $pathJuly.split(";") | Out-GridView
}

Function ram {
    <#  
    .SYNOPSIS  
       Muestra el uso de ram
    .DESCRIPTION 
       Muestra el uso de los 10 primeros programas que mas ram usen o el número que se le pase por parametro 
    .EXAMPLE 
      ram 
    .EXAMPLE 
      ram $num
   #> 
  PARAM ([int]$cuantos = 10)
  get-process |sort-object pm -desc | select-object -first $cuantos
}

Function cpu {
    <#  
    .SYNOPSIS  
       Muestra el uso de cpu
    .DESCRIPTION 
       Muestra el uso de los 10 primeros programas que mas cpu usen o el número que se le pase por parametro 
    .EXAMPLE 
      cpu 
    .EXAMPLE 
      cpu $num
   #> 
  PARAM ([int]$cuantos = 10)
  get-process |sort-object cpu -desc | select-object -first $cuantos
}

Function slotsram {Get-WmiObject -class "Win32_PhysicalMemoryArray"}
Function inforam{Get-WmiObject -class "Win32_PhysicalMemory" | Measure-Object -Property Capacity -Sum;}
Function inforam2{Get-WmiObject -class "Win32_PhysicalMemory" | FT PSComputerName,Name,DeviceLocator,Manufacturer,Capacity,SerialNumber;}

Function seguridad{  Get-ExecutionPolicy -List}

Function funciones{  

    <#  
    .SYNOPSIS  
       Muestra las funciones de los modulos
    .DESCRIPTION 
       Muestra las funciones de los modulos
    .EXAMPLE 
      funciones 
    .EXAMPLE 
      funciones $num
   #>
    PARAM([int]$numModules = 13)

	$funciones = Get-Module -ListAvailable | select-object Name -first $numModules

	ForEach ($item in $funciones)
	{	
    if($item.Name -eq "ImportExcel"){ continue; }
    Write-Host ""
		$item.Name
		$func = Get-Command -Module $item.Name | select-object Name
    $par= 0
		ForEach ($name in $func)
		{
      if($par%2 -eq 0)
      {
        Write-Host ("{0,20}" -f $name.Name) -foregroundcolor "Cyan" -noNewLine
      }else{
        Write-Host ("{0,30}" -f $name.Name) -foregroundcolor "Cyan"
      }  
      $par++ 
		}
	}

  Write-Host ""
  Write-Host "Profile"
  $funciones = Get-Command | where{$_.source -eq ""} | Select-Object Name
  $par= 0
    ForEach ($name in $funciones)
    {
      if( $name -notmatch "[A-Z]:" -AND $name -notmatch "TabExpansion2|more|Pause|ImportSystemModules|cd..|Get-Verb|Clear-Host|oss|mkdir|help" )
      {
        if($par%4 -eq 0)
        {
          Write-Host ("{0,10}" -f $name.Name) -foregroundcolor "Cyan" -noNewLine
        }elseif($par%4 -eq 1){
          Write-Host ("{0,20}" -f $name.Name) -foregroundcolor "Cyan" -noNewLine
        }elseif ($par%4 -eq 2){
          Write-Host ("{0,25}" -f $name.Name) -foregroundcolor "Cyan" -noNewLine
        } else{
          Write-Host ("{0,30}" -f $name.Name) -foregroundcolor "Cyan"
        }   
        $par++ 
      } 
    }
}

Function scripts{  

  <#  
    .SYNOPSIS  
       Muestra los scripts
    .DESCRIPTION 
       Muestra los scripts
    .EXAMPLE 
      scripts 
   #>

   $dir = ([system.io.fileinfo]$profile).DirectoryName 
   $scripts = ls $dir/Scripts *.ps1 | %{$_.BaseName}
   ForEach ($name in $scripts)
   {
     Write-Host ("  ${name}")  -foregroundcolor "Cyan"
   }  
}

Function puertos{
    <#  
    .SYNOPSIS  
       Muestra los puertos escuchando
    .DESCRIPTION 
       Muestra los puertos escuchando
    .EXAMPLE 
      puertos 
   #>
  NETSTAT -AN|FINDSTR /C:LISTENING
}

Function pingP{
    <#  
    .SYNOPSIS  
       ping a ip y puerto especifico
    .DESCRIPTION 
       ping a ip y puerto especifico
    .EXAMPLE 
      pingP $ip $puerto 
   #>

  PARAM( $ip,
         $puerto)
  $ping = New-Object System.Net.Networkinformation.ping
  $ping.Send($ip, $puerto)
}

Function tcpP{
   <#  
    .SYNOPSIS  
       Conexion tcp
    .DESCRIPTION 
       Conexion tcp a ip y puerto especificos
    .EXAMPLE 
      tcpP $ip $puerto 
   #>

  PARAM( $ip,
         $puerto)
  $tcpClient = New-Object System.Net.Sockets.TCPClient
  $tcpClient.Connect($ip, $puerto)
}

Function inventario{
   <#  
    .SYNOPSIS  
       inventario de ordenadores de red
    .DESCRIPTION 
       Inventario en excel, pasando el nombre de los ordenadores por fichero
    .EXAMPLE 
      inventario $ordenadoresFile
   #>

      PARAM( $ordenadoresFile="nombreOrdenadores.txt")

  get-Content $ordenadoresFile | ipsdinamicas.ps1 | Export-Excel -Path inventario.xlsx -AutoSize -BoldTopRow -AutoFilter -ConditionalText $(
  New-ConditionalText FALSO
  New-ConditionalText VERDADERO -BackgroundColor LightGreen -ConditionalTextColor DarkGreen)-IncludePivotTable -PivotTableName TablaDinamica -PivotRows IsDHCPEnabled -PivotData ComputerName -PivotColumns IPAddress
}

Function espacio{
   # Function espacioC {Gwmi -class Win32_volume | select name, capacity | where {$_.name -like "c*"}}
   <#  
    .SYNOPSIS  
       Espacio disponible en todos los discos
    .DESCRIPTION 
       Espacio disponible en todos los discos
    .EXAMPLE 
      espacio
   #>

  Get-WmiObject -Class Win32_logicaldisk | Format-Table -Property @{
      Name       = 'Unidad'
      Expression = {$_.DeviceID}
  }, @{
      Name       = 'TamanoTotal(GB)'
      Expression = {[decimal]('{0:N0}' -f($_.Size/1gb))}
  }, @{
      Name       = 'Disponible(GB)'
      Expression = {[decimal]('{0:N0}'-f($_.Freespace/1gb))}
  }, @{
      Name       = 'Disponible(%)'
      Expression = {'{0,6:P0}' -f(($_.Freespace/1gb) / ($_.size/1gb))}
  } -AutoSize
}



Export-ModuleMember -function GetInfo, GetVersion, serial, seguridad, path, ram, cpu,slotsram, inforam, inforam2, funciones, scripts, puertos, pingP, tcpP, inventario, espacio

