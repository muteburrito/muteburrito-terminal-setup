# ASCII Logo
$logo = @"
#####################################################################

MUTEBURRITO'S TERMINAL SETUP SCRIPT

#####################################################################                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
"@
Write-Output $logo
Write-Output "Welcome to the MuteBurrito Setup Script!"

# List of actions
$actions = @"
This script will perform the following actions:
1. Check and enable virtualization.
2. Enable WSL and Virtual Machine Platform.
3. Set WSL 2 as the default version.
4. Install winget if not present.
5. Install the latest PowerShell.
6. Update Windows Terminal settings.
7. Install oh-my-posh and additional PowerShell modules.
8. Install a list of applications using winget.
9. Upgrade all winget packages.
"@
Write-Output $actions

# Ask for confirmation to proceed
$proceed = Read-Host "Do you want to proceed with the setup? (y/n)"
if ($proceed -ne 'y') {
    Write-Output "Setup aborted by user."
    exit
}

# Ensure script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You need to run this script as an Administrator."
    exit
}

# Function to test if virtualization is enabled
function Test-Virtualization {
    $svm = Get-WmiObject Win32_ComputerSystem | Select-Object HypervisorPresent

    if ($svm.HypervisorPresent) {
        Write-Output "Virtualization is enabled."
        return $true
    } else {
        Write-Warning "Virtualization is not enabled. Please enable it in your BIOS settings and rerun the script."
        return $false
    }
}

# Check if virtualization is enabled
if (-not (Test-Virtualization)) {
    exit
}

# Enable WSL and Virtual Machine Platform
Write-Output "Enabling WSL and Virtual Machine Platform features..."
try {
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-Output "WSL and Virtual Machine Platform enabled successfully."
} catch {
    Write-Error "Failed to enable WSL or Virtual Machine Platform. Error: $_"
    exit
}

# Set WSL 2 as the default version
Write-Output "Setting WSL 2 as the default version..."
try {
    wsl --set-default-version 2
    Write-Output "WSL 2 set as the default version successfully."
} catch {
    Write-Error "Failed to set WSL 2 as the default version. Error: $_"
    exit
}

# Verify winget is installed before using it
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    $installWinget = Read-Host "winget is not installed. Do you want to install it? (y/n)"
    if ($installWinget -eq 'y') {
        Write-Output "Attempting to install winget..."
        try {
            # Download the App Installer package
            $installerUrl = "https://aka.ms/getwinget"
            $installerPath = "$env:TEMP\AppInstaller.msixbundle"
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

            # Install the App Installer package
            Add-AppxPackage -Path $installerPath
            Write-Output "winget installed successfully."
        } catch {
            Write-Error "Failed to install winget. Please install it manually. Error: $_"
            exit
        }
    } else {
        Write-Error "winget is required to proceed. Exiting script."
        exit
    }
}

# Install the latest PowerShell
Write-Output "Installing the latest PowerShell..."
try {
    winget install --id Microsoft.Powershell --exact --source winget --silent --accept-source-agreements --accept-package-agreements
    Write-Output "Latest PowerShell installed successfully."
} catch {
    Write-Error "Failed to install the latest PowerShell. Error: $_"
}

# Install oh-my-posh using winget
Write-Output "Installing oh-my-posh using winget..."
try {
    winget install --id JanDeDobbeleer.OhMyPosh --exact --source winget --silent --accept-source-agreements --accept-package-agreements
    Write-Output "oh-my-posh installed successfully via winget."
} catch {
    Write-Error "Failed to install oh-my-posh via winget. Error: $_"
    exit
}

# Reload the profile
. $PROFILE

# Install Nerd Fonts FiraCode
Write-Output "Installing FiraCode Nerd Font using oh-my-posh..."
try {
    oh-my-posh font install FiraCode Nerd Font
    Write-Output "FiraCode Nerd Font installed successfully."
} catch {
    Write-Error "Failed to install FiraCode Nerd Font. Error: $_"
    exit
}

# Install additional PowerShell modules
Write-Output "Installing additional PowerShell modules..."
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Write-Output "Additional PowerShell modules installed successfully."

