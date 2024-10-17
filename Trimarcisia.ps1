##################################################################
# Trimarcisia.sh v1.0.0                                          #
#                                                                #
#              Written by Darryl G. Baker                        #
##################################################################

# Print ASCII Art
Write-Output " _____   _   _                                          "
Write-Output "|___ /  | | | | ___  _ __ ___  ___ _ __ ___   ___ _ __  "
Write-Output "  |_ \  | |_| |/ _ \| '__/ __|/ _ \ '_ \` _ \ / _ \ '_ \ "
Write-Output " ___) | |  _  | (_) | |  \__ \  __/ | | | | |  __/ | | |"
Write-Output "|____/  |_| |_|\___/|_|  |___/\___|_| |_| |_|\___|_| |_|"

# List of repositories
$repos = @(
    "ADAuditingGroup",
    "PowerPUG",
    "Locksmith",
    "BlueTuxedo",
    "Find-and-Fix",
    "papers",
    "New-KrbtgtKeys.ps1",
    "SPN-Descriptions",
    "Create-Vulnerable-ADDS",
    "Invoke-TrimarcADChecks",
    "TailscaleLogAnalyticIngestor",
    "play.backdoorsandbreaches.com"
)

# Function to download and unzip the repository
function Download-Repo {
    param (
        [string]$repoName
    )

    if (-not (Test-Path -Path $repoName)) {
        Write-Output "Downloading $repoName..."
        Invoke-WebRequest -Uri "https://github.com/Trimarc/$repoName/archive/refs/heads/main.zip" -OutFile "$repoName.zip"
        Write-Output "Unzipping $repoName..."
        Expand-Archive -Path "$repoName.zip" -DestinationPath $repoName
        Remove-Item "$repoName.zip"
        Start-Process -FilePath $repoName
    }
    else {
        Write-Output "$repoName already downloaded."
        Start-Process -FilePath $repoName
    }
    Set-Location -Path "$repoName\*" -ErrorAction SilentlyContinue
}

# Display list of repositories
Write-Output "Please select a repository to download/open:"
Write-Output "0. Download all repositories"
for ($i = 0; $i -lt $repos.Count; $i++) {
    Write-Output "$(($i + 1)). $($repos[$i])"
}

# Read user input
$selection = Read-Host "Enter the number of the repository you want to download/open"

# Validate user input
if ($selection -eq 0) {
    foreach ($repoName in $repos) {
        Download-Repo -repoName $repoName
    }
    Write-Output "All repositories have been downloaded."
}
elseif ($selection -ge 1 -and $selection -le $repos.Count) {
    $repoName = $repos[$selection - 1]
    Download-Repo -repoName $repoName
}
else {
    Write-Output "Invalid selection. Exiting."
    exit 1
}
