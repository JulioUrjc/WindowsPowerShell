Option Explicit
Dim Row, XL, WshShell, FileSystem, RegularExpression, Dummy, TheNVFile, TheLine
Dim Whacks, WhacksFound, WhacksPattern,  Flag, HostName, NBTable, PingReport, PingPattern
Dim IPAddress, MACPattern, MACAddress, Matches, TheMatch, Match, NBCommand, TheNBTFile
Dim IPCommand, TheIPFile, FileName, TheDate, Suggestion, Book

Const ForReading = 1
Row = 2

Set XL = WScript.CreateObject("Excel.Application")
Set WshShell = WScript.CreateObject("WScript.Shell")
Set FileSystem = CreateObject("Scripting.FileSystemObject")
Set RegularExpression = New RegExp

Dummy = WshShell.Popup ("Compiling Network Address Inventory.  Please Wait...",1,"Network Address Inventory Utility",64)

Call BuildSpreadSheet()

WshShell.Run "Cmd.exe /c Net View > C:\Windows\Temp\NetViewList.txt", 2,True
Set TheNVFile = FileSystem.OpenTextFile("C:\Windows\Temp\NetViewList.txt", ForReading, True)

Do While TheNVFile.AtEndOfStream <> True
	TheLine = TheNVFile.ReadLine
	Whacks = "\\"
	WhacksFound = FindPattern(TheLine, Whacks)
	If WhacksFound Then
		WhacksPattern = "\\\\\S*"
		Flag = "1"
		HostName = GetPattern(TheLine, WhacksPattern, Flag )
		NBTable = GetNBTable(HostName)
		MACPattern = "MAC Address = \S*"
		Flag = "2"
		MACAddress = GetPattern(NBTable, MACPattern, Flag )
		PingReport = GetIPAddress(HostName)
		PingPattern = "Reply from \S*"
		Flag = "3"
		IPAddress = GetPattern(PingReport, PingPattern, Flag )
		IPAddress = Replace(IPAddress, ":", "") 
		Call AddToSpreadSheet(HostName, IPAddress, MACAddress)
	End If
Loop    

TheNVFile.Close
FileSystem.DeleteFile("C:\Windows\Temp\NetViewList.txt")
Dummy = WshShell.Popup ("Network Address Inventory Operation Complete",5,"Network Address Inventory Utility",64 )
Call SaveSpreadSheet()
Wscript.Quit

Sub BuildSpreadSheet()
	XL.Visible = True
	Set Book = XL.WorkBooks.Add
	XL.Columns(1).ColumnWidth = 20
	XL.Columns(2).ColumnWidth = 20
	XL.Columns(3).ColumnWidth = 20
	XL.Cells(1, 1).Value = "Nombre Equipo"
	XL.Cells(1, 2).Value = "Direccion IP"
	XL.Cells(1, 3).Value = "Direccion MAC"
	XL.Range("A1:C1").Select
	XL.Selection.Font.Bold = True
	XL.Selection.Font.Size = 12
End Sub

Sub AddToSpreadSheet(HostName, IPAddress, MACAddress)
	XL.Cells(Row, 1).Value = HostName
	XL.Cells(Row, 2).Value = IPAddress
	XL.Cells(Row, 3).Value = MACAddress
	Row = Row + 1
	XL.Cells(Row, 1).Select
End Sub

Sub SaveSpreadSheet()
	TheDate = Date
	TheDate = Replace(TheDate, "/", "-")
	Suggestion = "NetAI " & TheDate & ".xls"
	FileName = XL.GetSaveAsFilename(Suggestion)
	If FileName <> False Then
		Book.SaveAs(FileName)
	End If
End Sub  

Function FindPattern(TheText, ThePattern)
	RegularExpression.Pattern = ThePattern
	If RegularExpression.Test(TheText) Then
		FindPattern = "True"
	Else
		FindPattern = "False"
	End If
End Function

Function GetPattern(TheText, ThePattern, Flag)
	RegularExpression.Pattern = ThePattern
	Set Matches = RegularExpression.Execute(TheText) 
	For Each Match in Matches
		TheMatch = Match.Value 
		If Flag = "1" Then TheMatch = Mid(TheMatch, 3)
		If Flag = "2" Then TheMatch = Mid(TheMatch, 14)
		If Flag = "3" Then TheMatch = Mid(TheMatch, 11)
	Next
	GetPattern = TheMatch
End Function

Function GetNBTable(HostName)
	NBCommand = "nbtstat -a " & HostName
	WshShell.Run "Cmd.exe /c " & NBCommand &" > C:\Windows\Temp\NBTList.txt", 2,True
	Set TheNBTFile = FileSystem.OpenTextFile("C:\Windows\Temp\NBTList.txt", ForReading, True)
	GetNBTable = TheNBTFile.ReadAll
	TheNBTFile.Close
	FileSystem.DeleteFile("C:\Windows\Temp\NBTList.txt")
End Function

Function GetIPAddress(HostName)
	IPCommand = "ping -n 1 " & HostName
	WshShell.Run "Cmd.exe /c " & IPCommand &" > C:\Windows\Temp\IPList.txt", 2,True
	Set TheIPFile = FileSystem.OpenTextFile("C:\Windows\Temp\IPList.txt", ForReading, True)
	GetIPAddress = TheIPFile.ReadAll
	TheIPFile.Close
	FileSystem.DeleteFile("C:\Windows\Temp\IPList.txt")
End Function