# Connect to your vCenter server
Connect-VIServer -Server czdcm-vcenter.mg.ifortuna.cz -User a_mazkha -Password 

foreach($line in Get-Content .\vmlist.txt) {
    # check
    Get-VMResourceConfiguration -VM $line | Format-Custom -Property CpuSharesLevel
    # change
    Get-VM -Name $line | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel High
    # verify
    Get-VMResourceConfiguration -VM $line | Format-Custom -Property CpuSharesLevel
} 