# AIC Event Collection

## Features

- Collects the last 15 days of Event Viewer events.
- Collects Windows Server information including hostname, FQDN, and IP address.
- Collects Windows Server service packs information.
- Collects system reboot instances with date and time.
- Collects files from a specified folder with the current date.
- Compresses the collected files into a zip file with a name that includes the current date and time.
- Allows specifying the folder path and new folder path as input parameters.
- Ignores errors if files are not available to zip.

## Functionality

The script performs the following tasks:

1. Collects the last 15 days of Event Viewer events and exports them to a CSV file.
2. Collects Windows Server information (hostname, FQDN, IP address, OS details) and exports it to a CSV file.
3. Collects Windows Server service packs information and exports it to a CSV file.
4. Collects system reboot instances and exports them to a CSV file.
5. Collects files from a specified folder with the current date and exports the file details (name, date time, size) to a CSV file.
6. Compresses the collected files into a zip file with a name that includes the current date and time.
7. Creates a new folder with the hostname and moves all generated files into this folder.

## User Guide

### Prerequisites

- PowerShell 5.1 or later
- Administrator privileges to run the script

### Usage

1. Save the script to a file, e.g., `collect-events.ps1`.
2. Open PowerShell as an administrator.
3. Execute the script by running:

   ```powershell
   .\collect-events.ps1 -folderPath "C:\path\to\your\folder" -newFolderPath "C:\path\to\output\$($env:COMPUTERNAME)"

   Parameters
folderPath: The path to the folder from which files with the current date will be collected. Default is dummyfiles.
newFolderPath: The path to the new folder where the collected files and generated CSV files will be stored. Default is C:\troubleshoot\P3\$($env:COMPUTERNAME).
Example
To run the script with custom folder paths:

.\collect-events.ps1 -folderPath "C:\data\input" -newFolderPath "C:\data\output\$($env:COMPUTERNAME)"

This will create a new folder with the hostname in C:\data\output, collect the required data, and compress the files into a zip file with a name that includes the current date and time.

.\collect-events.ps1 -folderPath "C:\data\input" -newFolderPath "C:\data\output\$($env:COMPUTERNAME)"

Error Handling
The script ignores errors if files are not available to zip and continues execution.

License
This project is licensed under the MIT License.

