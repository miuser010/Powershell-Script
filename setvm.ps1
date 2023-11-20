# Connect to your vCenter server
Connect-VIServer -Server czdcm-vcenter.mg.ifortuna.cz -User a_mazkha -Password 

# Specify the path to the file containing VM names
$vmListFile = "C:\Users\mazkha\Downloads\vmlist.txt"

# Read VM names from the file
$vmNames = Get-Content $vmListFile

# Loop through each VM and set CPU shares to high
foreach ($vmName in $vmNames) {
    $vm = Get-VM -Name $vmName

    if ($vm -ne $null) {
        # Set CPU shares to high (High = 2000)
        $vm | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel High

        Write-Host "CPU shares set to high for VM: $vmName"
    } else {
        Write-Host "VM not found: $vmName"
    }
}

# Disconnect from vCenter server
Disconnect-VIServer -Confirm:$false
