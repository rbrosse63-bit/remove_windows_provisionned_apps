


# Uncomment the following lines if you want to ensure the script is run as administrator in power shell
#Comment this bloc if you want to compile in exe
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    exit
}

# Uncomment this bloc if you want to compile in exe.
#Add-Type -AssemblyName System.Windows.Forms
#if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#    [System.Windows.Forms.MessageBox]::Show("Please run this script as administrator.", "Administrator Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
#    exit
#}


#
function Load-Apps {
    $listView.Items.Clear()
    $apps = Get-AppxProvisionedPackage -Online
    foreach ($app in $apps) {
        $item = New-Object System.Windows.Forms.ListViewItem($app.DisplayName)
        $item.SubItems.Add($app.PackageName)
        $item.Tag = $app
        $item.Checked = $false
        $listView.Items.Add($item)
    }
}
#700 is defaut
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$screenWidth = $screen.WorkingArea.Width
$screenHeight = $screen.WorkingArea.Height

$form = New-Object System.Windows.Forms.Form
$form.Text = "Remove Provisioned Apps"
$form.Width = $screenWidth / 3
$form.Height = $screenHeight / 2
$form.MinimumSize = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$width = $form.Width
#$form.FormBorderStyle = 'FixedDialog'
#$form.MaximizeBox = $false

$listView = New-Object System.Windows.Forms.ListView
$listView.View = 'Details'
$listView.CheckBoxes = $true
$listView.FullRowSelect = $true
$listView.Width = $width / 1.05
$listView.Height = $form.ClientSize.Height - 53
$listView.Top = 0
$listView.Left = 10
$listView.Anchor = "Top,Left,Right,Bottom"
$listView.Columns.Add("Nom de l'app", 300)
$listView.Columns.Add("PackageName", 320)

$removeButton = New-Object System.Windows.Forms.Button
$removeButton.Text = "Remove Selected"
$removeButton.Width = $listView.Width / 4
$removeButton.Height = 30
$removeButton.Top = $form.ClientSize.Height - 40
$removeButton.Left = 10
$removeButton.Anchor = "Bottom,Left"

$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh"
$refreshButton.Width = $listView.Width / 4
$refreshButton.Height = 30
$refreshButton.Top = $form.ClientSize.Height - 40
$refreshButton.Left = 170
$refreshButton.Anchor = "Bottom,Left"

$removeButton.Add_Click({
    $selected = $listView.Items | Where-Object { $_.Checked }
    if ($selected.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Aucune app sélectionnée.")
        return
    }
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Are you sure you want to remove the selected apps?",
        "Confirmation",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    if ($result -ne [System.Windows.Forms.DialogResult]::Yes) {
        return
    }
    foreach ($item in $selected) {
        $app = $item.Tag
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $app.PackageName -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show("Suppression réussie : $($app.DisplayName)")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Échec suppression : $($app.DisplayName)`n$_")
        }
    }
    Load-Apps
})

$refreshButton.Add_Click({
    Load-Apps
})

$form.Controls.Add($listView)
$form.Controls.Add($removeButton)
$form.Controls.Add($refreshButton)

Load-Apps

$form.ShowDialog()
