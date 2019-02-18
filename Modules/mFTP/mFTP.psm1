####### MODULO FTP #######

Function verFtp 
{ 
  <#
    .SYNOPSIS
     Muestra ficheros FTP
    
    .DESCRIPTION 
      Muestra ficheros de un directorio FTP
    
    .EXAMPLE 
      verFtp $server $username $password $directory
  #> 

  Param (
    [System.Uri]$server,
    [string]$password,
    [string]$directory,
    [string]$username= "july"
  )

  try 
  {
    #Create URI by joining server name and directory path
    $uri =  "ftp://$server$directory" 

    #Create an instance of FtpWebRequest
    $FTPRequest = [System.Net.FtpWebRequest]::Create($uri)
    
    #Set the username and password credentials for authentication
    $FTPRequest.Credentials = New-Object System.Net.NetworkCredential($username, $password)
   
    #Set method to ListDirectoryDetails to get full list
    #For short listing change ListDirectoryDetails to ListDirectory
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
    
    #Get FTP response
    $FTPResponse = $FTPRequest.GetResponse() 
    
    #Get Reponse data stream
    $ResponseStream = $FTPResponse.GetResponseStream()
    
    #Read data Stream
    $StreamReader = New-Object System.IO.StreamReader $ResponseStream  
   
    #Read each line of the stream and add it to an array list
    $files = New-Object System.Collections.ArrayList
    While ($file = $StreamReader.ReadLine())
     {
       [void] $files.add("$file")
      
    }

  }
  catch {
    #Show error message if any
    write-host -message $_.Exception.InnerException.Message
  }

    #Close the stream and response
    $StreamReader.close()
    $ResponseStream.close()
    $FTPResponse.Close()

    $files
    write-host ""
}

Export-ModuleMember -function verFtp