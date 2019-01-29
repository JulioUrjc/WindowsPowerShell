
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
		  [ValidateRange(1,9999)][int]$YearNumber = (Get-Date).Year
       )

<# 2019 Spain Holydays#>
$hollydays = @(
	,@(1,7)
	,@()
	,@()
	,@(19)
	,@(1,2)
	,@()
	,@()
	,@(15)
	,@()
	,@(12)
	,@(1)
	,@(8,25)
)

    $MonthNumber = 1..12

	$DaysOfWeek = [ordered]@{}
	$StandardWeekDays = @("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
	$StandardWeekDays[$StandardWeekDays.IndexOf( "Monday")..6+0..($StandardWeekDays.IndexOf("Monday"))] | select -First 7 | % -begin {[int]$i = 0} -process {$DaysOfWeek.Add([string]$([int]$i++),$_)}
	
	$NowDate = (Get-Date).Date
	$DaysOfWeekByName = [ordered]@{}
	$DaysOfWeek.GetEnumerator() | % {$DaysOfWeekByName.Add($_.Value,$_.Key)}

	for($count=0; $count -lt 12; $count++)
	{
		if ($YearNumber -eq (Get-Date).Year){ $AddHolyDays = $hollydays[$count] }
		
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
	$PR = 5
	$esp = "     "

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

	    for($sem=0 ; $sem -lt 5 ; $sem++)
	    {
	       $mes = $mes -3
	       for($count=0; $count -lt 3; $count++){

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
	          Write-Host ($esp) -NoNewLine -ForegroundColor White
   		   }
	       Write-Host ''	    
	    }
 		Write-Host ''

	 }
