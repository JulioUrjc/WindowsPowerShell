####### GIT COMMIT #######

Function comitear{
	<#
	.SYNOPSIS
	 Comitea y pushea powershell repo
	
	.DESCRIPTION 
	  Hace un commit del repositorio de powershell y despues hace el push
	
	.EXAMPLE 
	  comitear "Mensaje a enviar"
	 
	#> 

	PARAM ([Parameter(`
            Mandatory=$true)]
			$mensaje)

	$rutaActual = $pwd
	$repo = ([system.io.fileinfo]$profile).DirectoryName

	cd $repo
	git add .
	git commit -m $mensaje
	git push origin master

	cd $rutaActual
}

Export-ModuleMember -function comitear