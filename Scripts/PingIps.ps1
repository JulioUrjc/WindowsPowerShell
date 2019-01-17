########### PING A IPS DE UN FICHERO #############

<#PSScriptInfo

.VERSION 1.0

.GUID 01f27f3f-86da-418c-8c4a-7db5171a547c

.AUTHOR Julio Martin

.COMPANYNAME 
.COPYRIGHT 
.TAGS
  ping ips

.LICENSEURI 
.PROJECTURI 
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES

.DESCRIPTION 
   Ping a ips de un archivo
   
.EXAMPLE 
    pingIps ".\misIps.txt"

 
#> 

PARAM($nombreFichero)

    #Leemos el archivo
    $listado = get-content $nombreFichero

    #Para cada ip del archivo
    ForEach ($ip in $listado) {
      if (test-connection -ComputerName $ip -Count 1 -Quiet) {
         # Si el test-connection es correcto
         write-host -BackgroundColor DarkGreen -ForegroundColor Black ('{0} - RESPONDE' -f $ip)
      } else {
         # Si el test-connection no es correcto
         Write-Host -BackgroundColor DarkRed -ForegroundColor White ('{0} - NO RESPONDE' -f $ip)
      }
    }
 