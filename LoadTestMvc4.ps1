Param(
    [int] $durationSecs,
	[string]$TestParameters,
	[string]$LogfileSuffix
	)
		
$urlHome = "http://localhost/DotNet-Functional-4_0-MVC4/Home"
$urlQuery = "http://localhost/DotNet-Functional-4_0-MVC4/Home/MSSQLQuery"

####
# Key to Test Parameters
#
#   AE = Agent Enabled
#	AD = Agent Disabled
#	CP = Classic Pipeline
#	IP = Integrated Pipeline
#	32 = 32-bit app pool
#	64 = 64-bit app pool
#	DN2 = .NET 2.0 app pool
#	DN4 = .NET 4.0 app pool
#	TT = Transaction Traces On
#	EP = Explain Plans On
#	HOME = Hitting quick Home page of app
#	MSSQL = Hitting MSSQLQUERY page of app
#	ITER = Number of SQL iterations in MSSQLQUERY hit of test app
#
#	Example:  $TestParameters = "AD_CP_64_DN4_MSSQL_5000"
#
####

#TODO: CHECK FOR NO OR INVALID PARAMETERS

$logFile = "c:\debug\SQLPerformance\" + $TestParameters + "_" + $LogfileSuffix + ".txt"

$durationStart = Get-Date
$testEndTime = Get-Date
while ( ($testEndTime - $durationStart).TotalSeconds -lt $durationSecs )
{
	try
	{
		[net.httpWebRequest]
		$req = [net.webRequest]::create($urlQuery)
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





