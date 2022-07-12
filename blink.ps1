# Where are we putting the screenshots?

$storepath = Read-Host "`nPlease enter the full path of directory to screenshot stash, ie X:\di\rec\tory"
Write-Output "`n"

# Does the directory exist? Do we want it to? Fat-finger-flounce?
If(!(Test-Path -PathType container $storepath)){
	$oops = Read-Host "Folder does not exist. Shall I create it? y/n/q"
	Write-Output "`n"
	If($oops -match "y"){
		New-Item -ItemType Directory -Path $storepath
	} elseif($oops -match "n"){
		$storepath = Read-Host "`nLet's try again. Please enter the full path of directory to screenshot stash, ie X:\di\rec\tory\"
		Write-Output "`n"
		If(!(Test-Path -PathType container $storepath)){
			Write-Output "`nPlease check your directory and try your call again.`rI'll exit so we can start over."
			Write-Output "`n"
			Exit
		}
	} elseif($oops -match "q"){
		Write-Output "`nOkay. Exit, stage left.`n"
		Exit
	}
}		

# Set interval between snaps
[int]$wait = Read-Host "`nHow long, in seconds, between each screenshot? 2min = 120, 5min = 300, 10min = 600, etc`n"


# Input runtime and adjust

$units = Read-Host "`nDo you want to run this for minutes (m) or hours (h)?  "
if ($units -match "m"){
    $chronos = "minutes"
} elseif ($units -match "h"){
    $chronos = "hours"
    }
$length = Read-Host -Prompt "`nHow many $chronos do you want this to run? (Whole number, please)  "
$length_int = [int]::Parse($length)


$confirm = Read-Host "`nConfirming: you want this to run for $length $chronos ? y/n  "
If($confirm -match "n"){
	$units = Read-Host "`nDo you want to run this for minutes (m) or hours (h)?  "
    if ($units -match "m"){
    $chronos = "minutes"
} elseif ($units -match "h"){
    $chronos = "hours"
    }

	$length = Read-Host "`nHow many $chronos do you want this to run?  "
	$check = Read-Host "`nConfirming: you want this to run for $length $chronos ? y/n  "
	If($check -match "n"){
		Write-Output "`nPlease check your numbers and try your call again. `rI'll exit so we can start over.`n"
		Exit
	}
	elseif ($check -match "y"){
		Write-Output "`nThanks! Starting now.`n"
	}
}

# Parsing end time

if ($units -match "h"){
	$seconds = ($length_int*3600)
} else {
	($seconds = $length_int*60)
}


# Show, road, getting on the

$i = 1
Write-Output "The first screenshot will be captured in $wait seconds."
Write-Output "Screenshots will be saved to:"
Write-Output $storepath
Write-Output "You may wish to minimize this window."

While ($i -le ($seconds/$wait)) {
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

Start-Sleep -s $wait
	++$i
}
Exit
