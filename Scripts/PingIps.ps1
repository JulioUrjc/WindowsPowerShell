########### PING A IPS DE UN FICHERO #############

<#PSScriptInfo

.VERSION 1.0
.AUTHOR Julio Martin

.TAGS
  ping ips
.DESCRIPTION 
   Ping a ips de un archivo
.EXAMPLE 
    pingIps ".\misIps.txt"
 
#> 

PARAM($nombreFichero)
    #Leemos el archivo
    $listado = get-content $nombreFichero

    ForEach ($ip in $listado) {
      if (test-connection -ComputerName $ip -Count 1 -Quiet) {
         write-host -BackgroundColor DarkGreen -ForegroundColor Black ('{0} - RESPONDE' -f $ip)
      } else {
         Write-Host -BackgroundColor DarkRed -ForegroundColor White ('{0} - NO RESPONDE' -f $ip)
      }
    }
 