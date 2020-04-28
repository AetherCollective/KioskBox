# KioskBox

 A Kiosk Mode Shell Replacement for LaunchBox BigBox.

---

## Installation

1.  Extract latest release into the LaunchBox folder.
2.  Configure as desired.
3.  Test configuration by running running `KioskBox.exe`.
4.  Once you are happy with the configuration, install by running `KioskBox.exe` with the flag `--install` or `-i`.

---

## Uninstallation

1.  If you are unhappy with KioskBox, you can uninstall it by running `KioskBox.exe` with the flag `--uninstall` or `-u`.
2.  Delete the `KioskBox` folder within LaunchBox.
3.  Delete the `KioskBox.exe` file from within LaunchBox.

---

## Configuration

 KioskBox allows you to start programs along with BigBox. To enable this feature, simply create a .ini file with any name in the `KioskBox\Startup` folder. The top line should contain the text `[General]`. Underneath, you may configure it with the follow possible options:

-   `Execute=C:\Path\To\Executable.exe` (Mandatory)
-   `Parameters=--example` (Optional)
-   `WorkingDir=C:\Path\To\Working\Directory` (Optional)
-   `ShowFlag=Hide|Min|Max` (Optional) (character `|` denotes possible options)

KioskBox also allows you to change what action it takes when BigBox is closed. Simply create a `Settings.ini` file in the `KioskBox` folder. The top line should contain the text `[General]`. Underneath, you may configure it with the follow possible options:

-   `RestartAction=Relaunch|LogOff|Lock|Reboot|Suspend|Shutdown|Hibernate`

-   If `Relaunch` is used, then BigBox will relaunch itself.
-   If `LogOff`is used, then the user will be logged off.
-   If `Lock` is used, then the user will be locked.
-   If `Reboot` is used, then the computer will reboot.
-   If `Suspend` is used, then the computer will enter the low-power suspend mode.
-   If `Shutdown` is used, then the computer will shutdown.
-   If `Hibernate` is used, then the computer will hibernate.

---

## Example Configs

### KioskBox\\Settings.ini

```ini
[General]
RestartAction=Relaunch
```

### KioskBox\\Startup\\ExampleApp.ini

```ini
[General]
Execute=C:\Users\BetaL\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk
Parameters=""
WorkingDir=C:\Users\BetaL\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\
ShowFlag=Min
```

### Compiling KioskBox

1. Download and install/extract AutoIt from https://www.autoitscript.com/site/autoit/downloads/
2. Follow the instructions found at https://www.autoitscript.com/autoit3/docs/intro/compiler.htm
