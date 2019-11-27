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

Function gui { cd /xflow/gui}
Function common { cd /xflow/common}
Function guic { cd /xf/gui}
Function commonc { cd /xf/common}
Function nicengine { cd /xflowOne-build/RelWithDebInfo }


Export-ModuleMember -function xflowconan, conanenvironment, gui, common, guic, commonc, nicengine