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


Export-ModuleMember -function certificados, borrarCertificado, certificado, cifrar, descifrar