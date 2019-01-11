Import-Module -Name "C:\Users\jmn6\Documents\WindowsPowerShell\Scripts\moduloExtra.psm1"
Import-Module -Name "C:\Users\jmn6\Documents\WindowsPowerShell\Scripts\moduloCifrado.psm1"

Function memoriaram {get-process |sort-object pm -desc | select-object -first 10}
Function ram {get-process |sort-object pm -desc | select-object -first $args[0]}
Function slotsram {Get-WmiObject -class "Win32_PhysicalMemoryArray"}
Function inforam{Get-WmiObject -class "Win32_PhysicalMemory" | Measure-Object -Property Capacity -Sum;}
Function inforam2{Get-WmiObject -class "Win32_PhysicalMemory" | FT PSComputerName,Name,DeviceLocator,Manufacturer,Capacity,SerialNumber;}

Function usoCPU {get-process |sort-object cpu -desc | select-object -first 10}
Function cpu {get-process |sort-object cpu -desc | select-object -first $args[0]}
Function espacioC {Gwmi -class Win32_volume | select name, capacity | where {$_.name -like "c*"}}
Function admin {Start-Process powershell -Verb runAs; exit}
Function orden {ls | sort $args[0] | select $args[0]}
Function buscar {ls -r -i * | select-string $args[0]}
Function busca([string] $ext) {ls -r -i *.$ext | select-string $args[0]}
#Function virtualMachineCopy {"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonehd "$args[0]\Ubuntu.vdi" "$args[0]\Ubuntu_25.vdi" --existing}

