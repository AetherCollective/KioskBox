#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=0.1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <AutoItConstants.au3>
#include <File.au3>

;~ Detects if user ran this program with the install or uninstall flags. Does the appropriate action if needed.
Select
	Case StringInStr(Eval("cmdlineraw"), "--install") > 0 Or StringInStr(Eval("cmdlineraw"), "-i") > 0
		_doInstall()
	Case StringInStr(Eval("cmdlineraw"), "--uninstall") > 0 Or StringInStr(Eval("cmdlineraw"), "-u") > 0
		_doUninstall()
EndSelect

;~ Get user's settings
$sRestartAction = IniRead(@ScriptDir & "\KioskBox\settings.ini", "General", "RestartAction", "Relaunch")

;~ If user enabled startup tasks, then launch all tasks in the 'KioskBox\Startup' folder.
_doStartup()

;~ Run BigBox and wait for it to start loading
_doExec_BigBox(True)

;~ If user enabled the restart service, then start the watcher service.
AdlibRegister("_RestartService")

;~ Idle Loop to prevent wasting cpu cycles
While 1
	Sleep(60000)
WEnd

;~ Detects if BigBox is running and runs the RestartAction if it isn't.
Func _RestartService()
	$aProcessList = ProcessList("BigBox.exe")
	If $aProcessList[0][0] = 0 Then _doRestartAction()
EndFunc   ;==>_RestartService

;~ Detects and runs any program defined in 'KioskBox\Startup'. Accepts .ini config files.
Func _doStartup()
	Local $aStartupList = _FileListToArray(@ScriptDir & "\KioskBox\Startup", "*.ini", $FLTA_FILES, True)
	If @error <> 0 Then
		Return
	Else
		For $i = 1 To $aStartupList[0]
			Local $sEXE = IniRead($aStartupList[$i], "General", "Execute", "")
			If $sEXE = "" Then ContinueLoop
			Local $sParameters = IniRead($aStartupList[$i], "General", "Parameters", "")
			Local $sWorkingDir = IniRead($aStartupList[$i], "General", "WorkingDir", @ScriptDir)
			Local $sShowFlag = IniRead($aStartupList[$i], "General", "ShowFlag", @SW_SHOW)
			Select
				Case StringInStr($sShowFlag, "Hide") > 0 Or StringInStr($sShowFlag, "Hidden") > 0
					$sShowFlag = @SW_HIDE
				Case StringInStr($sShowFlag, "Min") > 0 Or StringInStr($sShowFlag, "Minimize") > 0
					$sShowFlag = @SW_MINIMIZE
				Case StringInStr($sShowFlag, "Max") > 0 Or StringInStr($sShowFlag, "Maximize") > 0
					$sShowFlag = @SW_MAXIMIZE
			EndSelect
			ShellExecute($sEXE, $sParameters, $sWorkingDir, $SHEX_OPEN, $sShowFlag)
		Next
	EndIf
EndFunc   ;==>_doStartup

;~   Run BigBox. If Flag is true, then wait until process exists before continuing.
Func _doExec_BigBox($bWait = False)
	ShellExecute("BigBox.exe", "", @ScriptDir)
	If $bWait = True Then ProcessWait("BigBox.exe")
EndFunc   ;==>_doExec_BigBox

;    This contains all the possible values and actions for the 'RestartAction' value.
Func _doRestartAction()
	Switch $sRestartAction
		Case "Relaunch"
			_doExec_BigBox()
		Case "LogOff"
			Shutdown(BitOR($SD_LOGOFF, $SD_FORCEHUNG))
		Case "Lock"
			Send("{lwindown}l{lwinup}")
		Case "Reboot"
			Shutdown(BitOR($SD_REBOOT, $SD_FORCEHUNG))
		Case "Suspend"
			Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCEHUNG))
		Case "Shutdown"
			Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCEHUNG))
		Case "Hibernate"
			Shutdown(BitOR($SD_HIBERNATE, $SD_FORCEHUNG))
		Case "Disabled"
			Exit 0
	EndSwitch
EndFunc   ;==>_doRestartAction

;~   Installs the KioskBox Shell Replacement to the current user.
Func _doInstall()
	If MsgBox(BitOR($MB_YESNO, $MB_SETFOREGROUND, $MB_ICONWARNING), "KioskBox", "Would you like to install KioskBox Shell Replacement?" & @CRLF & _
			@CRLF & _
			"Warning: Only proceed if you know what you are doing." & @CRLF & _
			"This operation makes changes to your computer that can be difficult for a non-technical user to undo." & @CRLF & _
			"Do not use this on your main Windows user profile.") = $IDYES Then
		$iRet = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon", "Shell", "REG_SZ", @ScriptDir & "\BigBox.exe")
		If $iRet <> 1 Then
			MsgBox(BitOR($MB_SETFOREGROUND, $MB_ICONERROR), "KioskBox", _
					"Unable to install." & @CRLF & _
					"Error Code: " & @error & @CRLF & _
					@CRLF & _
					"More Info: https://www.autoitscript.com/autoit3/docs/functions/RegWrite.htm")
			Exit 1
		EndIf
		MsgBox(BitOR($MB_SETFOREGROUND, $MB_ICONERROR), "KioskBox", "Install is successful. You can uninstall by running this program with the '--uninstall' flag.")
	EndIf
	Exit 0
EndFunc   ;==>_doInstall

;~   Uninstalls the KioskBox Shell Replacement to the current user.
Func _doUninstall()
	$iRet = RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon", "Shell")
	Switch $iRet
		Case 0
			MsgBox(BitOR($MB_SETFOREGROUND, $MB_ICONINFORMATION), "KioskBox", "KioskBox is not installed.")
			Exit 0
		Case 1
			MsgBox(BitOR($MB_SETFOREGROUND, $MB_ICONINFORMATION), "KioskBox", "Uninstall is successful.")
			Exit 0
		Case 2
			MsgBox(BitOR($MB_SETFOREGROUND, $MB_ICONERROR), "KioskBox", _
					"Unable to uninstall." & @CRLF & _
					"Error Code: " & @error & @CRLF & _
					@CRLF & _
					"More Info: https://www.autoitscript.com/autoit3/docs/functions/RegDelete.htm")
			Exit 1
	EndSwitch
EndFunc   ;==>_doUninstall
