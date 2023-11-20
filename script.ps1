# Run the dir command to list directories up to a depth of 2 and save the output to a text file
cmd /c dir C:\inetpub /ad /b /s > C:\Windows\Temp\directories.txt
cmd /c dir D:\ /ad /b /s >> C:\Windows\Temp\directories.txt

# Read the directories from the file
$directories = Get-Content -Path "C:\Windows\Temp\directories.txt"

# Initialize an array to store directories with a 'web.config' file
$directoriesWithWebConfig = @()

# Loop through each directory path
foreach ($directory in $directories) {
    $webConfigPath = Join-Path -Path $directory -ChildPath "web.config"
    if (Test-Path -Path $webConfigPath -PathType Leaf) {
        $directoriesWithWebConfig += $directory
    }
}

# Check if there are directories with a 'web.config' file
if ($directoriesWithWebConfig.Count -gt 0) {
    # Convert the directories with 'web.config' to base64
    $base64Content = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($directoriesWithWebConfig -join "`r`n"))

    # Save the base64 content to another file
    $base64FilePath = "C:\Windows\Temp\directories-with-web-config-base64.txt"
    $base64Content | Out-File -FilePath $base64FilePath
}
else {
    Write-Host "No directories with 'web.config' files found."
}
