[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true,Position=0)]
    [ValidateSet("Start","Stop","Recycle")]
    [string]$Action,

    [Parameter(Mandatory=$true,Position=1)]
    [string]$Site,
    
    [Parameter(Mandatory=$false,Position=3)]
    [string[]]$Servers,

    [Parameter(Mandatory=$false)]
    [pscredential]$cred
)

if ($null -eq $cred) { $cred = Get-Credential $DC\$env:USERNAME }

foreach ($Server in $Servers) {

    $session = New-PSSession –ComputerName "$Server.$DC" -Credential $cred -Authentication Credssp -ErrorAction Stop
    Invoke-Command -Session $session -ScriptBlock {
           
        try {              
            if ($args[1] -eq "Start") {                      
                Start-WebAppPool -Name $args[0] -ErrorAction Stop
            }
            elseif ($args[1] -eq "Stop") {
                Stop-WebAppPool -Name $args[0] -ErrorAction Stop
            }
            else { Restart-WebAppPool -Name $args[0] -ErrorAction Stop }                
        }
        catch { Write-Host "`n$($env:COMPUTERNAME) : $($_.Exception.Message)" }
        
    } -ArgumentList $Site, $Action
}
