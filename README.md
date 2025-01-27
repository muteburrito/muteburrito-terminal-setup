# MuteBurrito Setup Script

Welcome to the MuteBurrito Setup Script! This script is designed to automate the setup of a development environment on Windows. It includes the installation and configuration of various tools and applications to streamline your workflow.

## Features

- **Virtualization Check**: Ensures that virtualization is enabled on your system.
- **WSL and Virtual Machine Platform**: Enables Windows Subsystem for Linux and Virtual Machine Platform.
- **WSL 2 Default**: Sets WSL 2 as the default version.
- **winget Installation**: Installs `winget` if it is not already present.
- **PowerShell Update**: Installs the latest version of PowerShell.
- **Windows Terminal Configuration**: Updates Windows Terminal settings with a custom configuration.
- **oh-my-posh and PowerShell Modules**: Installs `oh-my-posh` and additional PowerShell modules like `Terminal-Icons` and `posh-git`.
- **Application Installation**: Installs a list of applications using `winget`.
- **Package Upgrades**: Upgrades all installed packages via `winget`.

## Prerequisites

- **Administrator Privileges**: The script must be run with administrative privileges.
- **Internet Connection**: Required for downloading and installing packages.

## Usage

1. **Download the Script**: Save the `setup.ps1` script to your local machine.
2. **Run the Script**: Open PowerShell as an administrator and execute the script:
   ```powershell
   .\setup.ps1
   ```
3. **Follow the Prompts**: The script is interactive and will prompt you for confirmation before performing major actions.

## Applications Installed

The script installs the following applications using `winget`:

- Visual Studio Code
- Windows Terminal
- Git
- Steam
- Ubisoft Connect
- Epic Games Launcher
- Postman
- Docker Desktop
- Discord
- Google Chrome
- GitHub Desktop
- Python3

## Customization

You can customize the list of applications to be installed by modifying the `$applications` array in the script.

## Troubleshooting

- **Virtualization Not Enabled**: If virtualization is not enabled, you will need to enable it in your BIOS settings.
- **winget Installation Issues**: If `winget` fails to install, you may need to manually install the App Installer package from the Microsoft Store.
- **Permission Errors**: Ensure you are running the script as an administrator.

## License

This script is provided "as-is" without any warranty. Use at your own risk.

---

Enjoy your streamlined setup with the MuteBurrito Setup Script! 