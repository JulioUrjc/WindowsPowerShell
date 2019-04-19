####### MODULO FECHAS #######

Function fechasCoche 
{ 
  <#
    .SYNOPSIS
      Muestra fechas relevantes para el coche
    
    .DESCRIPTION 
      Muestra fechas relevantes para el coche
    
    .EXAMPLE 
      fechasCoche
  #> 

  $startDate=[datetime]"2019/03/14"
  
  $color ="Yellow"
  $color2 = "White"
  $coche = [math]::round((NEW-TIMESPAN -Start $startDate -End (GET-DATE)).Totaldays,3)
  $unMeses = 30 - $coche
  $unMid = $unMeses + 15
  $dosMeses = 60 - $coche
  $dosMid = $dosMeses + 15
  $tresMeses = 90 - $coche
  
  Write-Host ""
  Write-Host " Mode         DeadLine     Date          Mid         Date"
  Write-Host " ----         --------     -----         ------      -----"
  Write-Host "|-------------------------|-------------|-----------|------------|" -foregroundcolor $color 
  Write-Host "| Esperando  |  ${coche}                                           |" -foregroundcolor $color2
  Write-Host "|-------------------------|-------------|-----------|------------|" -foregroundcolor $color
  Write-Host "| Un Mes     |  ${unMeses}    |  13 ABR     |  ${unMid}    |  28 ABR    |" -foregroundcolor $color2
  Write-Host "|-------------------------|-------------|-----------|------------|" -foregroundcolor $color
  Write-Host "| Dos Meses  |  ${dosMeses}    |  13 MAY     |  ${dosMid}   |  28 MAY    |" -foregroundcolor $color2
  Write-Host "|-------------------------|-------------|-----------|------------|" -foregroundcolor $color
  Write-Host "| Tres Meses |  ${tresMeses}    |  13 JUN                              |" -foregroundcolor $color2
  Write-Host "|-------------------------|-------------|-----------|------------|" -foregroundcolor $color

  
}

Export-ModuleMember -function fechasCoche