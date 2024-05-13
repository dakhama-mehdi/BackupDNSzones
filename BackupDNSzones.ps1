# Script for DNS Zones Backup
# Author: DAKHAMA Mehdi
# Description: Automates the backup of DNS zones
# Version: 1.0 release 05/24

# Getting the current date in 'yyyy-MM-dd-HHmm' format
$backupDate = Get-Date -Format 'yyyy-MM-dd-HHmm'

# Creating the backup directory
$backupDirectory = "$env:SystemRoot\system32\dns\Backup\$backupDate"
New-Item -ItemType Directory -Path $backupDirectory -ErrorAction Stop

# Lists of zones to exclude from backup
$zonesToExclude = @(
    '0.in-addr.arpa',
    '127.in-addr.arpa',
    '255.in-addr.arpa'
)

# Loop through DNS zones and backup non-excluded zones
Get-DnsServerZone | Where-Object { $zonesToExclude -notcontains $_.ZoneName } | ForEach-Object {

    # Getting the current date in 'yyMMddHHmm' format
    $zoneBackupDate = $(Get-Date -Format 'yyMMddHHmm')

    Try {
        Write-Output "Backup zonename : $($_.ZoneName)" 
        Export-DnsServerZone -Name $_.ZoneName -FileName Backup\$backupDate\Backup.$($_.ZoneName).$zoneBackupDate -ErrorAction Stop

    } 
    Catch {
        Write-Error "An error occurred while backing up the zone $($_.ZoneName) : $_"
    }
}
