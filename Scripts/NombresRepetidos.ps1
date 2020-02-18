#requires -version 3
[CmdletBinding()]
param (
    [string]
    $Path,
    [string]
    $Path2
)

if (-not $Path) {
    if ((Get-Location).Provider.Name -ne 'FileSystem') {
        Write-Error 'Specify a file system path explicitly, or change the current location to a file system path.'
        return
    }
    $Path = (Get-Location).ProviderPath
    $Path2 = (Get-Location).ProviderPath
}
 $oldpath = $Path 
 $newpath = $Path2 

 $files_old= Get-ChildItem -Path $oldpath -Recurse -File -Exclude *.txt
 $files_new= Get-ChildItem -Path $newpath -Recurse -File -Exclude *.txt
 $repetidos = New-Object System.Collections.ArrayList

  for($i=0; $i -lt $files_old.length; $i++)
  { 
      $j=0 
      $count=0

      if(!$repetidos.Contains($($files_old[$i]).Name))
      { 

        while($j -lt $files_new.length)
        { 
          if($($files_old[$i]).Name -eq $($files_new[$j]).Name)
          { 
            $count= $count + 1

            if($($files_old[$i]).FullName -ne $($files_new[$j]).FullName)
            { 
                Write-Host "$($files_old[$i].FullName) `t $($files_new[$j].FullName)" -ForegroundColor Red
                $repetidos.Add($($files_old[$i]).Name) > $null
            }  
          }
          $j++
        }
      } 
  }

