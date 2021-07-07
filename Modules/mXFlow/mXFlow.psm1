####### MODULO XFLOW #######


Function conanenvironment 
{ 
    <#
    .SYNOPSIS
      Entra en conda, activa develop
    .DESCRIPTION 
      Entra en conda, activa develop
    
    .EXAMPLE 
      conanenvironment
    #> 

  (& "$env:Conda\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
  conda activate develop
}

Function gui { cd E:\git\xflowlegacy}

Function xflowCompile 
{
   <#
    .SYNOPSIS
      Funcion para compilar xflow
    
    .DESCRIPTION 
      Permite hacer cmake, compilar y generar el deploy para el repositorio de xflow
    
    .EXAMPLE 
      fmkInit
    .EXAMPLE 
      fmkInit cmake / fmkInit compile / fmkInit deploy
    .EXAMPLE 
      fmkInit full
    #> 

  Param( [ValidateSet("cmake","compile","deploy", "full")][string] $action = "default" ) 

  $current = $pwd
  cd E:\git\xflowlegacy\common\win_compilation\steps
  conanenvironment

  switch($action)
  {
    "cmake"   { ./cmake_xflow.bat }
    "compile" { ./compile_xflow.bat }
    "deploy"  { ./deploy_xflow.bat }
    "full"    { ./cmake_xflow.bat; ./compile_xflow.bat; ./deploy_xflow.bat}
    default   {}
  }

  if($action -ne "default")
  {
    cd $current
  }

}

Function fmkInit
{ 

    <#
    .SYNOPSIS
      Funcion para repositorio fmk
    
    .DESCRIPTION 
      Permite inicializar, descargar y compilar el repositorio de fmk
    
    .EXAMPLE 
      fmkInit
    .EXAMPLE 
      fmkInit compile
    .EXAMPLE 
      fmkInit full
    #> 

  Param( [ValidateSet("init","compile","full")][string] $arg = "init" )

  $proflDir = ([system.io.fileinfo]$profile).DirectoryName
  $batsDir = "$proflDir\Scripts\cmdScripts\hide"

  if($arg -eq "init")
  {
    echo "FMK init"
    Start-Process cmd "/k $batsDir\alias.bat && $batsDir\fmkInit.bat"
  }
  elseif($arg -eq "compile")
  {
    echo "FMK compile"
    Start-Process cmd "/k $batsDir\alias.bat && $batsDir\fmkInit.bat && $batsDir\fmkCompile.bat" 
  }
  elseif($arg -eq "full")
  {
    echo "FMK init - download and compile"
    Start-Process cmd "/k $batsDir\alias.bat && $batsDir\fmkUpdate_Test.bat"
  }
   
}

Function traduccion 
{ 
    <#
    .SYNOPSIS
      Actualiza ficheros de traduccion de Xflow
    .DESCRIPTION 
      Actualiza ficheros de traduccion de Xflow
    
    .EXAMPLE 
      traduccion
    #> 

  $actual = $pwd
  cd "C:\xf\gui\xflow-gui\resources\locale"
  translations_update_TS_files.bat
  translations_release_TS_files.bat
  
  cd $actual
}

Export-ModuleMember -function conanenvironment, gui, xflowCompile, fmkInit, traduccion