
<#PSScriptInfo

.VERSION 1.0

.GUID 590eb6bb-aecb-42d8-b921-8ab58298223e

.AUTHOR Julio Martin
.COMPANYNAME 
.COPYRIGHT 

.TAGS
 Calendar Holydays

.LICENSEURI 
.PROJECTURI 
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES

.DESCRIPTION 
 	Calendar holydays
.EXAMPLE 
  calendario

.EXAMPLE
  calendario $anyo
 
#> 

param(
    [ValidateRange(1,9999)][int]$YearNumber = (Get-Date).Year,
    $isVacaciones = $true,
    $isDiasSenalados = $false
)

Function fillHollidaysArray {
    Param ($fichero)

    if (Test-Path $fichero)
    {
      $hollydays = [System.Collections.ArrayList]@()
      Get-Content $fichero | ForEach-Object { 
	    $auxiliar = [System.Collections.ArrayList]@()
	      foreach($word in $_.Split(" ")) {
		    if([Microsoft.VisualBasic.Information]::IsNumeric($word))
		    {
			  $arrayID = $auxiliar.Add($word)
		    }
          }
        $arrayID = $hollydays.Add($auxiliar)
      } 

      return $hollydays
    }
}

Add-Type -Assembly Microsoft.VisualBasic
$vacacionesPorAnyo = 30
$profileDir = ([system.io.fileinfo]$profile).DirectoryName+"\Scripts"


