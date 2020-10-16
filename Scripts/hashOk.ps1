########### COMPRUEBA HASH DE UN FICHERO #############

<#PSScriptInfo

.VERSION 1.0
.AUTHOR Julio Martin

.TAGS
  hashOk
.DESCRIPTION 
   Comprueba hash de un fichero
.EXAMPLE 
    hashOk ".\misHash.txt"
 
#> 

PARAM($nombreFichero="17TDT1EU-DA30_0016.kwi.md5", $path="E:\personal\hashes")
    #Leemos el archivo
    cd $path
    $listado = get-content $nombreFichero
    $files = ls $path -exclude *.md5

    $hashTable = @{}
    ForEach ($line in $listado) 
    {
        $spliteado = -split $line
        $hashTable.add($spliteado[1].Remove(0,1), $spliteado[0])
    }

    ForEach ($file in $files) 
    {
        $hash= (Get-FileHash $file -Algorithm MD5).hash #| Select-Object Hash
        $pHash = $hashTable[$file.Name]
        if($pHash -eq $null)
        {
          write-host -BackgroundColor Yellow -ForegroundColor Black ('{0} - RENOMBRADO' -f $file.Name)
          continue
        } 
        
        if($hash -eq $pHash)
        {
          write-host -BackgroundColor DarkGreen -ForegroundColor Black ('{0} - CORRECTO' -f $file.Name)
        }else{
          Write-Host -BackgroundColor DarkRed -ForegroundColor White ('{0} - INCORRECTO' -f $file.Name)
        }
    }