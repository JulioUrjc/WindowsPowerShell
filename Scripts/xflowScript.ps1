
param(
		[int]$threads = 6
	)

$versions = @("buildgcc9","master")
# $cases = @("case0","case1","case2","case3")
$cases = @("case0","case1","case2","case3","nosurf0","nosurf1","nosurf2","surf0","surf1","surf2","surf3","surf4")

foreach ($job in $cases)
{
	echo $job >> timing_win.txt
	#E:\xfconandeploygit\generateDomain3d.bat "$($job).xfz" | Out-Null

	foreach($i in 1..5)
	{
		E:\xfconandeploygit\engine-3d-mfs.bat "$($job).xfz" -maxcpu=$threads | Out-Null
		Write-Host $job
		bash ./average_timestep $job"/"$job".log" >> timing_win.txt
	}
}

