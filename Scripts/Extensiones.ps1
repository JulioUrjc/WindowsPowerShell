
<#PSScriptInfo

.VERSION 1.0

.AUTHOR Julio Martin


.DESCRIPTION 
 	Extensions in directories
.EXAMPLE 
    Extensiones
 
#> 

PARAM( $dir = $pwd)

$extensions = [System.Collections.ArrayList]@()
$Global:contador = 0


Function fillExtensions {
    Param ($fichero)

    $ext = (Get-ChildItem $fichero).Extension
		
		if( $fichero -is [System.IO.DirectoryInfo])
		{
			cd $fichero
			$Global:contador = $Global:contador + 1
			recursivesDirectories $pwd
		}
		else
		{
			if($extensions -notcontains $ext)
		    {
			  $arrayID = $extensions.Add($ext)
		    }	
		}
}

Function recursivesDirectories {
	Param ($directory)

	Get-Childitem $directory | foreach-object {
	    fillExtensions $_
	}

	if($Global:contador -ne 0)
	{
	  cd..
	  $Global:contador = $Global:contador - 1
	}
}

Function writeColor
{
        param ([string]$color = "white", $ext)
        Write-host $ext -foregroundcolor $color        
}

Add-Type -Assembly Microsoft.VisualBasic

recursivesDirectories $dir	


$regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

$videoEx = New-Object System.Text.RegularExpressions.Regex(
'\.(mp4|avi|mpeg|WAV|MOV)$', $regex_opts)

foreach ($item in $extensions) 
{
	if ($videoEx.IsMatch($item))
	{
		writeColor "Green" $item
	}
	else
	{
		$item
	}         
}