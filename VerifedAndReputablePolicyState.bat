REM 添加以下注册表项可以关闭 "VerifedAndReputablePolicyState"：
REM HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\VerifiedAndReputableFileDownload

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "VerifiedAndReputableFileDownload" /t REG_DWORD /d 0 /f
