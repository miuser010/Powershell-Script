function SyncFolders {
    param (
        [string]$sourceFolder,
        [string]$replicaFolder,
        [string]$logFilePath
    )

    function LogMessage {
        param (
            [string]$message
        )
        Write-Output $message
        Add-content -Path $logFilePath -Value $message
    }

      function InnerSyncFolders {
        param (
            [string]$source,
            [string]$replica
        )
        $sourceItems = Get-ChildItem $source -Recurse

        foreach ($item in $sourceItems) {
            $replicaItemPath = $item.FullName.Replace($source, $replica)
            
            if ($item.PSIsContainer -eq $false) {
                Copy-Item $item.FullName -Destination $replicaItemPath -Force
                LogMessage ("Copied file: $($item.FullName) to $($replicaItemPath)")
            }
            else {
                if (-not (Test-Path $replicaItemPath)) {
                    New-Item -ItemType Directory -Path $replicaItemPath | Out-Null
                    LogMessage ("Created folder: $($replicaItemPath)")
                }
            }
        }

        $replicaItems = Get-ChildItem $replica -Recurse
        foreach ($replicaItem in $replicaItems) {
            $sourceItemPath = $replicaItem.FullName.Replace($replica, $source)
            if (-not (Test-Path $sourceItemPath)) {
                Remove-Item $replicaItem.FullName -Force
                LogMessage ("Removed: $($replicaItem.FullName)")
            }
        }
    }

    if (-not (Test-Path $sourceFolder)) {
        Write-Output "Source folder does not exist."
        exit
    }

    if (-not (Test-Path $replicaFolder)) {
        Write-Output "Replica folder does not exist."
        exit
    }

    if (-not (Test-Path $logFilePath)) {
        New-Item -ItemType File -Path $logFilePath | Out-Null
    }

    InnerSyncFolders -source $sourceFolder -replica $replicaFolder
}

SyncFolders -sourceFolder "C:\Temp\Source" -replicaFolder "C:\Temp\Replica" -logFilePath "C:\Temp\Log\File.log"
