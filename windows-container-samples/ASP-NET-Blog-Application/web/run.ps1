# silence is golden
$ErrorActionPreference = 'SilentlyContinue'

# prevent users from using in-memory database, and then losing their content
Write-Host Deleting initial configuration file
Remove-Item C:\inetpub\wwwroot\blogengine\Web.config

# DNS caching doesn't play well with the dynamic nature of containers
Write-Host Disabling DNS cache
net stop dnscache

# Get stack name from metadata
Write-Host Getting stack name from metadata
$script:stackname=""
while ($script:stackname -eq "") {
  Write-Host Invoking Web Request
  $script:stackname=Invoke-WebRequest -UseBasicParsing -Uri http://rancher-metadata:41/2016-07-29/self/stack/name
  Start-Sleep -Seconds 10
}

Write-Host Writing configuration file

# Set the DB cxn string
Get-Content C:\inetpub\wwwroot\blogengine\Web.config.tmpl | %{$_ -replace "BLOG_DB_SERVER","db.$script:stackname.rancher.internal"} | %{$_ -replace "BLOG_DB_PASSWORD","$env:sa_password"} | Out-File -FilePath C:\inetpub\wwwroot\blogengine\Web.config -Encoding utf8

Write-Host Begin monitoring 'w3svc' service

& 'C:\ServiceMonitor.exe' w3svc
