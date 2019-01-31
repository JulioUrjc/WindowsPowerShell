####### MODULO EXTRAS #######

Function word{
    <#
    .SYNOPSIS
      Inicia un word en el escritorio y lo abre
    .DESCRIPTION 
      Inicia un word en blanco en el escritorio y lo abre
    
    .EXAMPLE 
      word  
   #> 

    $file = "$env:userprofile\Desktop\word.docx"
    $i= 0       

    while(Test-Path $file)
    {
        $i++
        $file = "$env:userprofile\Desktop\word($i).docx"
    }

    touch $file 
    wordexe $file  
}

# Function serial
Function serial{
  (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
}


Function cuentaAtras
{
    <#
    .SYNOPSIS
      Inicia una cuenta atras
    .DESCRIPTION 
      Inicia una cuenta atras desde un tiempo dado en milisegundos
    
    .EXAMPLE 
      cuentaAtras $time  
   #> 

    $Longitud1 = 0
    $Longitud2 = 0
    ""
    Write-Host "Elemento N      " -NoNewLine
    $args[0]..0| ForEach{ `
        Start-Sleep -Milliseconds 5
        $Incremento = $Longitud1 - $Longitud2
        $Longitud1 = ("{0:N0}" -f ($_ + 1)).Length
        $Numero = "{0:N0}" -f $_
        $Longitud2 = $Numero.Length
        $Borrado = " " * ($Longitud1 - $Longitud2)
        $Retroceso = "`b" * ($Longitud1 + $Incremento)
        Write-Host "$Retroceso$Numero$Borrado" -NoNewLine
    }
}

Function cuenta
{
   <#
    .SYNOPSIS
      Inicia una cuenta
    .DESCRIPTION 
      Inicia una cuenta hasta un tiempo dado en milisegundos
    
    .EXAMPLE 
      cuenta $time  
   #> 
    PARAM(
        [int]$time = 10
    )

    Write-Host -NoNewLine "Counting from 1 to ${time} (in seconds):  "

    $tercio = $time * 1/3

    if ($time -eq 1)
    {
         Write-Host -NoNewLine  "1 " -BackgroundColor "Green" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
    }

    if($time -gt 1)
    {
       $tercio = $time * 1/3
       foreach($element in 1..$tercio){
         Write-Host -NoNewLine  "${element} " -BackgroundColor "Green" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
       }
    

       if($time -gt 2)
       {
          $tercio++
          $dostercios = $time * 2/3
          foreach($element in $tercio..$dostercios){
            Write-Host -NoNewLine  "${element} " -BackgroundColor "Yellow" -ForegroundColor "Black"
            Start-Sleep -Seconds 1
          }
       }else{
         Write-Host -NoNewLine  "2 " -BackgroundColor "Yellow" -ForegroundColor "Black"
         Start-Sleep -Seconds 1
       }

       if($time -gt 2)
       {
          $dostercios++
          foreach($element in $dostercios..$time){
            Write-Host -NoNewLine  "${element} " -BackgroundColor "Red" -ForegroundColor "Black"
            Start-Sleep -Seconds 1
          }
       }
    }

    Write-Host ""
    Write-Host ""
    Write-Host "FIN !!!"
}

Function inicio{ Get-WmiObject -Class win32_startupCommand }

Function shader {glslangValidator -V $args[0]}

Export-ModuleMember -function  word, cuentaAtras, cuenta, inicio, shader