if($YearNumber -eq 2018){ $vacacionesPorAnyo = 27} 
if($YearNumber -eq (Get-Date).Year){ $fechasSenaladasFichero = $profileDir+"\vacaciones\fechasSenaladas$YearNumber.txt"}

	$pendientesFichero = $profileDir+"\vacaciones\pendientes$YearNumber.txt"
    $fiestasFichero = $profileDir+"\vacaciones\fiestas$YearNumber.txt"
    $vacacionesFichero = $profileDir+"\vacaciones\$YearNumber.txt"

    $vacaciones    = fillHollidaysArray $vacacionesFichero
    $pendientes    = fillHollidaysArray $pendientesFichero
    $fiestas       = fillHollidaysArray $fiestasFichero
    $diasSenalados = fillHollidaysArray $fechasSenaladasFichero

    ForEach( $item in $vacaciones)
    {
    	$cogidos += $item.Count
    }

    $restantes = $vacacionesPorAnyo - $cogidos


    $MonthNumber = 1..12

	$DaysOfWeek = [ordered]@{}
	$StandardWeekDays = @("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
	$StandardWeekDays[$StandardWeekDays.IndexOf( "Monday")..6+0..($StandardWeekDays.IndexOf("Monday"))] | select -First 7 | % -begin {[int]$i = 0} -process {$DaysOfWeek.Add([string]$([int]$i++),$_)}
	
	$NowDate = (Get-Date).Date
	$DaysOfWeekByName = [ordered]@{}
	$DaysOfWeek.GetEnumerator() | % {$DaysOfWeekByName.Add($_.Value,$_.Key)}

	for($count=0; $count -lt 12; $count++)
	{
		if ($YearNumber -eq (Get-Date).Year){ $AddHolyDays = $fiestas[$count] }
		
		[array]$FirstDay += (Get-Date -Year $YearNumber -Month $MonthNumber[$count] -Day 1).Date
 
		$MonthDayCount = [DateTime]::DaysInMonth($YearNumber,$MonthNumber[$count])
		
		$DaysOfMonth = @(1..$MonthDayCount) | % {$FirstDay[$count] | Get-Date -Day $_}
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name WorkDay -Value $Null -Force
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name HolyDay -Value $false -Force
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayColor -Value $Null -Force
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayBgColor -Value $Null -Force
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayOfWeekNum -Value $Null -Force
		$DaysOfMonth | Add-Member -MemberType NoteProperty -Name WeekOfMonthNum -Value $Null -Force

		$DaysOfMonth | % -Begin {[int]$WeekOfMonthNum = 0} -Process { 

			 $_.DayOfWeekNum = $DaysOfWeekByName["$($_.DayOfWeek)"]
		     if($DaysOfWeek[0..4] -contains $_.DayOfWeek){ $_.WorkDay = $true }else{ $_.WorkDay = $false }	
		     if($AddHolyDays -contains $_.Day){ $_.WorkDay = $false; $_.HolyDay = $true} 
		     if($_.WorkDay -eq $true){ $_.DayColor = 'White'}else{$_.DayColor = 'Red'}
		     if($isVacaciones -AND $vacaciones -AND ($vacaciones[$count] -contains $_.Day )) {$_.DayColor = 'Green'}
		     if($isVacaciones -AND $pendientes -AND ($pendientes[$count] -contains $_.Day)){ $_.DayColor = 'Magenta'}
		     if($isDiasSenalados -AND $diasSenalados -AND ($diasSenalados[$count] -contains $_.Day)){ $_.DayColor = 'Yellow'}
             if($_.HolyDay -eq $true){ $_.DayColor = 'Blue' }
		     if($_.Date -eq $NowDate){ $_.DayBgColor = 'DarkGray' }else{ $_.DayBgColor = 'Black' }
		     $_.WeekOfMonthNum = $WeekOfMonthNum
		     if($_.DayOfWeekNum -eq 6){$WeekOfMonthNum++}
	    }
    
	    $char = [string][char]183*2
	    [array]$WeeksHash += [ordered]@{}
	    $DaysOfMonth | select  -Property WeekOfMonthNum -Unique | % {$WeeksHash[$count].Add($_.WeekOfMonthNum,[ordered]@{'0'=$char;'1'=$char;'2'=$char;'3'=$char;'4'=$char;'5'=$char;'6'=$char})}
	    $DaysOfMonth | % -Begin {[int]$i = 0} -Process {
		  $WeeksHash[$count][$i]["$($_.DayOfWeekNum)"] = $_
		  if($_.DayOfWeekNum -eq 6){$i++}
	    }
	}

	
    $mes = 0
	$PL = 3
	$PR = 4
	$esp = "     "
    $espcioMeses = "                            "

	Write-Host ''
	for($count2=0 ; $count2 -lt 4 ; $count2++)
	{
		for($count=0; $count -lt 3; $count++){
			 Write-Host ($($FirstDay[$mes++].ToString('yyyy  MMMM').Padright($($PL*7),' ').PadLeft($($PR*7),' '))) -NoNewLine -BackgroundColor DarkRed -ForegroundColor White
			 Write-Host ($esp) -NoNewLine -ForegroundColor White
		}
		Write-Host ''

	    for($count=0; $count -lt 3; $count++){
	      $DaysOfWeek.Values | % {Write-Host $([string]$($_.Remove(3).PadLeft($PL,' ').Padright($PR,' '))) -NoNewLine -BackgroundColor Black -ForegroundColor Yellow}
	      Write-Host ($esp) -NoNewLine -ForegroundColor White
	    }
	    Write-Host ''

	    for($count=0; $count -lt 3; $count++){
	      $DaysOfWeek.Values | % {Write-Host $([string]$('---'.PadLeft($PL,' ').Padright($PR,' '))) -NoNewLine -BackgroundColor     Black -ForegroundColor DarkCyan}
	      Write-Host ($esp) -NoNewLine -ForegroundColor White
	    }
	    Write-Host ''

	    for($sem=0 ; $sem -lt 6 ; $sem++)
	    {
	       $mes = $mes -3
	       for($count=0; $count -lt 3; $count++){
	       	 if($WeeksHash[$mes][$sem])
	       	 {     	
	            ForEach($items in $WeeksHash[$mes++][$sem].GetEnumerator()) {       
	       	       ForEach($item in $items) {
	       	           $aux = $item.Value
	       	           if($aux -eq $char){
	       	   	         Write-Host $($aux.ToString().PadLeft($PL,' ').Padright($PR,' ')) -NoNewline -BackgroundColor Black -ForegroundColor DarkCyan    	 
	       	           }else{
	       	   	         Write-Host $($aux.Day.ToString().PadLeft($PL,' ').Padright($PR,' ')) -NoNewline -BackgroundColor $($aux.DayBgColor) -ForegroundColor $($aux.DayColor)
	       	           }  
	       	       }  	   
	            }        
	         }else{
	         	$mes++
	         	Write-Host ($espcioMeses) -NoNewLine -BackgroundColor Black
	         }
	         Write-Host ($esp) -NoNewLine -ForegroundColor White
   		   }
	       Write-Host ''	    
	    }
 		Write-Host ''
	 }

<# cuentaAtrasCoche #> 

if ($isVacaciones)
{
  Write-Host "Dias cogidos: ${cogidos}         Dias restantes: ${restantes}" -ForegroundColor Yellow
  Write-Host ''
}

<# fechasCoche #> 