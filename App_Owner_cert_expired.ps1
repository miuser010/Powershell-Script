$Apps = Get-AzureADApplication -All $true
$today = Get-Date
$credentials = @()

$Apps | ForEach-Object {
    $aadAppObjId = $_.ObjectId
    $app = Get-AzureADApplication -ObjectId $aadAppObjId
    $owner = Get-AzureADApplicationOwner -ObjectId $aadAppObjId

    $app.KeyCredentials | ForEach-Object {
        $credentials += [PSCustomObject] @{
            CredentialType = "KeyCredentials"
            DisplayName = $app.DisplayName
            AppId = $app.AppId
            ExpiryDate = $_.EndDate
            StartDate = $_.StartDate
            Type = $_.Type
            Usage = $_.Usage
            Owners = $owner.UserPrincipalName
            Expired = ([DateTime]$_.EndDate -lt $today)
        }
    }

    $app.PasswordCredentials | ForEach-Object {
        $credentials += [PSCustomObject] @{
            CredentialType = "PasswordCredentials"
            DisplayName = $app.DisplayName
            AppId = $app.AppId
            ExpiryDate = $_.EndDate
            StartDate = $_.StartDate
            Type = 'NA'
            Usage = 'NA'
            Owners = $owner.UserPrincipalName
            Expired = ([DateTime]$_.EndDate -lt $today)
        }
    }
}

$credentials | Format-Table -AutoSize

$credentials | Export-Csv -Path "c:\temp\AppsInventory.csv" -NoTypeInformation