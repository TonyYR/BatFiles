@echo off
echo Logs Upload

rem Using 7zip
set zipExe="C:\Program Files\7-Zip\7zG.exe"
rem Copy元
set Target=C:\Users\XXXX
set Destination=\\172.xxxx\\YYYY

cd %Target%
echo %Target%
rem Network connection check
ping -n 2 "172.17.90.136"

if errorlevel 1 (

	echo File Network接続、VPN接続を確認してください
	pause
	exit
)

rem compress specific folders in Target Folder
for /d %%a in (*) do (
    echo %Target%\%%a\
	cd %Target%\%%a\
	for /d %%b in (*) do (
		cd %Target%\%%a\%%b\
		echo %%b
		
		if %%b==Logs (
			for /d %%c in (*) do (
			cd %Target%\%%a\%%b\%%c\
			
			for /d %%d in (*) do (
			cd %Target%\%%a\%%b\%%c\%%d
			
			for /d %%e in (*) do (
				if exist "%Target%\%%a\%%b\%%c\%%d\%%e" (
				%zipExe% a -tzip -sdel %%e.zip "%Target%\%%a\%%b\%%c\%%d\%%e"
				)
				rem move　"%Target%\%%a\%%b\%%c\%%d\%%e.zip" "%Destination%\%%a\%%b\%%c\%%d"
					)
				)
			)
		) else if %%b==LottrackFiles (
			for /d %%c in (*) do (
			cd %Target%\%%a\%%b\%%c\
			
			for /d %%d in (*) do (
			cd %Target%\%%a\%%b\%%c\%%d
			
			for /d %%e in (*) do (
				if exist "%Target%\%%a\%%b\%%c\%%d\%%e" (
				%zipExe% a -tzip -sdel %%e.zip "%Target%\%%a\%%b\%%c\%%d\%%e"
				)
				rem move　"%Target%\%%a\%%b\%%c\%%d\%%e.zip" "%Destination%\%%a\%%b\%%c\%%d"
					)
				)
			)
		)
	)
)

set str=
:REMOVE
rem upload to the server
xcopy "%Target%" "%Destination%" /D/S/R/Y/I/K/Z

if %errorlevel%==0 (
	del /S/Q %Target%
) else if %errorlevel%==4 (
	echo Network Errorが発生しました。再接続してください。
	set /p str="リトライしますか？ Y/N >>> "
)

if not %str% == "" (
	if %str% == "Y" (
			goto REMOVE
	) else if not %str% == "N" (
		echo YかNを入力してください
	)	
)
echo Uplaod completed
pause