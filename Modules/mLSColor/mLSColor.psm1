####### MODULO DE LS A COLOR #######

Set-Alias lsa lsGetColorAndSize
Set-Alias lsr lsGetColorAndSizeRecursive
Set-Alias tam getDirSizeRecursive

function lsGetColorAndSize
{
   <#
    .SYNOPSIS
     Muestra lo mismo que el comando ls pero coloreando los ficheros y carpetas
    
    .DESCRIPTION 
      Muestra lo mismo que el comando ls pero coloreando los ficheros y carpetas y el tamano total
    
    .EXAMPLE 
      lsa  
   #> 

    param ($dir)
    lsColor $dir
    Write-Host
    getDirSize $dir
    Write-Host
}

function writeColorLS
{
        param ([string]$color = "white", $file)

        $tamano = ""
        if (-not($file -is [System.IO.DirectoryInfo]))
        {
           $tamano = $file.length
        }

        Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $tamano, $file.name) -foregroundcolor $color 

        
}

function lsColor {

    param ($dir)

    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)


    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(7z|zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs|md)$', $regex_opts)
    $img = New-Object System.Text.RegularExpressions.Regex(
        '\.(jpg| jpeg|png|jpge|bmp|gif|ico)$', $regex_opts)
    $hide = New-Object System.Text.RegularExpressions.Regex(
        '^\.', $regex_opts)

  Get-Childitem $dir | foreach-object {
     if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
     {
        if(-not ($notfirst)) 
        {
           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $(pwd)`n" -foregroundcolor "Yellow"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $notfirst=$true
        }


        if($hide.IsMatch($_.Name))
        {
            # hide
        }
        elseif ($_ -is [System.IO.DirectoryInfo]) 
        {
            writeColorLS "White" $_                
        }
        elseif ($compressed.IsMatch($_.Name))
        {
            writeColorLS "Blue" $_
        }
        elseif ($executable.IsMatch($_.Name))
        {
            writeColorLS "Red" $_
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            writeColorLS "Green" $_
        }
        elseif ($img.IsMatch($_.Name))
        {
            writeColorLS "Magenta" $_
        }
        else
        {
            writeColorLS "DarkGray" $_
        }

         $_ = $null
    
    } else {
       write-host ""
    }
  }
}


function getDirSize
{
    param ($dir)
    $bytes = 0
    $color = "Yellow"

    Get-Childitem $dir | foreach-object {

        if ($_ -is [System.IO.FileInfo])
        {
            $bytes += $_.Length
        }
    }

    if ($bytes -ge 1KB -and $bytes -lt 1MB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1KB), 2) + " KB") -foregroundcolor $color 
    }

    elseif ($bytes -ge 1MB -and $bytes -lt 1GB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1MB), 2) + " MB") -foregroundcolor $color
    }

    elseif ($bytes -ge 1GB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1GB), 2) + " GB") -foregroundcolor $color
    }    

    else
    {
        Write-Host ("    Total Size: " + $bytes + " bytes") -foregroundcolor $color
    }
}



function lsGetColorAndSizeRecursive
{
    <#
    .SYNOPSIS
     Muestra lo mismo que el comando ls pero coloreando los ficheros y carpetas
    
    .DESCRIPTION 
      Muestra lo mismo que el comando ls pero coloreando los ficheros y carpetas de forma recursiva y el tamano final
    
    .EXAMPLE 
      lsa  
   #> 

    param ($dir)
    lsColorRecursive $dir
    Write-Host
    getDirSizeRecursive $dir
    Write-Host
}

function lsColorRecursive {

    param ($dir)

    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)


    $compressed = New-Object System.Text.RegularExpressions.Regex(
        '\.(7z|zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)
    $img = New-Object System.Text.RegularExpressions.Regex(
        '\.(jpg|jpeg|png|jpge|bmp|gif|ico)$', $regex_opts)
    $hide = New-Object System.Text.RegularExpressions.Regex(
        '^\.', $regex_opts)


  $numberFiles = (Get-ChildItem).Count
  $directories = New-Object System.Collections.ArrayList    # Es una cola que permite insercion al principio
  $subdirectories = New-Object System.Collections.ArrayList
  $first = $true
  $cambia = $false

  Get-Childitem $dir -r| foreach-object {
     if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
     {
        if($numberFiles -eq 0)
        {
           if($directories[0])
           {
           	  $directories= $directories[1..($directories.Length-1)]
           		$directories = $subdirectories + $directories
           		$subdirectories = New-Object System.Collections.ArrayList
           }else{
           		$directories = $subdirectories + $directories
           		$subdirectories = New-Object System.Collections.ArrayList
           }	

           $nombreDir = $directories[0]

           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $nombreDir`n" -foregroundcolor "Yellow"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"

           $numberFiles = (Get-ChildItem "$nombreDir").Count
        }

        if($first) 
        {
           Write-Host
           Write-Host "    Directory: " -noNewLine
           if ($_ -is [System.IO.DirectoryInfo])
           {
             $di = $(pwd)
           }else{
             $di = (Get-Item  $_).DirectoryName
           }
           Write-Host " $di`n" -foregroundcolor "Yellow" 
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $first=$false
        }

        if($hide.IsMatch($_.Name))
        {
            # hide
        }
        elseif ($_ -is [System.IO.DirectoryInfo]) 
        {
            writeColorLS "White" $_
            $subdirectories.Add($_.FullName) > $null
        }
        elseif ($compressed.IsMatch($_.Name))
        {
            writeColorLS "Blue" $_
        }
        elseif ($executable.IsMatch($_.Name))
        {
            writeColorLS "Red" $_
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            writeColorLS "Green" $_
        }
        elseif ($img.IsMatch($_.Name))
        {
            writeColorLS "Magenta" $_
        }
        else
        {
            writeColorLS "DarkGray" $_
        }

         $_ = $null
         $numberFiles--

    } else {
       write-host ""
    }
  }
}


