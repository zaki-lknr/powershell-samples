. .\logger.ps1

$logger = Get-Logger -LogFile "example.log"

$logger.info("start")


$logger.info("end")