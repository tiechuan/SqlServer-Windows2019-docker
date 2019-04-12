#Step 1: Start from base image mcr.microsoft.com/windows/servercore
FROM mcr.microsoft.com/windows/servercore:1809

#Step 2: Create temporary directory to hold SQL Server 2016 installation files
RUN powershell -Command (mkdir C:\SQL2016Dev_SP2)

#Step 3: Copy SQL Server 2016 installation files from the host to the container image
COPY \SQL2016Dev_SP2 C:/SQL2016Dev_SP2

#Step 4: Install SQL Server 2016 via command line
RUN C:/SQL2016Dev_SP2/SETUP.exe /Q /ACTION=INSTALL /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /SECURITYMODE=SQL /SAPWD="y0urSecUr3PAssw0rd" /SQLSVCACCOUNT="NT AUTHORITY\System" /AGTSVCACCOUNT="NT AUTHORITY\System" /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" /IACCEPTSQLSERVERLICENSETERMS=1 /TCPENABLED=1 /UPDATEENABLED=False

#Step 5: Set SQL Server service to automatic
RUN powershell -Command (Set-Service MSSQLSERVER -StartupType Automatic)

#Step 6: Remove SQL Server installation media folder
RUN powershell -Command (Remove-Item -Path C:/SQL2016Dev_SP2 -Recurse -Force) 

#Step 7: Switch shell to PowerShell in preparation for running script Start.ps1
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Step 8: Copy Start.ps1 to image on root directory
COPY \start.ps1 /

#Step 9: Set current working directory for script execution
WORKDIR /

#Step 10: Run PowerShell script Start.ps1, passing the -ACCEPT_EULA parameter with a value of Y
CMD .\start.ps1 -ACCEPT_EULA "Y" -Verbose