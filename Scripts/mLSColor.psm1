Set-Alias lsa lsGetColorAndSize

function lsGetColorAndSize
{
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
        '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)
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
            writeColorLS "Black" $_
        }

         $_ = $null
    
    } else {
       write-host ""
       echo "paso por aqui"
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