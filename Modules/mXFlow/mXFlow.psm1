####### MODULO DE XFlow #######

Function xflowconan 
{ 
    <#
    .SYNOPSIS
      Entra en conda, activa develop y lanza el bat
    
    .DESCRIPTION 
      Entra en conda, activa develop y lanza el bat
    
    .EXAMPLE 
      xflowconan

      xflowconan --deploy

      xflowconan --clean

      xflowconan --fullclean
    #> 

  Param( [ValidateSet("--deploy","--clean","--fullclean")][string] $parameter = "--deploy" )

  (& "$env:Conda\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
  conda activate develop
  C:\xf\run_xflow_cmakeJuly.bat $parameter
}

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

Function gui { cd /xflow/gui}
Function common { cd /xflow/common}
Function guic { cd /xf/gui}
Function commonc { cd /xf/common}
Function nicengine { cd /xflowOne-build/RelWithDebInfo }


Export-ModuleMember -function xflowconan, conanenvironment, traduccion, gui, common, guic, commonc, nicengine