function getDirSizeRecursive
{
    param ($dir)
    $bytes = 0
    $color = "Yellow"

    Get-Childitem $dir -r| foreach-object {

        if ($_ -is [System.IO.FileInfo])
        {
            $bytes += $_.Length
        }
    }

    if ($bytes -ge 1KB -and $bytes -lt 1MB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1KB), 2) + " KB") -foregroundcolor $color 
    }

    elseif ($bytes -ge 1MB -and $bytes -lt 1GB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1MB), 2) + " MB") -foregroundcolor $color
    }

    elseif ($bytes -ge 1GB)
    {
        Write-Host ("    Total Size: " + [Math]::Round(($bytes / 1GB), 2) + " GB") -foregroundcolor $color
    }    

    else
    {
        Write-Host ("    Total Size: " + $bytes + " bytes") -foregroundcolor $color
    }
}

function coloresPosibles{
  <#
    .SYNOPSIS
     Muestra colores posibles con su color
    
    .DESCRIPTION 
      Muestra los colores posibles de la power shell coloreados con el propio color
    
    .EXAMPLE 
      coloresPosibles  
  #> 
  [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}  
}

function colores
{
  <#
    .SYNOPSIS
     Muestra colores de background
    
    .DESCRIPTION 
      Muestra los colores posibles de background estilo ProgressBackgroundColor
    
    .EXAMPLE 
      colores 
  #> 
  $host.privatedata

  $host.PrivateData.psobject.properties | 
  Foreach {
   #$text = "$($_.Name) = $($_.Value)"
   Write-host "$($_.name.padright(23)) = " -NoNewline
   Write-Host $_.Value -ForegroundColor $_.value
  }

} 

#######################################
#############  CONSOLE COLORS #########
#######################################

function resetShellColors
{
  Set-PSReadlineOption -Colors @{ "Command"            = "$([char]0x1b)[93m"}
  Set-PSReadlineOption -Colors @{ "Comment"            = "$([char]0x1b)[32m"}
  Set-PSReadlineOption -Colors @{ "ContinuationPrompt" = "$([char]0x1b)[33m"}
  Set-PSReadlineOption -Colors @{ "DefaultToken"       = "$([char]0x1b)[33m"}
  Set-PSReadlineOption -Colors @{ "Emphasis"           = "$([char]0x1b)[96m"}
  Set-PSReadlineOption -Colors @{ "Error"              = "$([char]0x1b)[91m"}
  Set-PSReadlineOption -Colors @{ "Keyword"            = "$([char]0x1b)[92m"}
  Set-PSReadlineOption -Colors @{ "Member"             = "$([char]0x1b)[97m"}
  Set-PSReadlineOption -Colors @{ "Number"             = "$([char]0x1b)[97m"}
  Set-PSReadlineOption -Colors @{ "Operator"           = "$([char]0x1b)[90m"}
  Set-PSReadlineOption -Colors @{ "Parameter"          = "$([char]0x1b)[90m"}
  Set-PSReadlineOption -Colors @{ "Selection"          = "$([char]0x1b)[35;43m"}
  Set-PSReadlineOption -Colors @{ "String"             = "$([char]0x1b)[36m"}
  Set-PSReadlineOption -Colors @{ "Type"               = "$([char]0x1b)[37m"}
  Set-PSReadlineOption -Colors @{ "Variable"           = "$([char]0x1b)[92m"}

  $console = $host.ui.rawui
  $console.backgroundcolor = "#50143C"
  $console.foregroundcolor = "#EEEDF0"

  $colors = $host.privatedata
  $colors.verbosebackgroundcolor = "Black"
  $colors.verboseforegroundcolor = "Yellow"
  $colors.warningbackgroundcolor = "Black"
  $colors.warningforegroundcolor = "Yellow"
  $colors.ErrorBackgroundColor   = "Black"
  $colors.ErrorForegroundColor   = "Red"
}

