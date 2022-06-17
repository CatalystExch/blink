$i=1
# Where are we putting the screenshots?
$storepath = Read-Host "Please enter the full path of directory to screenshot stash, ie X:\di\rec\tory"
Write-Output "`n"
# Does the directory exist? Do we want it to? Fat-finger-flounce?
If(!(Test-Path -PathType container $storepath)){
	$oops = Read-Host "Folder does not exist. Shall I create it? y/n/q"
	Write-Output "`n"
	If($oops -match "y"){
		New-Item -ItemType Directory -Path $storepath
	} elseif($oops -match "n"){
		$storepath = Read-Host "Let's try again. Please enter the full path of directory to screenshot stash, ie X:\di\rec\tory\"
		Write-Output "`n"
		If(!(Test-Path -PathType container $storepath)){
			Write-Output "Please check your directory and try your call again.`nI'll exit so we can start over."
			Write-Output "`n"
			Exit
		}
	} elseif($oops -match "q"){
		Write-Output "Okay. Exit, stage left.`n"
		Exit
	}
}		
# Add toggle for verbose/silent when snaps are saved
# Set interval between snaps
$wait = Read-Host "How long, in seconds, between each screenshot? 2min = 120, 5min = 300, 10min = 600, etc"
Write-Output "Thanks! Starting now."
# Note: figure out how to input runtime and adjust
While ($i -le 1) 
{
	Start-Sleep -s $wait
	$i
	$i++
$File = "$storepath\$(get-date -f 'yyyyMMddHHmm').png"
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
# Gather Screen resolution information
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$Left = $Screen.Left
$Top = $Screen.Top
# Create bitmap using the top-left and bottom-right bounds
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
# Create Graphics object
$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
# Capture screen
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
# Save to file
$bitmap.Save($File, [System.Drawing.Imaging.ImageFormat]::Png) 
Write-Output "Screenshot saved to:"
Write-Output $File
}