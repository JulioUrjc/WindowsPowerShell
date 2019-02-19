############## Capturas de pantalla partidas ######################3

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
function screenshot([Drawing.Rectangle]$bounds, $path)
{
	$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
	$graphics = [Drawing.Graphics]::FromImage($bmp)
	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
	$bmp.Save($path)
	$graphics.Dispose()
	$bmp.Dispose()
}

for($i=0; $i -le 1720; $i+=200)
{
		$i
		$bounds = [Drawing.Rectangle]::FromLTRB(0, $i, 980, $i+200)
		$fichero='C:\Users\jmn6\Desktop\capturas\captura'+$i+'.png'
		#Realizar captura
		screenshot $bounds $fichero
}