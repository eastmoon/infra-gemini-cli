@rem
@rem Copyright 2020 the original author jacky.eastmoon
@rem All commad module need 3 method :
@rem [command]        : Command script
@rem [command]-args   : Command script options setting function
@rem [command]-help   : Command description
@rem Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
@rem But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
@rem NOTE, batch call [command]-args it could call correct one or call [command] and "-args" is parameter.
@rem

@rem ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

@rem Command Prompt use UTF-8 code.
chcp 65001

@rem ------------------- execute script -------------------

set WSL_IMAGE_DIR=C:\temp\wsl_backups
set WSL_IMAGE_NAME=ubuntu2404.tar
set DISTRO_NAME=ai-cli
set DISTRO_DIR=C:\temp\wsl
if NOT EXIST %WSL_IMAGE_DIR%\%WSL_IMAGE_NAME% (
    echo %WSL_IMAGE_DIR%
    echo %WSL_IMAGE_NAME%
    @rem 先建立一個暫存路徑
    if NOT EXIST %WSL_IMAGE_DIR% (mkdir %WSL_IMAGE_DIR%)

    @rem 經由 WSL 自動抓取官方的 24.04
    wsl --install Ubuntu-24.04 --no-launch

    @rem 導出映像檔
    wsl --export Ubuntu-24.04 %WSL_IMAGE_DIR%\%WSL_IMAGE_NAME%

    @rem 移除下載用映像檔
    wsl --unregister Ubuntu-24.04
)

@rem 檢查實體是否存在，若不存在則建立環境
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$found = (wsl -l -q | ForEach-Object { $_.Trim() } | Where-Object { $_ -ieq '%DISTRO_NAME%' }); " ^
    "if ($found) { exit 0 } else { exit 1 }"

if %errorlevel% equ 1 (
    echo [-] Instance "%DISTRO_NAME%" not find, start instance.
    if NOT EXIST %DISTRO_DIR% (mkdir %DISTRO_DIR%)
    wsl --import %DISTRO_NAME% %DISTRO_DIR% %WSL_IMAGE_DIR%\%WSL_IMAGE_NAME%
)

@rem 進入實體
wsl -d %DISTRO_NAME%
goto end

@rem ------------------- End method-------------------

:end
    endlocal