function initShellColors
{
  Set-PSReadlineOption -Colors @{ "Command"            = "$([char]0x1b)[93m"}
  Set-PSReadlineOption -Colors @{ "Comment"            = "$([char]0x1b)[32m"}
  Set-PSReadlineOption -Colors @{ "ContinuationPrompt" = "$([char]0x1b)[33m"}
  Set-PSReadlineOption -Colors @{ "DefaultToken"       = "$([char]0x1b)[33m"}
  Set-PSReadlineOption -Colors @{ "Emphasis"           = "$([char]0x1b)[96m"}
  Set-PSReadlineOption -Colors @{ "Error"              = "$([char]0x1b)[91m"}
  Set-PSReadlineOption -Colors @{ "Keyword"            = "$([char]0x1b)[92m"}
  Set-PSReadlineOption -Colors @{ "Member"             = "$([char]0x1b)[97m"}
  Set-PSReadlineOption -Colors @{ "Number"             = "$([char]0x1b)[97m"}
  Set-PSReadlineOption -Colors @{ "Operator"           = "$([char]0x1b)[90m"}
  Set-PSReadlineOption -Colors @{ "Parameter"          = "$([char]0x1b)[90m"}
  Set-PSReadlineOption -Colors @{ "Selection"          = "$([char]0x1b)[35;43m"}
  Set-PSReadlineOption -Colors @{ "String"             = "$([char]0x1b)[36m"}
  Set-PSReadlineOption -Colors @{ "Type"               = "$([char]0x1b)[37m"}
  Set-PSReadlineOption -Colors @{ "Variable"           = "$([char]0x1b)[92m"}

  $console = $host.ui.rawui
  $console.backgroundcolor = "#50143C"
  $console.foregroundcolor = "#EEEDF0"

  $colors = $host.privatedata
  $colors.verbosebackgroundcolor = "Black"
  $colors.verboseforegroundcolor = "Yellow"
  $colors.warningbackgroundcolor = "Black"
  $colors.warningforegroundcolor = "Yellow"
  $colors.ErrorBackgroundColor   = "Black"
  $colors.ErrorForegroundColor   = "Red"
}

Function Test-ConsoleColor {
 
    Clear-Host
    $heading = "White"
    Write-Host "Pipeline Output" -ForegroundColor $heading
    Get-Service | Select -first 5
     
    Write-Host "`nError" -ForegroundColor $heading
    Write-Error "I made a mistake"
     
    Write-Host "`nWarning" -ForegroundColor $heading
    Write-Warning "Let this be a warning to you."
     
    Write-Host "`nVerbose" -ForegroundColor $heading
    $VerbosePreference = "Continue"
    Write-Verbose "I have a lot to say."
    $VerbosePreference = "SilentlyContinue"
     
    Write-Host "`nDebug" -ForegroundColor $heading
    $DebugPreference = "Continue"
    Write-Debug "`nSomething is bugging me. Figure it out."
    $DebugPreference = "SilentlyContinue"
     
    Write-Host "`nProgress" -ForegroundColor $heading
    1..10 | foreach -Begin {$i=0} -process {
     $i++
     $p = ($i/10)*100
     Write-Progress -Activity "Progress Test" -Status "Working" -CurrentOperation $_ -PercentComplete $p
     Start-Sleep -Milliseconds 250
    }
} #Test-ConsoleColor

Function Export-ConsoleColor {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
    [Parameter(Position=0)]
    [ValidateNotNullorEmpty()]
    [string]$Path = '.\PSConsoleSettings.csv'
    )
     
    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost') {
      $host.PrivateData | Add-Member -MemberType NoteProperty -Name ForegroundColor -Value $host.ui.rawui.ForegroundColor -Force
      $host.PrivateData | Add-Member -MemberType NoteProperty -Name BackgroundColor -Value $host.ui.rawui.BackgroundColor -Force
      Write-Verbose "Exporting to $path"
      Write-verbose ($host.PrivateData | out-string)
      $host.PrivateData | Export-CSV -Path $Path -Encoding ASCII -NoTypeInformation
    }
    else {
        Write-Warning "This only works in the console host, not the ISE."   
    }
} #Export-ConsoleColor

