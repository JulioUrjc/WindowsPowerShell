####### MODULO DE CIFRADO #######

Function certificados
{
    <#
    .SYNOPSIS
     Muestra certificados disponibles
    .DESCRIPTION 
      Muestra certificados disponibles
    
    .EXAMPLE 
      certificados  
  #> 

	Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert
}


Function borrarCertificado
{
  <#
    .SYNOPSIS
     Borra un certificado disponible
    .DESCRIPTION 
      Borra un certificado disponible a traves de su ID
    
    .EXAMPLE 
      borrarCertificado $numero  
  #> 

    PARAM($numero)
	Remove-Item Cert:\CurrentUser\My\$numero
}


Function certificado
{
  <#
    .SYNOPSIS
     Crea el certificado en un fichero
    .DESCRIPTION 
      Crea el certificado en un fichero
    
    .EXAMPLE 
      certreq.exe -new DocumentEncryption.inf DocumentEncryption.cer 
    .EXAMPLE 
      certificado clave nombreFichero
  #> 

    PARAM(
      [string] $nombre,
      [string] $nombreFichero
    )

'[Version]
Signature = "$Windows NT$"
[Strings]
szOID\_ENHANCED\_KEY\_USAGE = "2.5.29.37"
szOID\_DOCUMENT\_ENCRYPTION = "1.3.6.1.4.1.311.80.1"
[NewRequest]'>>$nombreFichero
"Subject = cn=$nombre@localhost.local">>$nombreFichero
'MachineKeySet = false
KeyLength = 2048
KeySpec = AT_KEYEXCHANGE
HashAlgorithm = Sha1
Exportable = true
RequestType = Cert
KeyUsage = "CERT_KEY_ENCIPHERMENT_KEY_USAGE |  CERT_DATA_ENCIPHERMENT_KEY_USAGE"
ValidityPeriod = "Years"
ValidityPeriodUnits = "1000"
[Extensions]
%szOID\_ENHANCED\_KEY\_USAGE% = "{text}%szOID\_DOCUMENT\_ENCRYPTION%"' >> $nombreFichero




	certreq.exe -new .\$nombreFichero .\$nombreFichero.cer
	Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert
}

# Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert

Function cifrar
{
  <#
    .SYNOPSIS
     Cifra un texto
    .DESCRIPTION 
      Cifra un texto con un certificado y un nombre de fichero dados
    
    .EXAMPLE 
      Protect-CmsMessage -To 'cn=nombre@localhost.local'  -Content $Text  -OutFile MiTextoCifrado.txt 
    .EXAMPLE 
      cifrar nombre nombreFichero
  #> 

    PARAM(
      [string] $nombre,
      [string] $nombreFichero
    )
	Protect-CmsMessage -To "cn=$nombre@localhost.local" -OutFile $nombreFichero	
}


#Get-CmsMessage -Path .\MiTextoCifrado.txt | Unprotect-CmsMessage -To 'cn=nombre@localhost.local'

Function descifrar
{
    <#
    .SYNOPSIS
     Descifra un texto
    .DESCRIPTION 
      DesCifra un fichero con un certificado y un nombre de fichero dados, creando un fichero nuevo
    
    .EXAMPLE 
      Get-CmsMessage -Path .\MiTextoCifrado.txt | Unprotect-CmsMessage -To 'cn=nombre@localhost.local' 
    .EXAMPLE 
      descifrar nombre nombreFichero
  #> 

	    PARAM(
      [string] $nombre,
      [string] $nombreFichero
    )
	Get-CmsMessage -Path $nombreFichero | Unprotect-CmsMessage -To "cn=$nombre@localhost.local" > "$nombreFichero.descifrado.txt"
}

Function comprobarHashMultimedia
{
    <#
    .SYNOPSIS
     Comprueba cambios en una carpeta
    .DESCRIPTION 
      Descarga y descomprime un fichero 17TDT1EU-DA30_0016.kwi del multimedia del coche y comprueba cambios en el fichero md5
    
    .EXAMPLE 
      comprobarHash 
    .EXAMPLE 
      comprobarHash .\miPath
  #> 

  PARAM($path = "E:\personal\hashes", $time=0)
 
  $rutaActual = $pwd
  cd $path

  Remove-Item .\17TDT1EU-DA30_0016.kwi

  $client = (New-Object System.Net.WebClient).DownloadFile("http://streamtechdoc.toyota-motor-europe.com/techdoc3/audio_navigation/17TDT1EU-DA30_Latest.zip","$($path)\update.zip")

  descomprime "-y"

  .\17TDT1EU-DA30_0016.kwi.md5

  Start-Sleep -s $time
  cd $rutaActual
}

