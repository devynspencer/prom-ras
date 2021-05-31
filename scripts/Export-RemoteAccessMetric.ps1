<#
    .SYNOPSIS
    Export RRAS metrics in Prometheus format.

    .DESCRIPTION
    Export RRAS metrics in Prometheus (.prom) file format.

    Metrics are collected using the Get-RemoteAccessConnectionStatistics and Get-RemoteAccessConnectionStatisticsSummary cmdlets from the RemoteAccess module.

    .PARAMETER Path
    Directory path that the metrics will be exported to. Alias of ExportPath for clarity.

    .PARAMETER ExportPath
    Directory path that the metrics will be exported to. C:\temp\prometheus is the default.

    .EXAMPLE
    Export-RemoteAccessMetric.ps1

    Exports all remote access metrics to default file location.

    .NOTES
    Intended for use in a scheduled task. Requires elevated credentials (for RemoteAccess cmdlets).
#>

$RasConnectionSummary = Get-RemoteAccessConnectionStatisticsSummary

param (
    [Alias("Path")]
    $ExportPath = "C:\temp\prometheus"
)

New-Item -Path $ExportPath -Force | Out-Null

$ExportFilePath = Join-Path -Path $ExportPath -ChildPath "ras.prom"

$WriteParameters = @{
    Path = $ExportFilePath
    Encoding = "Ascii"
}

Set-Content @WriteParameters -Value ""
Add-Content @WriteParameters -Value "HELP ras_connections_total Total connections since service start"
Add-Content @WriteParameters -Value "TYPE ras_connections_total counter"
Add-Content @WriteParameters -Value "ras_connections_total $($RasConnectionSummary.TotalCumulativeConnections)"
Add-Content @WriteParameters -Value ""

Add-Content @WriteParameters -Value "HELP ras_concurrent_connections_max Max concurrent connections"
Add-Content @WriteParameters -Value "TYPE ras_concurrent_connections_max counter"
Add-Content @WriteParameters -Value "ras_concurrent_connections_max $($RasConnectionSummary.MaxConcurrentConnections)"
Add-Content @WriteParameters -Value ""

Add-Content @WriteParameters -Value "HELP ras_users_total Total unique users since service start"
Add-Content @WriteParameters -Value "TYPE ras_users_total counter"
Add-Content @WriteParameters -Value "ras_users_total $($RasConnectionSummary.TotalUniqueUsers)"
Add-Content @WriteParameters -Value ""

Add-Content @WriteParameters -Value "HELP ras_bytes_total Total bytes transmitted since service start"
Add-Content @WriteParameters -Value "TYPE ras_bytes_total counter"
Add-Content @WriteParameters -Value "ras_bytes_total $($RasConnectionSummary.TotalBytesInOut)"
Add-Content @WriteParameters -Value ""

Add-Content @WriteParameters -Value "HELP ras_bytes_received_total Total bytes received since service start"
Add-Content @WriteParameters -Value "TYPE ras_bytes_received_total counter"
Add-Content @WriteParameters -Value "ras_bytes_received_total $($RasConnectionSummary.TotalBytesIn)"
Add-Content @WriteParameters -Value ""
