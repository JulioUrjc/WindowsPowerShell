####### MODULO DE LS A COLOR #######

Set-Alias lsa lsGetColorAndSize
Set-Alias lsr lsGetColorAndSizeRecursive

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
        '\.(jpg|png|jpge|bmp|gif|ico)$', $regex_opts)
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
        '\.(jpg|png|jpge|bmp|gif|ico)$', $regex_opts)
    $hide = New-Object System.Text.RegularExpressions.Regex(
        '^\.', $regex_opts)


  $number = (Get-ChildItem).Count
  $directories = New-Object System.Collections.ArrayList
  $numDir = 0

  Get-Childitem $dir -r| foreach-object {
     if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
     {

        if($number -eq 0)
        {
            $nombreDir = $directories[$numDir]
           Write-Host
           Write-Host "    Directory: " -noNewLine
           Write-Host " $nombreDir`n" -foregroundcolor "Yellow"           
           Write-Host "Mode                LastWriteTime     Length Name"
           Write-Host "----                -------------     ------ ----"
           $numDir++
           $number = (Get-ChildItem "$nombreDir").Count
        }

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
            $directories.Add($_.FullName) > $null
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
         $number--

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


Export-ModuleMember -function lsGetColorAndSize, lsGetColorAndSizeRecursive, coloresPosibles -Alias lsa,lsr

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