# Import the modules to verify installation
Write-Output "Importing PowerShell modules..."
Import-Module Terminal-Icons -ErrorAction Stop
Import-Module posh-git -ErrorAction Stop
Write-Output "PowerShell modules imported successfully."

# Define applications to install
$applications = @(
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "Git.Git",
    "Valve.Steam",
    "Ubisoft.Connect",
    "EpicGames.EpicGamesLauncher",
    "Postman.Postman",
    "Docker.DockerDesktop",
    "Discord.Discord",
    "Google.Chrome",
    "GitHub.GitHubDesktop",
    "Python.Python.3.12"
)

# Install applications non-interactively
foreach ($app in $applications) {
    Write-Output "Installing $app..."
    try {
        winget install --id $app -e --source winget --silent --accept-source-agreements --accept-package-agreements
        Write-Output "$app installed successfully."
    } catch {
        Write-Error "Failed to install $app. Error: $_"
    }
}

# Upgrade all winget packages
Write-Output "Upgrading all winget packages..."
try {
    winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
    Write-Output "All packages upgraded successfully."
} catch {
    Write-Error "Failed to upgrade some packages. Error: $_"
}

# Update Windows Terminal settings
Write-Output "Updating Windows Terminal settings..."

$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Backup existing settings.json
if (Test-Path $settingsPath) {
    Copy-Item $settingsPath "$settingsPath.bak" -Force
    Write-Output "Existing settings.json backed up to settings.json.bak"
}

# Define the new settings.json content
$settingsJson = @"
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": 
    [
        {
            "command": 
            {
                "action": "copy",
                "singleLine": false
            },
            "id": "User.copy.644BA8F2",
            "keys": "ctrl+c"
        },
        {
            "command": "paste",
            "id": "User.paste",
            "keys": "ctrl+v"
        },
        {
            "command": 
            {
                "action": "splitPane",
                "split": "auto",
                "splitMode": "duplicate"
            },
            "id": "User.splitPane.A6751878",
            "keys": "alt+shift+d"
        },
        {
            "command": "find",
            "id": "User.find",
            "keys": "ctrl+shift+f"
        }
    ],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "newTabMenu": 
    [
        {
            "type": "remainingProfiles"
        }
    ],
    "profiles": 
    {
        "defaults": 
        {
            "colorScheme": "Dracula",
            "elevate": true,
            "font": 
            {
                "face": "FiraCode Nerd Font"
            },
            "opacity": 90
        },
        "list": 
        [
            {
                "commandline": "%SystemRoot%\\System32\\cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Command Prompt"
            },
            {
                "commandline": "\"C:\\Program Files\\PowerShell\\7\\pwsh.exe\"",
                "elevate": false,
                "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                "hidden": false,
                "name": "PowerShell",
                "source": "Windows.Terminal.PowershellCore"
            }
        ]
    },
    "schemes": 
    [
        {
            "name": "Dracula",
            "background": "#282A36",
            "black": "#21222C",
            "blue": "#BD93F9",
            "brightBlack": "#6272A4",
            "brightBlue": "#D6ACFF",
            "brightCyan": "#A4FFFF",
            "brightGreen": "#69FF94",
            "brightPurple": "#FF92DF",
            "brightRed": "#FF6E6E",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFFA5",
            "cursorColor": "#F8F8F2",
            "cyan": "#8BE9FD",
            "foreground": "#F8F8F2",
            "green": "#50FA7B",
            "purple": "#FF79C6",
            "red": "#FF5555",
            "selectionBackground": "#44475A",
            "white": "#F8F8F2",
            "yellow": "#F1FA8C"
        }
    ],
    "themes": [],
    "useAcrylicInTabRow": true
}
"@

# Write the new settings.json
Set-Content -Path $settingsPath -Value $settingsJson -Encoding UTF8
Write-Output "Windows Terminal settings updated successfully."

# Restart terminal to apply changes
Write-Output "Restarting terminal to apply changes..."
Start-Process "powershell.exe" -ArgumentList "-NoExit", "-Command", "exit"
exit

# Final message
Write-Output "Setup completed successfully!"