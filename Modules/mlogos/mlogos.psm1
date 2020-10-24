####### MODULO DE LOGOS #######

Function logo0
{
  <#
    .SYNOPSIS
     Logo ojos   
    .DESCRIPTION 
      Logo ojos
    .EXAMPLE 
      logo 0  
  #> 
	 echo "
                                          .::!!!!!!!:.
         .!!!!!:.                        .:!!!!!!!!!!!! 
         ~~~~!!!!!!.                 .:!!!!!!!!!UWWWSSS 
             :SSNWX!!:           .:!!!!!!XUWWSSSSSSSSSP
             SSSSSOOWX!:      .<!!!!UWSSSS*  SSSSSSSSO
             SSSSS  SSSUX   :!!UWSSSSSSSSS   4SSSSS*
             ^SSSB  SSSS\     SSSSSSSSSSSS   dSSR*
               **SbdSSSS      **SSSSSSSSSSSo+#*
                    ****          ********
     "
}

Function logo1
{
 <#
    .SYNOPSIS
     Logo batman   
    .DESCRIPTION 
      Logo batman
    .EXAMPLE 
      logo 1 
  #> 
     echo "
	       _,    _   _    ,_
          .o888P     Y8o8Y     Y888o.
         d88888      88888      88888b
        d888888b_  _d88888b_  _d888888b
        8888888888888888888888888888888
        8888888888888888888888888888888
        YJGS8P*Y888P*Y888P*Y888P*Y8888P
         Y888   '8'   Y8P   '8'   888Y
          '8o          V          o8'
            '                     '
     "
}

Function logo2
{
 <#
    .SYNOPSIS
     Logo shadowgate 
    .DESCRIPTION 
      Logo shadowgate
    .EXAMPLE 
      logo 2
  #> 
    echo "
    
           /===    \      I//|  |  |  ||  ||  |  |  |\\I      /===    \
           \==     /   ! /|/ |  |  |  ||  ||  |  |  | \|\ !   \==     /
            \_____/    I//|  |  |  |_/_ /_  _ |  |  |  |\\I    \_____/
             _} {_  ! /|/ |  |  |   (_ / / (/_   |  |  | \|\ !  _} {_
            {_____} I//|  |  |  |  |  ||  ||  |  |  |  |  |\\I {_____}
       !  !  |=  |=/|/ |  |  |  |  |  ||  ||  |  |  |  |  | \|\=|-  |  !  ! 
      _I__I__|   ||/ ____  ___ ___ ____  ___   ____ __     __ \||   |__I__I_
      -|--|--|-  || / __//| ||| ||/ _ \\|   \\/   \\||| _ | || ||=  |--|--|-
      _|__|__|   || \__ \\|     || //\ || | ||  | || ||/\\| || ||-  |__|__|_
      -|--|--|   || /___//|_|||_||_|||_||___//\___//\__/\__//  ||   |--|--|- 
       |  |  |=  ||           ____  ____  _____  ____          ||   |  |  | 
       |  |  |   || |  |  |  /  _||/ _ \\|_   _|| __|| |  |  | ||=  |  |  | 
       |  |  |-  || |  |  | |  | \\ //\ || | || | _||  |  |  | ||   |  |  | 
       |  |  |   || |  |  |  \___||_|||_|| |_|| |___|| |  |  | ||=  |  |  |
       |  |  |=  || |  |  |                            |  |  | ||   |  |  |
       |  |  |   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||   |  |  |
       |  |  |   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||-  |  |  |
      _|__|__|   || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||=  |__|__|_
      -|--|--|=  || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||   |--|--|-
      _|__|__|   ||_|__|__|__|__|__|__||  ||__|__|__|__|__|__|_||-  |__|__|_
      -|--|--|=  ||-|--|--|--|--|--|--||  ||--|--|--|--|--|--|-||=  |--|--|-
          |  |-  || |  |  |  |  |  |  ||  ||  |  |  |  |  |  | ||-  |  |  |
     ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~
    "
}

Function logo3
{
 <#
    .SYNOPSIS
     Logo julyadmin
    .DESCRIPTION 
      Logo julyadmin
    .EXAMPLE 
      logo 3
  #> 
    echo "	
     ____.     .__                _____       .___      .__        
    |    |__ __|  | ___.__.      /  _  \    __| _/_____ |__| ____  
    |    |  |  \  |<   |  |     /  /_\  \  / __ |/     \|  |/    \ 
/\__|    |  |  /  |_\___  |    /    |    \/ /_/ |  Y Y  \  |   |  \
\________|____/|____/ ____|    \____|__  /\____ |__|_|  /__|___|  /
                    \/                 \/      \/     \/        \/  
    "
}

Function logo4
{
 <#
    .SYNOPSIS
     Logo xflow
    .DESCRIPTION 
      Logo xflow
    .EXAMPLE 
      logo 4
  #> 
    echo "  
                     IIIIIIIII MMM                           
          ::III    IIII:::::: MMM                            
            III  II= MMM     MMMM  SMMMMM,  MM          =MM  
            ,IIIII ,MMMMMMM ,MMM MMMMMMMMM ,MM   MMMM  SMM  
             III,  MMMMMMM  MMM MMM     MMM MM  MMMMM =MM    
          =IIIIII MMMM     MMM MMM=    =MMM MM MMSMMMMMM,    
        IIIII III,MMM      MMM MMM     MMM MMMMM= MMMMM,     
      IIIII   II MMM      MMM  MMMM  MMMM, MMMMS  MMMM       
    IIIIII     IMMM      MMM    MMMMMMM=   MMM=   MMM        
    "
}


Function logoRandom
{  
  <#
    .SYNOPSIS
     Selecciona un logo random
    .DESCRIPTION 
      Selecciona un logo random de entre la lista de 5
    .EXAMPLE 
     logoRandom
  #> 

    $option = random 5

    switch ( $option )
    {
        0 { logo0  }
        1 { logo1  }
        2 { logo2  }
        3 { logo3  }
        4 { logo4  }
    }
}

Export-ModuleMember -function logo0,logo1,logo2,logo3,logo4, logoRandom