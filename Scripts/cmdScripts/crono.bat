    @echo off
    Title Cronometro by July
    color d
    :menu
    cls
    echo.
    echo                   ********************************************
    echo                   *          Cronometro by July   1.0        *
    echo                   ********************************************
    echo.
    echo.
    echo                               1.-Cuenta ascendente
    echo                               2.-Cuenta descendente
    echo                               3.-Salir
    echo.
    echo.
    echo.
    echo.
    echo.
    set /p opc=    Teclee el numero de la opcion dada: 
    if [%opc%]==[] cls & Echo                               No has puesto nada! & pause>nul & goto menu
    if %opc%==1 goto asc
    if %opc%==2 goto desc
    if %opc%==3 goto salir
    if %opc% LSS 1 (
    goto:menu
    )
    if %opc% GTR 3 (
    goto:menu
    )
     
    :asc
    cls
    color d
     
    :Empezar
    cls
    Set /p Comenzar= Teclee un numero para empezar:
    if ["%Comenzar%"]==[""] (
    goto:Empezar
    )
    echo.
    echo.
     
    :Detencion
    cls
    set /p Detener= Indique el numero en el que parara:
    if ["%detener%"]==[""] (
    goto:Detencion
    )
     
     
    :listo
    cls
    echo.
    echo.
    echo.
    echo  El cronometro esta listo, presione una tecla para empezar...
    echo.
    echo.
    echo.
    pause > nul
    if %opc%==1 goto inicio
    if %opc%==2 goto empieza
     
     
     
    :inicio
    cls
    echo.
    echo.
    echo                      %Comenzar% %%
    timeout 1 > nul
    rem ping -n 1,5 localhost>nul
    set /a Comenzar=%Comenzar%+1
    if %Comenzar%==%Detener% goto terminado
    goto inicio
     
    :terminado
    cls
    msg * La cuenta ha terminado...
    pause > nul
    goto menu
     
     
    :desc
    color b
    cls
    set /p iniciar=Teclee el numero para empezar:
    cls
    set uno=1
    goto listo
     
     
    :empieza
    cls
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo                                       %iniciar%
    set /a iniciar=%iniciar%-%uno%
    timeout 1 > nul
    rem ping -n 2 localhost>nul
    if %iniciar%==0 goto terminado
    goto empieza
    :salir
    exit