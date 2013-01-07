$OutputEncoding = [Console]::OutputEncoding
write-host "Starting Global Update"
$softwarePackages = [System.IO.Directory]::GetDirectories((Get-Location))
$validPackages = @()
ForEach ($package in $softwarePackages) {
	if(Test-Path "$package\VERSION") {
		$validPackages += $package.Replace((Get-Location), "")
	}
}
$count = $validPackages.Length
write-host "$count packages found... running updates"
$validPackages | out-file -encoding "ASCII" "PACKAGES"

ForEach($package in $validPackages) {
	$workingDirectory = (Get-Location).Path + $package
	$packageName = (Get-Content "$workingDirectory\VERSION")[0]
	write-host "Checking $packageName in $workingDirectory for changes..."
	$files = [System.IO.Directory]::GetFiles($workingDirectory, "*.lua", [System.IO.SearchOption]::AllDirectories)
	[Array]$relativeFiles = @()
	Foreach ($file in $files) {
		$relativeFiles += $file.Replace($workingDirectory, "")
	}	
	[Array]$compare = (Get-Content "$workingDirectory\FILES")
	if($compare -eq $null){
		$compare = @()
	}
	Push-Location
	Set-Location $workingDirectory
	if($args.Length -gt 0 -and $args[0] -eq "all"){
		. "./update"
	}else{
		if($compare.Length -ne $relativeFiles.Length){
			write-host "File count different, updating $packageName"
			. "./update"
		}else{
			for($i = 0; $i -lt $compare.Length; $i++) {
				if($compare[$i] -ne $relativeFiles[$i]){
					write-host "Files have changed, updating $packagename"
					. "./update"
					break
				}
			}
		}
	}
	Pop-Location
}
write-host "Package update complete!"
