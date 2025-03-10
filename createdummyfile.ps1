param (
    [string]$folderPath = "C:\troubleshoot\P3\dummyfiles",
    [int]$numberOfFiles = 500,
    [string]$fileSuffix = ".log"
)

# Function to generate a random name
function Get-RandomName {
    $length = 8
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $random = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count $length | ForEach-Object { [char]$_ })
    return $random
}

# Create the folder if it doesn't exist
if (-Not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force
}

# Loop to create the specified number of text files with dummy data
for ($i = 1; $i -le $numberOfFiles; $i++) {
    $randomName = Get-RandomName
    $filePath = Join-Path -Path $folderPath -ChildPath "$randomName$i$fileSuffix"
    $dummyData = "This is dummy data for file number $i."
    Set-Content -Path $filePath -Value $dummyData
}

Write-Host "$numberOfFiles dummy text files have been created in $folderPath"