Function generatedMD5
{
    <#
    .SYNOPSIS
     Genera fichero hash
    .DESCRIPTION 
      Genera fichero hash con formato: hash ESPACIO ASTERISCOnombreFichero
    
    .EXAMPLE 
      generatedMD5 
    .EXAMPLE 
      generatedMD5 .\miPath
    #> 

  PARAM($path = "E:\personal\hashes")

  $rutaActual = $pwd
  cd $path

  $files = ls $path -exclude *.md5
  Remove-Item miMD5.md5

  ForEach ($file in $files) 
  {
        $hash= (Get-FileHash $file -Algorithm MD5).hash
        $hash + " *"+$file.Name >> miMD5.md5
  }
  

  cd $rutaActual
}

Function compareHash
{
    <#
    .SYNOPSIS
     Compara el hash de dos ficheros
    .DESCRIPTION 
     Compara el hash de dos ficheros para saber si son el mismo
    
    .EXAMPLE 
      compareHash .\miFile1 .\miFile2
    #> 

  PARAM($file1, $file2)

  if(($file1 -eq $null) -or  ($file2 -eq $null))
  {
    write-host -BackgroundColor Yellow -ForegroundColor Black ('                 NULL FILE                 ')
    return
  } 

  $hash1= (Get-FileHash $file1 -Algorithm MD5).hash
  $hash2= (Get-FileHash $file2 -Algorithm MD5).hash

  if($hash1 -eq $hash2)
  {
    write-host -BackgroundColor DarkGreen -ForegroundColor Green ('                 IGUALES                 ')
  }else{
    Write-Host -BackgroundColor DarkRed -ForegroundColor Red ('                 DISTINTOS                 ')
  }
}

Function checkDirectoryHash
{
    <#
    .SYNOPSIS
     Compara el hash de los ficheros de un directorio
    .DESCRIPTION 
     Compara los hash de un fichero md5 con los ficheros del mismo directorio
    
    .EXAMPLE 
      checkDirectoryHash miDir\miFile.md5
    #> 

  PARAM([System.IO.FileInfo]$pathFile="E:\personal\hashes\17TDT1EU-DA30_0016.kwi.md5")

  $currentPath= $pwd
  cd $pathFile.DirectoryName
  
  $files = ls $pathFile.DirectoryName -exclude *.md5
  $listado = get-content $pathFile.Name
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
  cd $currentPath
}

function downloadFile($url, $targetFile)
{
    <#
    .SYNOPSIS
     Descarga un ficherod e internet con barra de descarga
    .DESCRIPTION 
     Descarga un ficherod e internet con barra de descarga
    
    .EXAMPLE 
      downloadFile $url $dir/nombreNuevo
    #> 

   $uri = New-Object "System.Uri" "$url"
   $request = [System.Net.HttpWebRequest]::Create($uri)
   $request.set_Timeout(15000) #15 second timeout
   $response = $request.GetResponse()

   $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
   $responseStream = $response.GetResponseStream()
   $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
   $buffer = new-object byte[] 10KB

   $count = $responseStream.Read($buffer,0,$buffer.length)
   $downloadedBytes = $count

   while ($count -gt 0)
   {
       $targetStream.Write($buffer, 0, $count)
       $count = $responseStream.Read($buffer,0,$buffer.length)
       $downloadedBytes = $downloadedBytes + $count

       Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)

   }

   Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"
   $targetStream.Flush()
   $targetStream.Close()
   $targetStream.Dispose()
   $responseStream.Dispose()

}

Export-ModuleMember -function certificados, borrarCertificado, certificado, cifrar, descifrar, comprobarHashMultimedia, generatedMD5, compareHash, checkDirectoryHash, downloadFile