#Crear ArrayList para almacenar la fecha de publicación de la oferta y el nombre de la oferta
[System.Collections.ArrayList] $arraylistm = New-Object System.Collections.ArrayList
[System.Collections.ArrayList] $arrayliste = New-Object System.Collections.ArrayList

#Petición a la web que tiene las ofertas
$Resultado=Invoke-WebRequest 'https://www.infojobs.net/ofertas-trabajo'
$Resultado.AllElements | %{
#Almacenar la fecha de la oferta y el nombre de la oferta
$Minuto=($_ | Where-Object Class -eq 'marked').innerText
$Empleo=($_ | Where-Object Class -eq 'job-list-title').innerText
if($Minuto){[void]$arraylistm.Add($Minuto)}
if($Empleo){[void]$arrayliste.Add($Empleo)}
}

#Recorrer la oferta por fecha de publicación y mostrar la oferta que tenga la fecha de publicación menor que 10 minutos
0..$arraylistm.Count | %{
[String]$MinutosContados=$arraylistm[$_+1]
#Sustituir las comillas ("")
$MinutosContados=$MinutosContados.replace("Hace","").replace("m","").Replace("h","60")
if([Int]$MinutosContados -lt 10 -and !$MinutosContados.Contains('h')){Write-Host $MinutosContados,$arrayliste[$_]}
}