Function comprimir{
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
      sz a -sdel "$args.7z" *.*
   }
}

Function descomprimir{
   ls -name *.zip
   $input = Read-Host "Va a descomprimir estos ficheros, esta seguro y/n?"
   if($input -Match "y")
   {
     sz x *.zip -o*
   }
}
