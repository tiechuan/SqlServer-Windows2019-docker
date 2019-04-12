<h1>Move docker images location on Windows Server 2019</h1>

By default, Docker stores Images and other configuration files In the location below:
C:\ProgramData\Docker

Add 'C:\ProgramData\Docker\config\daemon.json'

{
"data-root": "e:\\dockerdata"
}

Then
Restart-Service Docker
