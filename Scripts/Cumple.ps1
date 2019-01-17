
<#PSScriptInfo

.VERSION 1.0

.AUTHOR Julio Martin

.COMPANYNAME 
.COPYRIGHT 
.TAGS
  cumple

.LICENSEURI 
.PROJECTURI 
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES

.DESCRIPTION 
    Dias que quedan para mi cumple
.EXAMPLE 
    cumple

 
#> 

Function cero
{
	echo "

     MMMMMMM 
     M     M
     M     M
     -     -
     M     M
     M     M
     MMMMMMM
	"
}

Function uno
{
	echo "

       ^
      M MM
     M  MM
        MM
        MM
        MM
        MM
	"
}

Function dos
{
	echo "

      .MMMMM
     .M     M
     M      M
          .M
        MM
      MM
     MMMMMMMM
	"
}

Function tres
{
	echo "

     MMMMMM
          MM
          M
      .MMM
          M
     M    MM
      MMMMMM
	"
}

Function cuatro
{
	echo "

     M 
     M    MM
     M    MM
      MMMM
          MM
          MM
          MM
	"
}

Function cinco
{
	echo "

     MMMMMMM 
     M    
     M    
      MMMM
          MM
          MM
     MMMMMMM
	"
}

Function seis
{
	echo "

     MMMMMMM 
     M    
     M    
     -MMMMM
     MM   MM
     MM   MM
     MMMMMMM
	"
}

Function siete
{
	echo "

     MMMMMMM 
          MM
         MM 
      MMMMMM
       MM 
      MM 
     MM
	"
}

Function ocho
{
	echo "

     MMMMMMM 
     M     M
     M     M
     -MMMMM-
     MM   MM
     MM   MM
     MMMMMMM
	"
}

Function nueve
{
	echo "

     MMMMMMM 
     M     M
     M     M
     -MMMMM-
          MM
          MM
     MMMMMMM
	"
}

Function cumple 
{
    $cumple = ((Get-Date -Month 03 -Day 11 -Year 2019) - (Get-Date)).Days+1
    $cumple2 = 0
    $obj

  while ( $cumple -gt 9 )
  {
    $cumple2 = $cumple2*10 + ($cumple % 10)
    [int] $cumple =  [Math]::floor($cumple / 10)
    if ($cumple2 -eq 0) {$cero++} 
  }
  $cumple2 = $cumple2*10 + ($cumple % 10)

	while ( $cumple2 -gt 9 )
	{
		$num = $cumple2 % 10

		[int]  $cumple2 = [Math]::floor($cumple2 / 10)

		switch ( $num )
    	{
    	    0 { $obj+=cero  }
        	1 { $obj+=uno  }
        	2 { $obj+=dos  }
        	3 { $obj+=tres  }
        	4 { $obj+=cuatro  }
        	5 { $obj+=cinco }
        	6 { $obj+=seis  }
        	7 { $obj+=siete  }
        	8 { $obj+=ocho  }
        	9 { $obj+=nueve  }   	
    	}
	}


	 switch ( $cumple2 )
   {
      0 { $obj+=cero  }
    	1 { $obj+=uno  }
    	2 { $obj+=dos  }
    	3 { $obj+=tres  }
    	4 { $obj+=cuatro  }
    	5 { $obj+=cinco }
    	6 { $obj+=seis  }
    	7 { $obj+=siete  }
    	8 { $obj+=ocho  }
    	9 { $obj+=nueve  }   	
  }

  while ($cero -gt 0) 
  {
    $obj+=cero
    $cero--
  }
  $obj
}

cumple