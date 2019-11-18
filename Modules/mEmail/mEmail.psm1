####### MODULO DE EMAIL #######

Function SendEMail {
    Param (
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailTo,
        [Parameter(`
            Mandatory=$true)]
        [String]$Subject,
        [Parameter(`
            Mandatory=$true)]
        [String]$Body,
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailFrom="julio.martin.saez@gmail.com",  #This gives a default value to the $EmailFrom command
        [Parameter(`
            mandatory=$false)]
        [String]$attachment,
        [Parameter(`
            mandatory=$true)]
        [String]$Password
    )

        $SMTPServer = "smtp.gmail.com" 
        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
        if ($attachment -ne $null) {
            $SMTPattachment = New-Object System.Net.Mail.Attachment($attachment)
            $SMTPMessage.Attachments.Add($SMTPattachment)
        }
        $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom.Split("@")[0], $Password); 
        $SMTPClient.Send($SMTPMessage)
        Remove-Variable -Name SMTPClient
        Remove-Variable -Name Password

} #End Function Send-EMail

Function SendEMailSinAdjunto {
    Param (
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailTo,
        [Parameter(`
            Mandatory=$true)]
        [String]$Subject,
        [Parameter(`
            Mandatory=$true)]
        [String]$Body,
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailFrom="julio.martin.saez@gmail.com",  #This gives a default value to the $EmailFrom command
        [Parameter(`
            mandatory=$true)]
        [String]$Password
    )

        $SMTPServer = "smtp.gmail.com" 
        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
        $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom.Split("@")[0], $Password); 
        $SMTPClient.Send($SMTPMessage)
        Remove-Variable -Name SMTPClient
        Remove-Variable -Name Password

} #End Function Send-EMail


# mensaje "body" "attachment dir"
Function mensaje{
  <#
    .SYNOPSIS
     Enviar emails a mi propio correo
    
    .DESCRIPTION 
      Envia email a mi propio correo y desde mi propio correo, puedo ademas anadir un adjunto
    
    .EXAMPLE 
      mensaje
    .EXAMPLE 
      mensaje "mi Texto"
    .EXAMPLE 
      mensaje "mi Texto" "C:\miFichero.txt"
     
  #> 

  Param([String]$body = "Test body",
         $attach="",
         [Parameter(`
            Mandatory=$true)]
         $password)

   if ($attach -eq "")
   {
    SendEMailSinAdjunto -EmailFrom "julio.martin.saez@gmail.com" -EmailTo "julio.martin.saez@gmail.com" -Body $body -Subject "Test Subject" -password $password
   }
   else{
    SendEMail -EmailFrom "julio.martin.saez@gmail.com" -EmailTo "julio.martin.saez@gmail.com" -Body $body -Subject "Test Subject" -attachment $attach -password $password
   }
}

# email "body" "attachment dir"
Function email{
  <#
    .SYNOPSIS
     Enviar emails a mi propio correo
    
    .DESCRIPTION 
      Envia email a mi propio correo y desde mi propio correo, puedo ademas anadir un adjunto
    
    .EXAMPLE 
      email
    .EXAMPLE 
      email "mi Texto"
    .EXAMPLE 
      email "mi Texto" "C:\miFichero.txt"
     
  #> 

  Param([String]$body = "Test body",
         $attach="",
         [Parameter(`
            Mandatory=$true)]
         $de,
         [Parameter(`
            Mandatory=$true)]
         $para,
                  [Parameter(`
            Mandatory=$true)]
         $asunto,
         [Parameter(`
            Mandatory=$true)]
         $password)

   if ($attach -eq "")
   {
    SendEMailSinAdjunto -EmailFrom $de -EmailTo $para -Body $body -Subject $asunto -password $password
   }
   else{
    SendEMail -EmailFrom $de -EmailTo $para -Body $body -Subject $asunto -attachment $attach -password $password
   }
}

############################################################
#################### Pipe ##################################

Function writePipe
{
  PARAM ($message="Write something")

  $name = 'july'
  $namedPipe = New-Object IO.Pipes.NamedPipeServerStream($name, 'Out')
  $namedPipe.WaitForConnection()
  
  $script:writer = New-Object IO.StreamWriter($namedPipe)
  $writer.AutoFlush = $true
  $writer.WriteLine($message)
  $writer.Dispose()
  
  $namedPipe.Dispose()
}

Function readPipe
{
  $name = 'july'
  $namedPipe = New-Object IO.Pipes.NamedPipeClientStream('.', $name, 'In')
  $namedPipe.Connect()
  
  $script:reader = New-Object IO.StreamReader($namedPipe)
  $reader.ReadLine()
  $reader.Dispose()
  
  $namedPipe.Dispose()
}

Export-ModuleMember -function mensaje, email, writePipe, readPipe