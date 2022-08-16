@echo off
echo Copy from USB to folder in PC with same directory structure as server

Setlocal enabledelayedexpansion

rem Copy開始
set Target=XXXXX

echo Network connect properly.
rem File Copy From USB
rem USB ３台分繰り返し
for %%d in (D E F) do (
	if exist %%d: (
		rem フォルダ名の読み取り
		cd /d %%d:
		
		for /d %%A in (*) do (
			rem Tool Noの抽出
			echo %%A
			set folder=%%A
			echo !folder!
			set toolNo=!folder:~7,3!
			echo !toolNo!
			
			cd %%A
			
			rem Log and LTF
			for /d %%B in (*) do (
				set folder2=%%B
				set type = !folder2:~0,3!
				rem Log or LTF
				
				if "!type!"="Log" (
					set org = !folder2!\
					set dir =
					for /d %%C in (!org!) do (
						set folder3=%%C
						set ct = !folder3:~0,3!
						if "!ct!"="!toolNo!" (
							dir = !ct!
							goto :th
						)
					)
					:th
					rem 年月の確認
					set y =
					set m =
					for /d %%T in (!folder2!) do (
						set date = %%T						
						y = !date:~0,4!
						m = !date:~4,2!
						goto :th2
					)
					:th2
					
					if not exist %Target%\!dir!\Logs\!y! (
						mkdir(%Target%\!dir!\Logs\!y!)
					)
					
					set mf =
					if "!m!" = "01" (
						mf = Jan_%y%
					) else if m = "02" (
						mf = Feb_%y%
					) else if m = "03" (
						mf = Mar_%y%
					) else if m = "04" (
						mf = Apr_%y%
					) else if m = "05 (
						mf = May_%y%
					) else if m = "06" (
						mf = Jun_%y%
					) else if m = "07" (
						mf = Jul_%y%
					) else if m = "08" (
						mf = Aug_%y%
					) else if m = "09" (
						mf = Sep_%y%
					) else if m = "10" (
						mf = Oct_%y%
					) else if m = "11" (
						mf = Nov_%y%
					) else if m = "12" (
						mf = Dec_%y%
					) else (
						echo 月が正しくありません。終了します。
						pause
						goto :EOF
					)
					
					if not exist %Target%\!dir!\Logs\!y!\!mf! (
						mkdir(%Target%\!dir!\Logs\!y!\!mf!)
					)
					
					rem Copy前にFolderがあれば削除する
					dir /b /a %Target%\!dir!\Logs\!y!\!mf! | findstr "." >nul || del /S/Q %Target%\!dir!\LotTrackFiles\!y!\!mf!
					
					set dest = %Target%\!dir!\Logs\!y!\!mf!\
					rem　フォルダ下、ファイルを全てコピー
					xcopy !org! !dest! /D/S/R/Y/I/K/F
					
				) else "!type!" = "LTF"(
					set org = !folder2!\
					set dir =
					for /d %%C in (!org!) do (
						set folder3=%%C
						set ct = !folder3:~0,3!
						if !ct!=!toolNo!						(
							dir = !ct!
							goto :th
						)
					)
					:th
					rem 年月の確認
					set y =
					set m =
					for /d %%T in (!folder2!) do (
						set folder3=%%T
						y = !folder3:~0,4!
						m = !folder3:~4,2!
						goto :th2
					)
					:th2
					
					if not exist %Target%\!dir!\LotTrackFiles\!y! (
						mkdir(%Target%\!dir!\LotTrackFiles\!y!)
					)
					
					set mf =
					if "!m!" = "01" (
						mf = Jan_%y%
					) else if m = "02" (
						mf = Feb_%y%
					) else if m = "03" (
						mf = Mar_%y%
					) else if m = "04" (
						mf = Apr_%y%
					) else if m = "05 (
						mf = May_%y%
					) else if m = "06" (
						mf = Jun_%y%
					) else if m = "07" (
						mf = Jul_%y%
					) else if m = "08" (
						mf = Aug_%y%
					) else if m = "09" (
						mf = Sep_%y%
					) else if m = "10" (
						mf = Oct_%y%
					) else if m = "11" (
						mf = Nov_%y%
					) else if m = "12" (
						mf = Dec_%y%
					) else (
						echo 月が正しくありません。終了します。
						pause
						goto :EOF
					)
					
					if not exist %Target%\!dir!\LotTrackFiles\!y!\!mf! (
						mkdir(%Target%\!dir!\LotTrackFiles\!y!\!mf!)
					)
					
					rem Copy前にFolderがあれば削除する
					dir /b /a %Target%\!dir!\LotTrackFiles\!y!\!mf! | findstr "." >nul || del /S/Q %Target%\!dir!\LotTrackFiles\!y!\!mf!
					
					set dest = %Target%\!dir!\LotTrackFiles\!y!\!mf!
					rem　フォルダ下、ファイルを全てコピー
					xcopy !org! !dest! /D/S/R/Y/I/K/F
					
				) else (
					echo "Folder名が合っていません。終了します"
					pause
					goto :EOF
				)
			)	
		)
	)
)

pause


