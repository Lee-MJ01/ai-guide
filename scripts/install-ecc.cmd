@echo off
setlocal
set "LOG=%~dp0install-ecc.log"
call :main > "%LOG%" 2>&1
type "%LOG%"
echo.
echo Log saved: %LOG%
pause
exit /b

:main
echo === ECC install log %date% %time% ===
echo USERPROFILE=%USERPROFILE%
echo --- where claude / git / node / npm ---
where claude
where git
where node
where npm
echo --- claude --version ---
call claude --version
if errorlevel 1 (
  echo [ERROR] claude CLI not found on PATH.
  goto :showsettings
)
echo --- [1/3] marketplace add ---
call claude plugin marketplace add affaan-m/ECC
echo --- [2/3] plugin install ---
call claude plugin install ecc@ecc --scope user --config hooks_enabled=true --config hook_profile=standard
echo --- [3/3] plugin list ---
call claude plugin list
:showsettings
echo --- settings.json ---
powershell -NoProfile -Command "$f=Join-Path $env:USERPROFILE '.claude\settings.json'; if(Test-Path $f){$j=Get-Content -Raw $f | ConvertFrom-Json; [pscustomobject]@{extraKnownMarketplaces=$j.extraKnownMarketplaces; enabledPlugins=$j.enabledPlugins} | ConvertTo-Json -Depth 6}else{'settings.json not found'}"
echo.
echo --- installed_plugins.json ---
if exist "%USERPROFILE%\.claude\plugins\installed_plugins.json" (type "%USERPROFILE%\.claude\plugins\installed_plugins.json") else (echo installed_plugins.json not found)
echo.
echo === done ===
exit /b
