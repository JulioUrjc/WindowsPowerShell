####### MODULO DE LS A COLOR #######

Set-Alias lsa lsGetColorAndSize
Set-Alias lsr lsGetColorAndSizeRecursive
Set-Alias tam getDirSizeRecursive

Function lsGetColorAndSize
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

Function writeColorLS
{
        param ([string]$color = "white", $file)

        $tamano = ""
        if (-not($file -is [System.IO.DirectoryInfo]))
        {
           $tamano = $file.length
        }

        Write-host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $tamano, $file.name) -foregroundcolor $color 

        
}

Function lsColor {

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


Function getDirSize
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



Function lsGetColorAndSizeRecursive
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

Function lsColorRecursive {

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


Function getDirSizeRecursive
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

Function coloresPosibles{
  <#
    .SYNOPSIS
     Muestra colores posibles con su color
    
    .DESCRIPTION 
      Muestra los colores posibles de la power shell coloreados con el propio color
    
    .EXAMPLE 
      coloresPosibles  
  #> 
  [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}  

  $colors = [enum]::GetValues([System.ConsoleColor])
  Foreach ($bgcolor in $colors)
  {
    Foreach ($fgcolor in $colors) 
    { 
      Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine 
    }
    Write-Host " on $bgcolor"
  }
}

Function colores
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

Function Select-ColorString {
     <#
    .SYNOPSIS
      Find the matches in a given content by the pattern and write the matches in color like grep.
    .NOTES
      inspired by: https://ridicurious.com/2018/03/14/highlight-words-in-powershell-console/
    .EXAMPLE
      > 'aa bb cc', 'A line' | Select-ColorString a
      Both line 'aa bb cc' and line 'A line' are displayed as both contain "a" case insensitive.
    .EXAMPLE
      > 'aa bb cc', 'A line' | Select-ColorString a -NotMatch
      Nothing will be displayed as both lines have "a".
    .EXAMPLE
      > 'aa bb cc', 'A line' | Select-ColorString a -CaseSensitive
      Only line 'aa bb cc' is displayed with color on all occurrences of "a" case sensitive.
    .EXAMPLE
      > 'aa bb cc', 'A line' | Select-ColorString '(a)|(\sb)' -CaseSensitive -BackgroundColor White
      Only line 'aa bb cc' is displayed with background color White on all occurrences of regex '(a)|(\sb)' case sensitive.
    .EXAMPLE
      > 'aa bb cc', 'A line' | Select-ColorString b -KeepNotMatch
      Both line 'aa bb cc' and 'A line' are displayed with color on all occurrences of "b" case insensitive,
    and for lines without the keyword "b", they will be only displayed but without color.
    .EXAMPLE
      > Get-Content app.log -Wait -Tail 100 | Select-ColorString "error|warning|critical" -MultiColorsForSimplePattern -KeepNotMatch
      Search the 3 key words "error", "warning", and "critical" in the last 100 lines of the active file app.log and display the 3 key words in 3 colors.
      For lines without the keys words, hey will be only displayed but without color.
    .EXAMPLE
      > Get-Content "C:\Windows\Logs\DISM\dism.log" -Tail 100 -Wait | Select-ColorString win
      Find and color the keyword "win" in the last ongoing 100 lines of dism.log.
    .EXAMPLE
      > Get-WinEvent -FilterHashtable @{logname='System'; StartTime = (Get-Date).AddDays(-1)} | Select-Object time*,level*,message | Select-ColorString win
      Find and color the keyword "win" in the System event log from the last 24 hours.
    #>

    [Cmdletbinding(DefaultParametersetName = 'Match')]
    param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]$Pattern = $(throw "$($MyInvocation.MyCommand.Name) : " `
                + "Cannot bind null or empty value to the parameter `"Pattern`""),

        [Parameter(
            ValueFromPipeline = $true,
            HelpMessage = "String or list of string to be checked against the pattern")]
        [String[]]$Content,

        [Parameter()]
        [ValidateSet(
            'Black',
            'DarkBlue',
            'DarkGreen',
            'DarkCyan',
            'DarkRed',
            'DarkMagenta',
            'DarkYellow',
            'Gray',
            'DarkGray',
            'Blue',
            'Green',
            'Cyan',
            'Red',
            'Magenta',
            'Yellow',
            'White')]
        [String]$ForegroundColor = 'Red',

        [Parameter()]
        [ValidateSet(
            'Black',
            'DarkBlue',
            'DarkGreen',
            'DarkCyan',
            'DarkRed',
            'DarkMagenta',
            'DarkYellow',
            'Gray',
            'DarkGray',
            'Blue',
            'Green',
            'Cyan',
            'Red',
            'Magenta',
            'Yellow',
            'White')]
        #[ValidateScript( {
        #        if ($Host.ui.RawUI.BackgroundColor -eq $_) {
        #            throw "Current host background color is also set to `"$_`", " `
        #                + "please choose another color for a better readability"
        #        }
        #        else {
        #            return $true
        #        }
        #    })]
        [String]$BackgroundColor = 'DarkMagenta',

        [Parameter()]
        [Switch]$CaseSensitive,

        [Parameter(
            HelpMessage = "Available only if the pattern is simple non-regex string " `
                + "separated by '|', use this switch with fast CPU.")]
        [Switch]$MultiColorsForSimplePattern,

        [Parameter(
            ParameterSetName = 'NotMatch',
            HelpMessage = "If true, write only not matching lines; " `
                + "if false, write only matching lines")]
        [Switch]$NotMatch,

        [Parameter(
            ParameterSetName = 'Match',
            HelpMessage = "If true, write all the lines; " `
                + "if false, write only matching lines")]
        [Switch]$KeepNotMatch
    )

    begin {
        $paramSelectString = @{
            Pattern       = $Pattern
            AllMatches    = $true
            CaseSensitive = $CaseSensitive
        }
        $writeNotMatch = $KeepNotMatch -or $NotMatch

        [System.Collections.ArrayList]$colorList =  [System.Enum]::GetValues([System.ConsoleColor])
        $currentBackgroundColor = $Host.ui.RawUI.BackgroundColor
        $colorList.Remove($currentBackgroundColor.ToString())
        $colorList.Remove($ForegroundColor)
        $colorList.Reverse()
        $colorCount = $colorList.Count

        if ($MultiColorsForSimplePattern) {
            $patternToColorMapping = [Ordered]@{}
            # Available only if the pattern is a simple non-regex string separated by '|', use this with fast CPU.
            # We dont support regex as -Pattern for this switch as it will need much more CPU.
            # for example searching "error|warn|crtical" these 3 words in a log file.

            $expectedMatches = $Pattern.split("|")
            $expectedMatchesCount = $expectedMatches.Count
            if ($expectedMatchesCount -ge $colorCount) {
                Write-Host "The switch -MultiColorsForSimplePattern is True, " `
                    + "but there're more patterns than the available colors number " `
                    + "which is $colorCount, so rotation color list will be used." `
                    -ForegroundColor Yellow
            }
            0..($expectedMatchesCount -1) | % {
                $patternToColorMapping.($expectedMatches[$_]) = $colorList[$_ % $colorCount]
            }

        }
    }

    process {
        Foreach ($line in $Content) {
            $matchList = $line | Select-String @paramSelectString

            if (0 -lt $matchList.Count) {
                if (-not $NotMatch) {
                    $index = 0
                    Foreach ($myMatch in $matchList.Matches) {
                        $length = $myMatch.Index - $index
                        Write-Host $line.Substring($index, $length) -NoNewline

                        $expectedBackgroupColor = $BackgroundColor
                        if ($MultiColorsForSimplePattern) {
                            $expectedBackgroupColor = $patternToColorMapping[$myMatch.Value]
                        }

                        $paramWriteHost = @{
                            Object          = $line.Substring($myMatch.Index, $myMatch.Length)
                            NoNewline       = $true
                            ForegroundColor = $ForegroundColor
                            BackgroundColor = $expectedBackgroupColor
                        }
                        Write-Host @paramWriteHost

                        $index = $myMatch.Index + $myMatch.Length
                    }
                    Write-Host $line.Substring($index)
                }
            }
            else {
                if ($writeNotMatch) {
                    Write-Host "$line"
                }
            }
        }
    }

    end {
    }
}

Function grepc { 
  PARAM($Pattern, [String]$ForegroundColor = 'Red', [String]$BackgroundColor = 'DarkMagenta', [Switch]$CaseSensitive, [Switch]$NotMatch)

 ls -r -i * | Select-String $Pattern | Select-ColorString $Pattern -ForegroundColor:$ForegroundColor -BackgroundColor:$BackgroundColor -CaseSensitive:$CaseSensitive -NotMatch:$NotMatch

}

Export-ModuleMember -function lsGetColorAndSize, lsGetColorAndSizeRecursive, coloresPosibles, getDirSizeRecursive, resetShellColors, initShellColors, colores, Test-ConsoleColor, Export-ConsoleColor, Import-ConsoleColor, Select-ColorString, grepc -Alias lsa,lsr,tam

#############  COLORS ###########
# Black        
# DarkBlue      
# DarkGreen      
# DarkCyan      
# DarkRed      
# DarkMagenta      
# DarkYellow      
# Gray      
# DarkGray      
# Blue      
# Green      
# Cyan    
# Red      
# Magenta      
# Yellow
# White


#############  PSREADLINEOPTIONS ###########
# EditMode                               : Windows
# AddToHistoryHandler                    :
# HistoryNoDuplicates                    : True
# HistorySavePath                        : C:\Users\jmn6\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
# HistorySaveStyle                       : SaveIncrementally
# HistorySearchCaseSensitive             : False
# HistorySearchCursorMovesToEnd          : False
# MaximumHistoryCount                    : 4096
# ContinuationPrompt                     : >>
# ExtraPromptLineCount                   : 0
# PromptText                             : >
# BellStyle                              : Audible
# DingDuration                           : 50
# DingTone                               : 1221
# CommandsToValidateScriptBlockArguments : {ForEach-Object, %, Invoke-Command, icm...}
# CommandValidationHandler               :
# CompletionQueryItems                   : 100
# MaximumKillRingCount                   : 10
# ShowToolTips                           : True
# ViModeIndicator                        : None
# WordDelimiters                         : ;:,.[]{}()/\|^&*-=+'"–—―
# CommandColor                           : "$([char]0x1b)[93m"
# CommentColor                           : "$([char]0x1b)[32m"
# ContinuationPromptColor                : "$([char]0x1b)[33m"
# DefaultTokenColor                      : "$([char]0x1b)[33m"
# EmphasisColor                          : "$([char]0x1b)[96m"
# ErrorColor                             : "$([char]0x1b)[91m"
# KeywordColor                           : "$([char]0x1b)[92m"
# MemberColor                            : "$([char]0x1b)[97m"
# NumberColor                            : "$([char]0x1b)[97m"
# OperatorColor                          : "$([char]0x1b)[90m"
# ParameterColor                         : "$([char]0x1b)[90m"
# SelectionColor                         : "$([char]0x1b)[35;43m"
# StringColor                            : "$([char]0x1b)[36m"
# TypeColor                              : "$([char]0x1b)[37m"
# VariableColor                          : "$([char]0x1b)[92m"