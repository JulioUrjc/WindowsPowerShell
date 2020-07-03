Function ramproceso2
{
    <#
    .SYNOPSIS
      Monitoriza la RAM de un proceso
    .DESCRIPTION 
      Monitoriza la RAM de $proceso
    
    .EXAMPLE 
      ramproceso $proceso  
   #> 

    PARAM( $proceso="XFlow")
    
    $raminicial = ps $proceso |Select-Object pm | %{$_.pm}
    $raminicial=$raminicial/1mb
    Write-Host "RAM Inicial:   " -NoNewLine
    "{0:N2} MB" -f $raminicial


    $Longitud1 = 0
    $Longitud2 = 0
    $MbSpaces = 0
    ""
    Write-Host "RAM       " -NoNewLine
    while($true)
    { `
        Start-Sleep -Milliseconds 5
        $Incremento = $Longitud1 - $Longitud2
        $ram= ps $proceso |Select-Object pm | %{$_.pm}
        $ram=$ram/1mb

        $Longitud1 = ("{0:N0}" -f $ram).Length + $MbSpaces
        $Numero = "{0:N0}" -f $ram
        $Longitud2 = $Numero.Length+ $MbSpaces
        $Retroceso = "`b" * ($Longitud1 + $Incremento)

        if($ram -gt ($raminicial+500)) 
        {
          Write-Host "$Retroceso$Numero MB" -NoNewLine
          (Get-Date).ToString()
          Write-Host
          $raminicial=$raminicial+500
        }
        else
        {
          Write-Host "$Retroceso$Numero MB" -NoNewLine
        }
        
        $MbSpaces=3
    }
}

Function ramproceso
{
    <#
    .SYNOPSIS
      Monitoriza la RAM de un proceso
    .DESCRIPTION 
      Monitoriza la RAM de $proceso
    
    .EXAMPLE 
      ramproceso $proceso  
   #> 

    PARAM( $proceso="XFlow")
    
    $raminicial = ps $proceso |Select-Object pm | %{$_.pm}
    $raminicial=$raminicial/1mb
    Write-Host "RAM Inicial:   " -NoNewLine
    "{0:N2} MB" -f $raminicial
     Write-Host
  
    while($true)
    {
        $frame = readPipe "july"
        $ramanterior = $ram
        $ram= ps $proceso |Select-Object pm | %{$_.pm}
        $ram=$ram/1mb

        $diferencia = "{0:N0}" -f ($ram - $ramanterior)
        $Numero = "{0:N0}" -f $ram

        
        Write-Host "Frame: $frame  RAM: $Numero MB   dif: $diferencia   date: " -NoNewLine
        (Get-Date).ToString()
    }
}

ramproceso