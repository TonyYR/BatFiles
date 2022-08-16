@Echo off
setlocal enabledelayedexpansion

rem this script check the number of uploaded files on the server and remove old files if that is greater than a certain number.

set tgt=XXXX
set cfg=ConfigFiles

for /f "delims=" %%F in (Tool_List.txt) do (
    echo %%F
    set tgtf=%tgt%\%%F\%cfg%\
    echo !tgtf!
    if exist !tgtf! (
        echo exist target !tgtf!
        call :DeleteFilesGreater3 "!tgtf!"

    ) else (
        echo not exist
    )
)

: DeleteFilesGreater3
set /a cnt=0
echo %1
pushd %1
for %%A in (*) do (
    set name=%%A
    echo !name! >> temp.txt

    FindStr /r Config_20[0-9][0-9][0-1][0-9][0-3][0-9].zip temp.txt

    if "!ERRORLEVEL!"=="0" (
        echo !name! >> temp1.txt
        set /a cnt= cnt + 1
    )
    del temp.txt
)

if %cnt% gtr 3 (
    sort /+8 temp1.txt /o temp1.txt
    set cnt2=0
    for /f %%s in (temp1.txt) do (
        del /q %%s
        echo del %%s
        set /a cnt2= !cnt2! + 1
        set /a diff= %cnt% - 3
    ) & if !cnt2! equ !diff! ( goto :break )
    :break
    echo complete deleting
) else ( echo less than 3 )

if exist temp1.txt (
    del temp1.txt
)
exit /b