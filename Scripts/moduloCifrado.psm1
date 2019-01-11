####### MODULO DE CIFRADO #######

# certificados
Function certificados
{
	Get-ChildItem -Path Cert:\CurrentUser\My -DocumentEncryptionCert
}

# borrarCertificado numero
Function borrarCertificado
{
    PARAM($numero)
	Remove-Item Cert:\CurrentUser\My\$numero
}

# certreq.exe -new DocumentEncryption.inf DocumentEncryption.cer
Function cifrado
{
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



#Protect-CmsMessage -To 'cn=nombre@localhost.local'  -Content $Text  -OutFile MiTextoCifrado.txt
#cifrar nombre nombreFichero

Function cifrar
{
    PARAM(
      [string] $nombre,
      [string] $nombreFichero
    )
	Protect-CmsMessage -To "cn=$nombre@localhost.local" -OutFile $nombreFichero	
}


#Get-CmsMessage -Path .\MiTextoCifrado.txt | Unprotect-CmsMessage -To 'cn=nombre@localhost.local'

Function descifrar
{
	    PARAM(
      [string] $nombre,
      [string] $nombreFichero
    )
	Get-CmsMessage -Path $nombreFichero | Unprotect-CmsMessage -To "cn=$nombre@localhost.local" > "$nombreFichero.descifrado.txt"
}