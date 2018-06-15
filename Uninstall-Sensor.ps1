# CarbonBlack Sensor List Example
# Author: Casey Smith, Twitter: @subTee
# License: BSD 3-Clause
# Last Modified by: Casey Smith
# Last Modified Date: October 21, 2015

#Comment this to enable certificate validation
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
######################################################################
#list from an array
#$sensorids = @("16942","37006","35754")
######################################################################

######################################################################
#Read from a text file of sensors
######################################################################
$sensorids = gc C:\temp\hosts.txt

foreach ($sensorid in $sensorids) {
$authToken = 'YOUR_API_TOKEN' # Auth Token
$url = "https://YOUR_URL/api/v1/sensor/$sensorid"


#Traditional WebClient Call
$wc = New-Object System.Net.WebClient
$wc.Headers.Add("x-auth-token",$authToken)
$wc.DownloadString($url)

#PowerShell v3+ Invoke-RestMethod Examples
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.add("x-auth-token",$authToken)
try
{
    $cbSensors = Invoke-RestMethod -Uri $url -Headers $headers -Method get
    $cbsensors
    $cbSensors | foreach {
    $_.uninstall = $true
    $urlpost = "https://YOUR_URL/api/v1/sensor/$sensorid"
    $jsbody = ConvertTo-Json $_
    Invoke-RestMethod -Uri $urlpost -Headers $headers -method Put -body $jsbody -ContentType "application/json"
 }
}
catch [System.Exception]
{
  Write-Host $_.Exception.Message,  $_.Exception.Status
}
}