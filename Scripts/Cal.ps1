
<#PSScriptInfo

.VERSION 1.0

.GUID 39394cd9-352b-4944-8c89-6fac36623acc

.GUID

.AUTHOR Julio Martin
.COMPANYNAME 
.COPYRIGHT 

.TAGS
 Calendar Russian HolyDays

.LICENSEURI 
.PROJECTURI 
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES

.DESCRIPTION 
 	Calendar Russian HolyDays and Show Pseudographics Preview support specify First day of week
.EXAMPLE 
Cal 5 2016
.EXAMPLE 
Cal 5 2016 -Internet
.EXAMPLE 
Cal 5 2016 -FistDayOfWeek Sunday
 
#> 

param(
		[ValidateRange(1,12)][int]$MonthNumber = (Get-Date).Month,
		[ValidateRange(1,9999)][int]$YearNumber = (Get-Date).Year,
		[int[]]$AddWorkDays,
		[int[]]$AddHolyDays,
		[ValidateSet("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")][string]$FistDayOfWeek = "Monday",
		[switch]$Internet
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

if ($YearNumber -eq (Get-Date).Year){ $AddHolyDays = $hollydays[$MonthNumber-1] }

	Function ParseHoliday {
		[CmdletBinding()]
		param(
			[ValidateRange(1,12)][int]$MonthNumber = (Get-Date).Month,
			[ValidateRange(2003,9999)][int]$YearNumber = (Get-Date).Year
		)
		$WorkDayCode = [ordered]@{
			"0"=$True
			"2"=$False
			"3"=$True
		}
		
		if(!$Global:ParsedAllHoliday){
			$WebRequest = Invoke-WebRequest -Uri 'http://basicdata.ru/api/json/calend/' -ErrorAction SilentlyContinue
			if(!$WebRequest.Content){write-verbose "ooops"; break}
			$Json = $WebRequest.Content | ConvertFrom-Json
			$Global:ParsedAllHoliday = $Json.data
		}
		
		$ParsedAllHolidayOfMonth = $ParsedAllHoliday.$YearNumber.$MonthNumber
		$DaysFoundHash = @{}
		1..$([DateTime]::DaysInMonth($YearNumber,$MonthNumber)) | % {
			if($ParsedAllHolidayOfMonth.$_){$DaysFoundHash.Add($_,$([bool]$WorkDayCode["$($ParsedAllHolidayOfMonth.$_.isWorking.ToString())"]))
			}
			
		}
		$DaysFoundHash
	}
	
	if($Internet -or $ParsedAllHoliday){$ParsedHoliday = ParseHoliday -MonthNumber $MonthNumber -YearNumber $YearNumber}
	$DaysOfWeek = [ordered]@{}
	$StandardWeekDays = @("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
	$StandardWeekDays[$StandardWeekDays.IndexOf($FistDayOfWeek)..6+0..($StandardWeekDays.IndexOf($FistDayOfWeek))] | select -First 7 | % -begin {[int]$i = 0} -process {$DaysOfWeek.Add([string]$([int]$i++),$_)}
	
	$NowDate = (Get-Date).Date
	
	$DaysOfWeekByName = [ordered]@{}
	$DaysOfWeek.GetEnumerator() | % {$DaysOfWeekByName.Add($_.Value,$_.Key)}

	$FirstDay = (Get-Date -Year $YearNumber -Month $MonthNumber -Day 1).Date
	$MonthDayCount = [DateTime]::DaysInMonth($YearNumber,$MonthNumber)
	$DaysOfMonth = @(1..$MonthDayCount) | % {$FirstDay | Get-Date -Day $_}
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name WorkDay -Value $Null -Force
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name HolyDay -Value $false -Force
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayColor -Value $Null -Force
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayBgColor -Value $Null -Force
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name DayOfWeekNum -Value $Null -Force
	$DaysOfMonth | Add-Member -MemberType NoteProperty -Name WeekOfMonthNum -Value $Null -Force
		
	$DaysOfMonth | % -Begin {[int]$WeekOfMonthNum = 0} -Process {
		$_.DayOfWeekNum = $DaysOfWeekByName["$($_.DayOfWeek)"]
		if($DaysOfWeek[0..4] -contains $_.DayOfWeek){$_.WorkDay = $true}else{$_.WorkDay = $false}
		if($Internet -or $ParsedAllHoliday){
			if($ParsedHoliday[$_.Day] -is [bool]){
				$_.WorkDay = $ParsedHoliday[$_.Day]
				
			}
		}
		if($AddWorkDays -contains $_.Day){$_.WorkDay = $true}
		if($AddHolyDays -contains $_.Day){$_.WorkDay = $false; $_.HolyDay = $true}
		if($_.WorkDay -eq $true){$_.DayColor = 'White'}else{$_.DayColor = 'Red'}
        if($_.HolyDay -eq $true){$_.DayColor = 'Blue'}
		if($_.Date -eq $NowDate){$_.DayBgColor = 'DarkGray'}else{$_.DayBgColor = 'Black'}
		$_.WeekOfMonthNum = $WeekOfMonthNum
		if($_.DayOfWeekNum -eq 6){$WeekOfMonthNum++}
	}
	$Global:DaysOfMonth = $DaysOfMonth
	$char = [string][char]183*2
	$WeeksHash = [ordered]@{}
	$DaysOfMonth | select  -Property WeekOfMonthNum -Unique | % {$WeeksHash.Add($_.WeekOfMonthNum,[ordered]@{'0'=$char;'1'=$char;'2'=$char;'3'=$char;'4'=$char;'5'=$char;'6'=$char})}
	$DaysOfMonth | % -Begin {[int]$i = 0} -Process {
		$WeeksHash[$i]["$($_.DayOfWeekNum)"] = $_
		if($_.DayOfWeekNum -eq 6){$i++}
	}
	
	$PL = 4
	$PR = 6
	Write-Host ''
	Write-Host $($FirstDay.ToString('yyyy  MMMM').Padright($($PL*7),' ').PadLeft($($PR*7),' ')) -BackgroundColor DarkRed -ForegroundColor White
	$DaysOfWeek.Values | % {Write-Host $([string]$($_.Remove(3).PadLeft($PL,' ').Padright($PR,' '))) -NoNewLine -BackgroundColor Black -ForegroundColor Yellow}
	Write-Host ''
	$DaysOfWeek.Values | % {Write-Host $([string]$('---'.PadLeft($PL,' ').Padright($PR,' '))) -NoNewLine -BackgroundColor Black -ForegroundColor DarkCyan}
	Write-Host ''
	
	$WeeksHash.GetEnumerator() | % {$_.Value} | % {
		$_.Values | % {
			if($_ -eq $char){
				Write-Host $($_.ToString().PadLeft($PL,' ').Padright($PR,' ')) -NoNewline -BackgroundColor Black -ForegroundColor DarkCyan
			}else{
				Write-Host $($_.Day.ToString().PadLeft($PL,' ').Padright($PR,' ')) -NoNewline -BackgroundColor $($_.DayBgColor) -ForegroundColor $($_.DayColor)
			}
		} 
		Write-Host ''
	}
	Write-Host ''

