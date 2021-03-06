Param(
    [int] $durationSecs,
	[string]$pageOption,
	[string]$TestParameters,
	[string]$LogfileSuffix
	)
		
$urlHome = "http://localhost/mvc4_web/Home"
$urlAbout = "http://localhost/mvc4_web/Home/About"
$urlContact = "http://localhost/mvc4_web/Home/Contact"
$urlSelected = ""

$logFile = "c:\debug\" + $TestParameters + "_" + $LogfileSuffix + ".txt"


switch($pageOption)
{
	1 { $urlSelected = $urlHome }
	2 { $urlSelected = $urlAbout }
	3 { $urlSelected = $urlContact }
	default { $urlSelected = $urlHome }
}

$durationStart = Get-Date
$testEndTime = Get-Date
while ( ($testEndTime - $durationStart).TotalSeconds -lt $durationSecs )
{
	try
	{
		[net.httpWebRequest]
		$req = [net.webRequest]::create($urlSelected)
		$req.method = "GET"
		$req.ContentType = "application/x-www-form-urlencoded"
		$req.TimeOut = 60000

		$start = get-date
		[net.httpWebResponse] $res = $req.getResponse()
		$timetaken = ((get-date) - $start).TotalMilliseconds

		Write-Output $res.Content
		Write-Output ("{0} {1} {2}" -f (get-date), $res.StatusCode.value__, $timetaken)
	 	$timetaken >> $logFile
		
		$req = $null
		$res.Close()
		$res = $null
		$testEndTime = Get-Date
	} 
	catch [Exception] 
	{
		Write-Output ("{0} {1}" -f (get-date), $_.ToString())
	}
	
	$req = $null

	# uncomment the line below and change the wait time to add a pause between requests
	Start-Sleep -Seconds 1
}