Function Import-ConsoleColor {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
    [Parameter(Position=0)]
    [ValidateScript({Test-Path $_})]
    [string]$Path = '.\PSConsoleSettings.csv'
    )
     
    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost') {
        Write-Verbose "Importing color settings from $path"
        $data = Import-CSV -Path $Path
        Write-Verbose ($data | out-string)
     
        if ($PSCmdlet.ShouldProcess($Path)) {
            $host.ui.RawUI.ForegroundColor = $data.ForegroundColor
            $host.ui.RawUI.BackgroundColor = $data.BackgroundColor
            $host.PrivateData.ErrorForegroundColor = $data.ErrorForegroundColor
            $host.PrivateData.ErrorBackgroundColor = $data.ErrorBackgroundColor
            $host.PrivateData.WarningForegroundColor = $data.WarningForegroundColor
            $host.PrivateData.WarningBackgroundColor = $data.WarningBackgroundColor
            $host.PrivateData.DebugForegroundColor = $data.DebugForegroundColor
            $host.PrivateData.DebugBackgroundColor = $data.DebugBackgroundColor
            $host.PrivateData.VerboseForegroundColor = $data.VerboseForegroundColor
            $host.PrivateData.VerboseBackgroundColor = $data.VerboseBackgroundColor
            $host.PrivateData.ProgressForegroundColor = $data.ProgressForegroundColor
            $host.PrivateData.ProgressBackgroundColor = $data.ProgressBackgroundColor
     
            Clear-Host
        } #should process
     
    }
    else {
       Write-Warning "This only works in the console host, not the ISE."
    }
} #Import-ConsoleColor




Export-ModuleMember -function lsGetColorAndSize, lsGetColorAndSizeRecursive, coloresPosibles, getDirSizeRecursive, resetShellColors, initShellColors, colores, Test-ConsoleColor, Export-ConsoleColor, Import-ConsoleColor -Alias lsa,lsr,tam

#############  COLORS ###########
#Black        
#DarkBlue      
#DarkGreen      
#DarkCyan      
#DarkRed      
#DarkMagenta      
#DarkYellow      
#Gray      
#DarkGray      
#Blue      
#Green      
#Cyan    
#Red      
#Magenta      
#Yellow
#White


#############  PSREADLINEOPTIONS ###########
#EditMode                               : Windows
#AddToHistoryHandler                    :
#HistoryNoDuplicates                    : True
#HistorySavePath                        : C:\Users\jmn6\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
#HistorySaveStyle                       : SaveIncrementally
#HistorySearchCaseSensitive             : False
#HistorySearchCursorMovesToEnd          : False
#MaximumHistoryCount                    : 4096
#ContinuationPrompt                     : >>
#ExtraPromptLineCount                   : 0
#PromptText                             : >
#BellStyle                              : Audible
#DingDuration                           : 50
#DingTone                               : 1221
#CommandsToValidateScriptBlockArguments : {ForEach-Object, %, Invoke-Command, icm...}
#CommandValidationHandler               :
#CompletionQueryItems                   : 100
#MaximumKillRingCount                   : 10
#ShowToolTips                           : True
#ViModeIndicator                        : None
#WordDelimiters                         : ;:,.[]{}()/\|^&*-=+'"–—―
#CommandColor                           : "$([char]0x1b)[93m"
#CommentColor                           : "$([char]0x1b)[32m"
#ContinuationPromptColor                : "$([char]0x1b)[33m"
#DefaultTokenColor                      : "$([char]0x1b)[33m"
#EmphasisColor                          : "$([char]0x1b)[96m"
#ErrorColor                             : "$([char]0x1b)[91m"
#KeywordColor                           : "$([char]0x1b)[92m"
#MemberColor                            : "$([char]0x1b)[97m"
#NumberColor                            : "$([char]0x1b)[97m"
#OperatorColor                          : "$([char]0x1b)[90m"
#ParameterColor                         : "$([char]0x1b)[90m"
#SelectionColor                         : "$([char]0x1b)[35;43m"
#StringColor                            : "$([char]0x1b)[36m"
#TypeColor                              : "$([char]0x1b)[37m"
#VariableColor                          : "$([char]0x1b)[92m"