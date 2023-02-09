copy-item -path Z:\scripts\wallpaper.jpg -destination c:\windows\web\wallpaper\background.jpg -force -confirm:$false
REG LOAD HKEY_USERS\ZZZ C:\USERS\DEFAULT\NTUSER.DAT
REG ADD "HKEY_USERS\ZZZ\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColor" /t REG_DWORD /d 0xffa66c39
REG ADD "HKEY_USERS\ZZZ\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColor" /t REG_DWORD /d 0xffb51746
REG UNLOAD HKEY_USERS\ZZZ
REG ADD "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColor" /t REG_DWORD /d 0xffa66c39
REG ADD "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColor" /t REG_DWORD /d 0xffb51746
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "StartColor" /t REG_DWORD /d 0xffa66c39
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "AccentColor" /t REG_DWORD /d 0xffb51746
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /f /v "DefaultStartColor" /t REG_DWORD /d 0xffa66c39
takeown /f C:\ProgramData\Microsoft\Windows\SystemData /a /r /d y
takeown /f C:\Windows\Web\Screen\img100.jpg /a
icacls C:\Windows\Web\Screen\img100.jpg /grant Administrators:F
$lockscreen = "C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z"
$tempfolder = "C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Temp"
$img100 = Get-ChildItem C:\Windows\WinSxS -Recurse -Include img100.jpg
write-host $img100
takeown /f $img100 /a
icacls $img100 /grant Administrators:F /q
copy-item -path c:\windows\web\wallpaper\background.jpg -destination $img100 -force -confirm:$false | out-null
copy-item -path c:\windows\web\wallpaper\background.jpg -destination C:\Windows\Web\Wallpaper\Windows\BlueBackground.jpg -force -confirm:$false | out-null
copy-item -path c:\windows\web\wallpaper\background.jpg -destination C:\Windows\Web\Screen\img100.jpg -force -confirm:$false | out-null
New-Item -Path $tempfolder -ItemType "Directory" | out-null
Robocopy $tempfolder $lockscreen /zb /mir /njh /njs
Remove-Item -Path $tempfolder -force -confirm:$false | out-null