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
  Param( [ValidateSet("cmake","compile","deploy", "full")][string] $action = "default" ) 

  $current = $pwd
  cd E:\git\xflowlegacy\common\win_compilation\steps

  switch($arg)
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
      Guarda las posiciones del raton
    
    .DESCRIPTION 
      Guarda las posiciones del raton en un fichero y las muestra
    
    .EXAMPLE 
      mousePosition
    #> 

  Param( [ValidateSet("--init","--compile","--full")][string] $arg = "--init" )

  $proflDir = ([system.io.fileinfo]$profile).DirectoryName
  $batsDir = "$proflDir\Scripts\cmdScripts\hide"

  if($arg -eq "--init")
  {
    echo "FMK init"
    Start-Process cmd "/k $batsDir\fmkInit.bat"
  }
  elseif($arg -eq "--compile")
  {
    echo "FMK compile"
    Start-Process cmd "/k $batsDir\fmkInit.bat && $batsDir\fmkCompile.bat" 
  }
  elseif($arg -eq "--full")
  {
    echo "FMK init - download and compile"
    Start-Process cmd "/k $batsDir\fmkUpdate_Test.bat"
  }
   
}

Export-ModuleMember -function conanenvironment, gui, xflowCompile, fmkInit