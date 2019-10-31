Import-Module mExtra
Import-Module mCifrado
Import-Module mlogos
Import-Module mLSColor
Import-Module mCompression
Import-Module mEmail
Import-Module mGitCommit
Import-Module mInfo
Import-Module mFTP
Import-Module mMouse
Import-Module mFechas
Import-Module PSReadLine

#Function prompt { "PS $pwd>" }
#Function prompt { Write-Host -NoNewLine -ForegroundColor Cyan "PS $pwd"; return "=> " }
#Set-PSReadLineOption -PromptText "=> "

Function xflowconan { 
  (& "$env:Conda\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
  conda activate develop
  C:\xf\run_xflow_cmakeJuly.bat --deploy
}
Function admin {Start-Process powershell -Verb runAs; exit}
Function orden {ls | sort $args[0] | select $args[0]}
Function buscar {ls -r -i * | select-string $args[0]}
Function busca([string] $ext) {ls -r -i *.$ext | select-string $args[0]}

Function profileDir{abrir ([system.io.fileinfo]$profile).DirectoryName}
Function profileFile{ sublime $profile }
Function profile{cd ([system.io.fileinfo]$profile).DirectoryName}
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
Function nicengine { cd /xflowOne-build/RelWithDebInfo }

Function dumpbin{	cd "$env:ProgramFiles (x86)\Microsoft Visual Studio 14.0\VC\bin";	.\dumpbin.exe $args[0] $args[1]}

#################### Alias #################################

set-alias grep              buscar
set-alias fecha             Get-Date
set-alias abrir             explorer.exe
set-alias view              Out-GridView
set-alias columna           Select-Object
set-alias modulos           Get-Module
set-alias particiones       Get-partition
set-alias monitor           resmon
set-alias licencia          serial
set-alias cambiarColores    Get-PSReadLineOption
set-alias sublime           "$env:ProgramFiles\Sublime Text 3\sublime_text.exe"
set-alias sz                "$env:ProgramFiles\7-Zip\7z.exe"
set-alias slicer            "$env:ProgramFiles\slicer\Slic3r.exe"
set-alias repetier          "$env:ProgramFiles\Repetier-Host\RepetierHost.exe"
set-alias kraken            "$env:userprofile\AppData\Local\gitkraken\app-4.1.1\gitkraken.exe"
set-alias wordexe           "$env:ProgramFiles (x86)\Microsoft Office\Office16\winword.exe"


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

####################### EJEMPLOS #####################################


#(Get-Item $FileNamePath ).Extension
#(Get-Item $FileNamePath ).Basename
#(Get-Item $FileNamePath ).Name
#(Get-Item $FileNamePath ).DirectoryName
#(Get-Item $FileNamePath ).FullName
#PS C:\Users\jmn6> dir "C:\Program Files" -File -Recurse | Sort-Object Count -Descending | Select-Object Name, Count | Out-GridView
#Get-Command | Select-Object Name,source | Where-Object {$_.source -eq "mLSColor"} |Get-Help | Out-File C:\Users\jmn6\Desktop\Ayuda.txt
#Save-Help -Force -UICulture "en-us" -DestinationPath C:\PowerShell-Help
#Update-Help -Force -UICulture "en-us" -SourcePath C:\PowerShell-Help
#$env:PSModulePath
#systeminfo | Select-String "^OS Name","^OS Version"
#Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
#ipconfig | select-string -pattern 192
#Set-ExecutionPolicy Unrestricted | RemoteSigned | AllSigned | Restricted | Default | Bypass | Undefined
#Get-ExecutionPolicy -List
#$x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#$q = New-Object System.Collections.Queue; get-member -InputObject $q
#Function virtualMachineCopy {"$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" clonehd "$args[0]\Ubuntu.vdi" "$args[0]\Ubuntu_25.vdi" --existing}

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

  Set-ItemProperty -Path HKCU:\console -Name WindowAlpha -Value 210
    $user = '                         *'
  if (Test-administrator) {
        $user = 'Admin session            *';
        $host.UI.RawUI.WindowTitle = "July Admin Windows PowerShell"
    }

    echo "
     ****************************************
     *             $user                     
     *           July Powershell            *
     *                                      *
     ****************************************
    "
}

############################################################

inicio
  

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
function subl { &"${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args }