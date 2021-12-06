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

$Servers | ForEach-Object {

    $session = New-PSSession –ComputerName "$_.$DC" -Credential $cred -Authentication Credssp -ErrorAction Stop
    Invoke-Command -Session $session -ScriptBlock {
           
        try {              
            if ($args[1] -eq "Start") {                      
                Start-WebAppPool -Name $args[0] -ErrorAction Stop
                #Write-Host "`n$($env:COMPUTERNAME) : $($args[0]) appPool successfully started." -ForegroundColor Cyan
            }
            elseif ($args[1] -eq "Stop") {
                Stop-WebAppPool -Name $args[0] -ErrorAction Stop
                #Write-Host "`n$($env:COMPUTERNAME) : $($args[0]) appPool successfully stopped." -ForegroundColor Cyan
            }
            else {
                Restart-WebAppPool -Name $args[0] -ErrorAction Stop
                #Write-Host "`n$($env:COMPUTERNAME) : $($args[0]) appPool successfully recycled." -ForegroundColor Cyan
            }                
        }
        catch {        
            Write-Host "`n$($env:COMPUTERNAME) : $($_.Exception.Message)" -ForegroundColor Red
        }

    } -ArgumentList $Site, $Action
}
