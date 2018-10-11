# logger

# PowerShell でのログ出力を頑張っていたら logger オブジェクトができた - Qiita
# https://qiita.com/miyamiya/items/f36ce9c4b0ffea26afe0

function Global:Put-Log {
    param(
        [string]$LogFile,
        [string]$Encoding,
        [switch]$Info,
        [switch]$Warn,
        [switch]$Err,
        [string]$Message
    )

    $logparam = @("White", "INFO")
    if ($Warn) { $logparam = @("Yellow", "WARN") }
    if ($Err) { $logparam = @("Red", "ERROR") }

    $Message = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")][{0}] {1}" -f $logparam[1], $Message

    Write-Host -ForegroundColor $logparam[0] $Message

    if ($LogFile) {
        Write-Output $Message | Out-File $LogFile -Append -Encoding $Encoding
    }
}

function Global:Get-Logger {
    param(
        [string]$Encoding = "default",
        [string]$LogFile
    )
    $logger = New-Object PSCustomObject
    $logger | Add-Member -MemberType ScriptMethod -Name info  -Value { param($msg) Put-Log -LogFile $LogFile -Encoding $Encoding -Info -Message $msg}.GetNewClosure()
    $logger | Add-Member -MemberType ScriptMethod -Name warn  -Value { param($msg) Put-Log -LogFile $LogFile -Encoding $Encoding -Warn -Message $msg}.GetNewClosure()
    $logger | Add-Member -MemberType ScriptMethod -Name error -Value { param($msg) Put-Log -LogFile $LogFile -Encoding $Encoding -Err  -Message $msg}.GetNewClosure()
    return $logger
}