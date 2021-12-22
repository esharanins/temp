
function Retry-Command {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock] $ScriptBlock,       
        [int] $RetryCount = 5,
        [int] $RetryDelaySeconds = 10
    )
    $success = $false
    $retry = 0
    while (!$success) {
        try {
            & $ScriptBlock
            $success = $true
        } catch {
            if ($retry -lt $RetryCount) {
                $retry++
                Write-Warning "Error encountered: $($_.Exception). Retrying after $RetryDelaySeconds seconds"
                Start-Sleep -Seconds $RetryDelaySeconds
            } else {
                Write-Warning "Operation failed after $retry retries"
                throw
            }
        }
    }
}

####################
while ($StatusCode -ne 200)
{
    Write-Host "1 Code: $StatusCode"
    Start-Sleep -Seconds 1
    Retry-Command -ScriptBlock {
        $Responce = Invoke-WebRequest -Uri "http://ifconfig.co"
        $StatusCode = $Responce.StatusCode
        Write-Host "2 Code: $StatusCode"
    }
}

