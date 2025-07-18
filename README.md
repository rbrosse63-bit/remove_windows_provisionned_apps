# Remove Provisioned Apps - PowerShell GUI

This PowerShell script provides a graphical interface to easily list and remove provisioned Windows Store apps from your system.

## Features

- **Graphical User Interface** (Windows Forms)
- **Lists all provisioned apps** with display name and package name
- **Multi-selection with checkboxes**
- **Remove selected apps** with confirmation dialog
- **Refresh button** to reload the app list
- **Admin check**: prompts the user to run as administrator if needed
- **Responsive window size**: adapts to screen resolution and centers the window

## Usage

1. **Run as administrator**  
   The script requires admin rights to remove provisioned apps.  
   If not run as admin, a message box will prompt you.

2. **Select apps**  
   Check the apps you want to remove.

3. **Remove selected**  
   Click the "Remove Selected" button and confirm.

4. **Refresh**  
   Click "Refresh" to reload the app list.

## How to run

- Open PowerShell as administrator.
- Execute the script:
  ```
  powershell -ExecutionPolicy Bypass -File .\UI_Supprimer-apps-provisionnees.ps1
  ```

## Convert to EXE

You can convert this script to a standalone `.exe` using [PS2EXE](https://github.com/MScholtes/PS2EXE).

## Disclaimer

Use at your own risk. Removing provisioned apps affects all new users on the system.
