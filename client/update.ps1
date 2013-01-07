$OutputEncoding = [Console]::OutputEncoding
$name = ""
$version = "0.0.0.0"
$incrementBuild = $TRUE

if(Test-Path "VERSION") {
	write-host "Reading Version info..."
	$lines = (Get-Content ".\VERSION")[0..1]
	$name = $lines[0]
	$version = $lines[1]	
}

$versionParts = $version.split(".")
[int]$major = $versionParts[0]
[int]$minor = $versionParts[1]
[int]$revision = $versionParts[2]
[int]$build = $versionParts[3]

if( $incrementBuild ) {
	$build = $build + 1
}

$query = read-host "Software Name? [$name]?"
if( $query -ne "" ) {
	$name = $query
	write-host "Name: $name"
}
$query = read-host "Major Version? [$major]?"
if( $query -ne "" ) {
	$major = $query
}
$query = read-host "Minor Version? [$minor]?"
if( $query -ne "" ) {
	$minor = $query
}
$query = read-host "Revision Number? [$revision]?"
if( $query -ne "" ) {
	$revision = $query
}
$query = read-host "Build Number? [$build]?"
if( $query -ne "" ) {
	$build = $query
}

$version = "$major.$minor.$revision.$build"
write-host "Version: $version"

write-host "Writing VERSION..."
$versionFileOutput = @($name, $version)
$versionFileOutput | out-file -encoding "ASCII" ".\VERSION"
write-host "Okay"

write-host "Building Index..."
$workingDirectory = (Get-Location)
$files = [System.IO.Directory]::GetFiles($workingDirectory, "*.lua", [System.IO.SearchOption]::AllDirectories)
[Array]$relativeFiles = @()
Foreach ($file in $files) {
	$relativeFiles += $file.Replace($workingDirectory, "")
}
write-host "Writing Index..."
$relativeFiles | out-file ".\FILES"
write-host "Update of $name complete!"

