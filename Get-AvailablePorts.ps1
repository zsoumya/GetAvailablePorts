function Get-AvailablePorts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [string[]]
        $lines
    )

    begin {
        $exclusions = @()
    }

    process {

        foreach ($line in $lines) {
            if ($line -match "^\s+(?<startPort>\d+)\s+(?<endPort>\d+)\s+.*$") {
                $startPort = [int] $Matches['startPort']
                $endPort = [int] $Matches['endPort']

                $exclusions += @{
                    startPort = $startPort
                    endPort = $endPort
                }
            }
        }
    }

    end {
        $format = "{0, 5} => {1, 5}"
        $lastPort = 0

        foreach ($exclusion in $exclusions) {
            $startPortIncl = $lastPort + 1
            $endPortIncl = $exclusion['startPort'] - 1

            if ($startPortIncl -le $endPortIncl) {
                Write-Output -InputObject ($format -f $startPortIncl, $endPortIncl)
            }
            $lastPort = $exclusion['endPort']
        }

        if ($lastPort -lt 65535) {
            Write-Output -InputObject ($format -f ($lastPort + 1), 65535)
        }
    }
}