Function profileDir{abrir ([system.io.fileinfo]$profile).DirectoryName}
Function profileFile{ sublime $profile }
Function path{ $pathJuly = $env:Path; $pathJuly.split(";") | Out-GridView}
Function job { Start-job { $args[0] } -Name trabajoJuly }
Function jobResult { Get-Job -Name trabajoJuly | Receive-Job }
Function pw { start powershell }
Function pwi { start powershell ISE; exit}
Function ip { ipconfig | FINDSTR "Dirección IPv4" }
Function ipp {  Invoke-RestMethod http://ipinfo.io/json | Select -exp ip }
Function ippublic { wget "http://checkip.amazonaws.com/"  | Select -exp RawContent }

Function gui { cd /xflow/gui}
Function common { cd /xflow/common}
Function home { cd $home }

Function workstation
{
  ssh julio@192.168.86.154
}

Function dumpbin
{
	cd "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"

	.\dumpbin.exe $args[0] $args[1]
}

Function comprimir{
   ls -name
   $input = Read-Host "Va a comprimir estos ficheros, esta seguro y/n?"
   if($input -Match "y")
   {
      $files = ls -name; 
      foreach ( $file in $files )
      { 
         $zipname = $file + ".7z" 
         sz a -sdel $zipname $file    
      }
      sz a -sdel "$args.7z" *.*
   }
}

Function descomprimir{
   ls -name *.zip
   $input = Read-Host "Va a comprimir estos ficheros, esta seguro y/n?"
   if($input -Match "y")
   {
     sz x *.zip -o*
   }
}

Function cuentaAtras
{
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


#################### Alias #################################

set-alias grep       select-string
set-alias fecha      Get-Date
set-alias sublime    "C:\Program Files\Sublime Text 3\sublime_text.exe"
set-alias abrir      explorer.exe
set-alias sz         "C:\Program Files\7-Zip\7z.exe"
set-alias view       Out-GridView
set-alias columna    Select-Object
set-alias cal        C:\Users\jmn6\Documents\WindowsPowerShell\Scripts\Cal.ps1
set-alias slicer     "C:\Program Files\slicer\Slic3r.exe"
set-alias repetier   "C:\Program Files\Repetier-Host\RepetierHost.exe"
set-alias kraken     "C:\Users\jmn6\AppData\Local\gitkraken\app-4.1.1\gitkraken.exe"
set-alias wordexe    "C:\Program Files (x86)\Microsoft Office\Office16\winword.exe"

############################################################
#################### SSH ###################################

#Function sshStart
#{
#	New-SSHSession -ComputerName $args[0] -Credential (Get-Credential)
#}
#
#Function ssh
#{
#	Invoke-SshCommand -InvokeOnAll -Command $args[0]
#}
#
#Function ssh([int] $id) 
#{
#  Invoke-SshCommand -SessionId $id -Command $args[0]
#}
#
#Function sshCloseId
#{
#  Remove-SSHSession -SessionId $args[0]
#}
#
#Function sshClose
#{
#  Remove-SSHSession -RemoveAll
#}

############################################################
#################### Pipe ##################################

Function writePipe
{
  $name = 'foo'
  $namedPipe = New-Object IO.Pipes.NamedPipeServerStream($name, 'Out')
  $namedPipe.WaitForConnection()
  
  $script:writer = New-Object IO.StreamWriter($namedPipe)
  $writer.AutoFlush = $true
  $writer.WriteLine('something')
  $writer.Dispose()
  
  $namedPipe.Dispose()
}

Function readPipe
{
  $name = 'foo'
  $namedPipe = New-Object IO.Pipes.NamedPipeClientStream('.', $name, 'In')
  $namedPipe.Connect()
  
  $script:reader = New-Object IO.StreamReader($namedPipe)
  $reader.ReadLine()
  $reader.Dispose()
  
  $namedPipe.Dispose()
}

############################################################


#(Get-Item $FileNamePath ).Extension
#(Get-Item $FileNamePath ).Basename
#(Get-Item $FileNamePath ).Name
#(Get-Item $FileNamePath ).DirectoryName
#(Get-Item $FileNamePath ).FullName
#PS C:\Users\jmn6> dir "C:\Program Files" -File -Recurse | Sort-Object Count -Descending | Select-Object Name, Count | Out-GridView
#Save-Help -Force -UICulture "en-us" -DestinationPath C:\PowerShell-Help
#Update-Help -Force -UICulture "en-us" -SourcePath C:\PowerShell-Help
#$env:PSModulePath
#systeminfo | Select-String "^OS Name","^OS Version"
#Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
#ipconfig | select-string -pattern 192
#Function cumple 
#{ 
#  $cumple = ((Get-Date -Month 03 -Day 11 -Year 2019) - (Get-Date)).Days+1 
#  echo "Dias para mi cumple: $cumple" 
#}

############################################################

Function inicio2
{ 
    $option = random 6

    switch ( $option )
    {
        0 { logo0  }
        1 { logo0  }
        2 { logo0  }
        3 { logo4  }
        4 { logo4  }
        5 { logo4  }
    }
}

Function logo0
{
	 echo "
                                          .::!!!!!!!:.
         .!!!!!:.                        .:!!!!!!!!!!!! 
         ~~~~!!!!!!.                 .:!!!!!!!!!UWWWSSS 
             :SSNWX!!:           .:!!!!!!XUWWSSSSSSSSSP
             SSSSSOOWX!:      .<!!!!UWSSSS*  SSSSSSSSO
             SSSSS  SSSUX   :!!UWSSSSSSSSS   4SSSSS*
             ^SSSB  SSSS\     SSSSSSSSSSSS   dSSR*
               **SbdSSSS      **SSSSSSSSSSSo+#*
                    ****          ********
     "
}

Function logo1
{
     echo "
	       _,    _   _    ,_
          .o888P     Y8o8Y     Y888o.
         d88888      88888      88888b
        d888888b_  _d88888b_  _d888888b
        8888888888888888888888888888888
        8888888888888888888888888888888
        YJGS8P*Y888P*Y888P*Y888P*Y8888P
         Y888   '8'   Y8P   '8'   888Y
          '8o          V          o8'
            '                     '
     "
}

Function logo2
{
    echo "
    
           /===    \      I//|  |  |  ||  ||  |  |  |\\I      /===    \
           \==     /   ! /|/ |  |  |  ||  ||  |  |  | \|\ !   \==     /
            \_____/    I//|  |  |  |_/_ /_  _ |  |  |  |\\I    \_____/
             _} {_  ! /|/ |  |  |   (_ / / (/_   |  |  | \|\ !  _} {_
            {_____} I//|  |  |  |  |  ||  ||  |  |  |  |  |\\I {_____}
       !  !  |=  |=/|/ |  |  |  |  |  ||  ||  |  |  |  |  | \|\=|-  |  !  ! 
      _I__I__|   ||/ ____  ___ ___ ____  ___   ____ __     __ \||   |__I__I_
      -|--|--|-  || / __//| ||| ||/ _ \\|   \\/   \\||| _ | || ||=  |--|--|-
      _|__|__|   || \__ \\|     || //\ || | ||  | || ||/\\| || ||-  |__|__|_
      -|--|--|   || /___//|_|||_||_|||_||___//\___//\__/\__//  ||   |--|--|- 
       |  |  |=  ||           ____  ____  _____  ____          ||   |  |  | 
       |  |  |   || |  |  |  /  _||/ _ \\|_   _|| __|| |  |  | ||=  |  |  | 
       |  |  |-  || |  |  | |  | \\ //\ || | || | _||  |  |  | ||   |  |  | 
       |  |  |   || |  |  |  \___||_|||_|| |_|| |___|| |  |  | ||=  |  |  |
       |  |  |=  || |  |  |                            |  |  | ||   |  |  |
       |  |  |   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||   |  |  |
       |  |  |   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||-  |  |  |
      _|__|__|   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||=  |__|__|_
      -|--|--|=  || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||   |--|--|-
      _|__|__|   ||_|__|__|__|__|__|__||  ||__|__|__|__|__|__|_||-  |__|__|_
      -|--|--|=  ||-|--|--|--|--|--|--||  ||--|--|--|--|--|--|-||=  |--|--|-
          |  |-  || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||-  |  |  |
     ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~
    "
}

Function logo3
{
    echo "	
     ____.     .__                _____       .___      .__        
    |    |__ __|  | ___.__.      /  _  \    __| _/_____ |__| ____  
    |    |  |  \  |<   |  |     /  /_\  \  / __ |/     \|  |/    \ 
/\__|    |  |  /  |_\___  |    /    |    \/ /_/ |  Y Y  \  |   |  \
\________|____/|____/ ____|    \____|__  /\____ |__|_|  /__|___|  /
                    \/                 \/      \/     \/        \/  
    "
}

Function logo4
{
    echo "  
                     IIIIIIIII MMM                           
          ::III    IIII:::::: MMM                            
            III  II= MMM     MMMM  SMMMMM,  MM          =MM  
            ,IIIII ,MMMMMMM ,MMM MMMMMMMMM ,MM   MMMM  SMM  
             III,  MMMMMMM  MMM MMM     MMM MM  MMMMM =MM    
          =IIIIII MMMM     MMM MMM=    =MMM MM MMSMMMMMM,    
        IIIII III,MMM      MMM MMM     MMM MMMMM= MMMMM,     
      IIIII   II MMM      MMM  MMMM  MMMM, MMMMS  MMMM       
    IIIIII     IMMM      MMM    MMMMMMM=   MMM=   MMM        
    "
}

#################### Admin #################################

Function Test-administrator { 
	$user = [Security.Principal.WindowsIdentity]::GetCurrent(); 
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::administrator) 
}

Function inicio{
	clear
    $user = '                         *'
	  if (Test-administrator) {
        $user = 'Admin session          \';
        $host.UI.RawUI.WindowTitle = "July Admin Windows PowerShell"

        echo "
            ___________________________________
           /       July $user
           \____Dassault Systemes Company______/
        "
        inicio2
    }
    else
    {
        echo "
         ****************************************
         *             $user                     
         *           July Powershell            *
         *       Dassault Systemes Company      *
         *                                      *
         ****************************************
        "
    }  

    #cd $home
}

############################################################

#inicio
  
Import-Module PSReadLine