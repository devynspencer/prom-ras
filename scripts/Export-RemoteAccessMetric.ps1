<#
    .SYNOPSIS
    Export RRAS metrics in Prometheus format.

    .DESCRIPTION
    Export RRAS metrics in Prometheus (.prom) file format.

    Metrics are collected using the Get-RemoteAccessConnectionStatistics and Get-RemoteAccessConnectionStatisticsSummary cmdlets from the RemoteAccess module.

    .PARAMETER ExportPath
    Directory path that the metrics will be exported to. C:\temp\prometheus is the default.

    .EXAMPLE
    Export-RemoteAccessMetric.ps1

    Exports all remote access metrics to default file location.

    .NOTES
    Intended for use in a scheduled task. Requires elevated credentials (for RemoteAccess cmdlets).
#>

param (
    $ExportPath = "C:\temp\prometheus"
)

New-Item -Path $ExportPath -Force | Out-Null
