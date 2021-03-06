Param(
    [int] $durationSecs,
	[string]$pageOption,
	[string]$LogfileSuffix
	)
		
$urlHome = "http://localhost/DotNet-Functional-4_0-MVC4/Home"
$urlSQLServerQuery = "http://localhost/DotNet-Functional-4_0-MVC4/Home/MSSQLQuery"
$urlCustomInstrum = "http://localhost/DotNet-Functional-4_0-MVC4/Home/CustomInstrumentation"
$urlMysql = "http://localhost/DotNet-Functional-4_0-MVC4/Home/MySQLQuery"
$urlSelected = ""

#TODO: CHECK FOR NO OR INVALID PARAMETERS

$logFile = "c:\debug\DotnetFunctional" + $PageOption + "_" + $LogfileSuffix + ".txt"

switch($pageOption)
{
	1 { $urlSelected = $urlSQLServerQuery }
	2 { $urlSelected = $urlCustomInstrum }
	3 { $urlSelected = $urlMysql }
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





