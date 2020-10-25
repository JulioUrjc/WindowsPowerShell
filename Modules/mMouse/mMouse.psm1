[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Function mousePosition
{	
	
	<#
    .SYNOPSIS
      Guarda las posiciones del raton
    
    .DESCRIPTION 
      Guarda las posiciones del raton en un fichero y las muestra
    
    .EXAMPLE 
      mousePosition
    #> 

PARAM( $path ="pos.txt")
  for (1)
  {
    Start-Sleep -m 500
    $dY = ([System.Windows.Forms.Cursor]::Position.Y) #Y coordinates
    $dX = ([System.Windows.Forms.Cursor]::Position.X) #X coordinates
    Write-Host $dX,$dY #print
    $dX.ToString()+','+$dY.ToString() | Out-File  $path -Append
  }
}

Function mouseMove
{	
	<#
    .SYNOPSIS
     Mueve el raton a varias posiciones
    
    .DESCRIPTION 
      Mueve el raton a varias posiciones establecidas en un fichero
    
    .EXAMPLE 
      mouseMove july.txt  
    #> 

	PARAM( $path)

  Get-Content $path | %{
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($_.split(',')[0],$_.split(',')[1])
  Start-Sleep -Milliseconds 500
  $_}
}

Function clicRaton
{
   <#
    .SYNOPSIS
     Mover el raton y hacer clic en distintas posiciones
    
    .DESCRIPTION 
      Mover el raton y hacer clic en distintas posiciones dadas por un archivo
    
    .EXAMPLE 
      clicRaton july.txt  
      #acciones.txt
      #clic,442,386
      #clic,452,386
      #clic,462,386
      #clic,472,386
      #clic,482,386
      #abrir,mspaint.exe
      #principio,450,350
      #fin,400,400
      #principio,450,350
      #fin,500,400
      #principio,400,400
      #fin,500,400
      #esperar,5
      #principio,400,500
      #fin,500,500
      #esperar,5
      #principio,400,400
      #fin,400,500
      #esperar,5
      #principio,500,400
      #fin,500,500
      #colorearrojo,451,380
      #colorearmarron,448,446
    #> 
     PARAM( $path)
    $MouseEventSig=@'
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
 
  Get-Content $path | %{
    $MouseEvent = Add-Type -memberDefinition $MouseEventSig -name "MouseEventWinApi" -passThru
 
    $operacion=$_.split(',')[0]
    $param1=$_.split(',')[1]
    $param2=$_.split(',')[2]
 
    switch($operacion){
       'abrir'{
                Start-Process $param1
                Start-Sleep -Seconds 5
                break
              }
    'escribir'{
                System.Windows.Forms.SendKeys]::SendWait($param1)
                break
              }
        'clic'{
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                break
              }
     'esperar'{
                Start-Sleep -Seconds $param1
                break
              }
 'clicderecho'{
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                $MouseEvent::mouse_event(0x00000008, 0, 0, 0, 0);
                $MouseEvent::mouse_event(0x00000010, 0, 0, 0, 0);
                break
              }
       'mover'{
                for($i=0;$i -ne $param1;$i=$i+1){
                  Start-Sleep -Milliseconds 10
                  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($i,$param2)
                }
                break
              }
   'principio'{
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                break
              }
         'fin'{
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                break
              }
'colorearrojo'{
                #Hacer clic en bote de pintura, la posición se puede cambiar, en este caso es 363,155
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(363,155)
                $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                #Hacer clic en el color rojo, la posición se puede cambiar, en este caso es 767,146
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(767,146)
                $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                #Colorear con el bote de pintura una vez obtenido el color en la posición que se indica en el fichero
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                break
              }
'colorearmarron'{
                 #Hacer clic en bote de pintura, la posición se puede cambiar, en este caso es 363,155
                 [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(363,155)
                 $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                 $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                 #Hacer clic en el color rojo, la posición se puede cambiar, en este caso es 767,146
                 [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(746,167)
                 $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                 $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                 #Colorear con el bote de pintura una vez obtenido el color en la posición que se indica en el fichero
                 [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($param1,$param2)
                 $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
                 $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
                 break
              }

    }
    #Start-Sleep -Seconds 5
  }
}


Function teclado
{
  <#
    .SYNOPSIS
     Envia pulsacion del teclado
    
    .DESCRIPTION 
      Envia pulsacion del teclado
    
    .EXAMPLE 
      teclado  
    #>

  #Write some text
  Write-Host("Hi")
  #Press on Enter
  [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
  #Repeat a key
  [System.Windows.Forms.SendKeys]::SendWait("{RIGHT 5}")
}

Export-ModuleMember -function mousePosition, mouseMove, teclado, clicRaton



#############  TECLADO #################
# BACKSPACE	{BACKSPACE}, {BS}, or {BKSP}
# BREAK	{BREAK}
# CAPS LOCK	{CAPSLOCK}
# DEL or DELETE	{DELETE} or {DEL}
# DOWN ARROW	{DOWN}
# END	{END}
# ENTER	{ENTER}or ~
# ESC	{ESC}
# HELP	{HELP}
# HOME	{HOME}
# INS or INSERT	{INSERT} or {INS}
# LEFT ARROW	{LEFT}
# NUM LOCK	{NUMLOCK}
# PAGE DOWN	{PGDN}
# PAGE UP	{PGUP}
# PRINT SCREEN	{PRTSC} (reserved for future use)
# RIGHT ARROW	{RIGHT}
# SCROLL LOCK	{SCROLLLOCK}
# TAB	{TAB}
# UP ARROW	{UP}
# F1	{F1}
# F2	{F2}
# F3	{F3}
# F4	{F4}
# F5	{F5}
# F6	{F6}
# F7	{F7}
# F8	{F8}
# F9	{F9}
# F10	{F10}
# F11	{F11}
# F12	{F12}
# F13	{F13}
# F14	{F14}
# F15	{F15}
# F16	{F16}
# Keypad add	{ADD}
# Keypad subtract	{SUBTRACT}
# Keypad multiply	{MULTIPLY}
# Keypad divide	{DIVIDE}
# 
# To specify keys combined with any combination of the SHIFT, CTRL, and ALT keys, precede the key code with one or more of the following codes.
# Key	Code
# SHIFT	+
# CTRL	^
# ALT	%# 