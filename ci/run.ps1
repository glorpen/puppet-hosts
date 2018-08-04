$ErrorActionPreference="Stop"

if ( $env:FUNCTIONAL -eq "yes" ) {
    $path = (Get-Item -Path "." -Verbose).FullName
    $puppet_code = "class { ::hosts: hosts => [{'ip'=>'127.0.0.100', 'aliases'=>'local-test'}], target => '$path/hosts.txt' }"
    
    Write-host "Will run: '$puppet_code'"
    
    bundle exec puppet apply --verbose --modulepath=$path\spec\fixtures\modules -e $puppet_code
    $line = Get-Content hosts.txt | Where-Object { $_.Contains("local-test") }
    if ( $line -match "127.0.0.100\s+local-test" ) {
        Write-Output "OK"
    } else {
        Write-Output "ERROR"
        exit 1
    }
} else {
    Write-Output "Skipping functional tests"
}
