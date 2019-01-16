####### MODULO DE COMPRESION #######

Function comprimir{
	<#
	.SYNOPSIS
	 Comprimir ficheros de una carpeta
	
	.DESCRIPTION 
	  Comprime los ficheros de una misma carpeta y a su vez comprime todos lso comprimidos,
	  también te permite borrarlos al final
	
	.EXAMPLE 
	  comprimir
	 
	#> 

   ls -name
   $input = Read-Host "Va a comprimir estos ficheros, esta seguro y/n?"
   $delete = Read-Host "Deseas borrar los originales y/n?"
   if($input -Match "y")
   {
      $files = ls -name; 
      foreach ( $file in $files )
      { 
         $zipname = $file + ".7z" 
         if($delete -Match "y")
         {
            sz a -sdel $zipname $file
         }else{
            sz a $zipname $file
         }
             
      }
      if($delete -Match "y")
      {
         sz a -sdel "$args.7z" *.*
      }else{
         sz a "$args.7z" *.*
      }
      
   }
}

Function comprime{
   <#
	.SYNOPSIS
	 Comprimir ficheros de una carpeta
	
	.DESCRIPTION 
	  Comprime los ficheros de una misma carpeta, también te permite borrarlos al final
	
	.EXAMPLE 
	  comprime
	 
	#> 

   ls -name
   $input = Read-Host "Va a comprimir estos ficheros, esta seguro y/n?"
   $delete = Read-Host "Deseas borrar los originales y/n?"
   if($input -Match "y")
   {
      $files = ls -name; 
      foreach ( $file in $files )
      { 
         $zipname = $file + ".7z" 
         if($delete -Match "y")
         {
            sz a -sdel $zipname $file
         }else{
            sz a $zipname $file
         }
             
      }
   }
}


Function descomprimir{
	<#
	.SYNOPSIS
	 Comprimir ficheros de una carpeta
	
	.DESCRIPTION 
	  Descomprime los ficheros de una misma carpeta, en carpetas o sueltos
	.EXAMPLE 
	  descomprimir
	 
	#> 

   ls -name *.zip
   ls -name *.7z
   $input = Read-Host "Va a descomprimir estos ficheros, esta seguro y/n?"
   $folders = Read-Host "Descomprimir en carpetas y/n?"
   if($input -Match "y")
   {
     if($folders -Match "y"){
   	   sz x *.zip -o*
       sz x *.7z -o*
     }else{
       sz x *.zip
       sz x *.7z
     }
     
   }
}

# Cuidado descomprime y borra los ficheros comprimidos
Function descomprime{
	<#
	.SYNOPSIS
	 Comprimir ficheros de una carpeta
	
	.DESCRIPTION 
	  Descomprime los ficheros de una misma carpeta, en carpetas o sueltos y borra los
	  comprimidos
	.EXAMPLE 
	  descomprimir
	 
	#> 

   ls -name *.zip
   ls -name *.7z
   $input = Read-Host "Va a descomprimir estos ficheros, esta seguro y/n?"
   $folders = Read-Host "Descomprimir en carpetas y/n?"
   if($input -Match "y")
   {
     if($folders -Match "y"){
   	   sz x *.zip -o*
       sz x *.7z -o*
     }else{
       sz x *.zip
       sz x *.7z
     }
     
   }
   rm *.zip
   rm *.7z
}


Export-ModuleMember -function comprimir, comprime, descomprimir, descomprime