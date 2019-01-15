Import-Module -Name "$env:userprofile\Documents\WindowsPowerShell\Scripts\moduloExtra.psm1"
Import-Module -Name "$env:userprofile\Documents\WindowsPowerShell\Scripts\moduloCifrado.psm1"
Import-Module -Name "$env:userprofile\Documents\WindowsPowerShell\Scripts\mlogos.psm1"
Import-Module -Name "$env:userprofile\Documents\WindowsPowerShell\Scripts\mLSColor.psm1"
Import-Module -Name "$env:userprofile\Documents\WindowsPowerShell\Scripts\mCompresion.psm1"

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
#Function virtualMachineCopy {"$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" clonehd "$args[0]\Ubuntu.vdi" "$args[0]\Ubuntu_25.vdi" --existing}

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

Function workstation{ ssh julio@192.168.86.154 }

Function dumpbin
{
	cd "$env:ProgramFiles(x86)\Microsoft Visual Studio 14.0\VC\bin"

	.\dumpbin.exe $args[0] $args[1]
}

#################### Alias #################################

set-alias grep       select-string
set-alias fecha      Get-Date
set-alias abrir      explorer.exe
set-alias view       Out-GridView
set-alias columna    Select-Object
set-alias cal        $env:userprofile\Documents\WindowsPowerShell\Scripts\Cal.ps1
set-alias sublime    "$env:ProgramFiles\Sublime Text 3\sublime_text.exe"
set-alias sz         "$env:ProgramFiles\7-Zip\7z.exe"
set-alias slicer     "$env:ProgramFiles\slicer\Slic3r.exe"
set-alias repetier   "$env:ProgramFiles\Repetier-Host\RepetierHost.exe"
set-alias kraken     "$env:userprofile\AppData\Local\gitkraken\app-4.1.1\gitkraken.exe"
set-alias wordexe    "$env:ProgramFiles(x86)\Microsoft Office\Office16\winword.exe"


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

inicio
  
Import-Module PSReadLine