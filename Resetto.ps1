#
# RESETTO
# SET ALL VMS TO LAST CHECKPOINT
# Version 0.1.1
# Starte, Shakir
# 13/01/2019
#
$VMList = Get-VM | select Name, State
$VMHost = get-content env:computername
$SleepTime = 1
Clear-Host
For ( $VMCount = 0; $VMCount -lt $VMList.Count; $VMCount++)
{
 $VM = $VMList[$VMCount].Name
 if ( !($VMdown =  $VMList[$VMCount].State -eq 'Off') )
   {
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "yellow" $VM 'still running... VM NOT REVERTED! Please stop VM first.'
#  Stop-VM -Name $VM -ComputerName $VMHost -Confirm:$false
   }
   else
   {
   Write-Host $VM 'reverted to last snapshot...'
   sleep $SleepTime
   Get-VM -Name $VM | Foreach-Object { $_ | Get-VMSnapshot | Sort CreationTime | Select -Last 1 | Restore-VMSnapshot -Confirm:$false }
   }
}
# REQUEST: Überarbeitung mit arrays um Code schlanker zu machen.
# Report ab hier:
Write-Host "`nREPORT:`n"
# Liste mit zurückgesetzten Maschienen
write-host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" "Successful Setback:`n"
For ( $VMCount = 0; $VMCount -lt $VMList.Count; $VMCount++)
{
 $VM = $VMList[$VMCount].Name
 if ( ($VMdown =  $VMList[$VMCount].State -eq 'Off') )
   {
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" $VM
   }
   else
   {
   }
}
# Liste mit laufenden VMs (wurden nicht zurückgesetzt)
Write-Output "`n"
Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "yellow" "No Setback for VM(s):`n"
$RVM = @()
For ( $VMCount = 0; $VMCount -lt $VMList.Count; $VMCount++)
{
 $VM = $VMList[$VMCount].Name
 if ( !($VMdown =  $VMList[$VMCount].State -eq 'Off') )
   {
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "yellow" $VM
   $RVM += $VM
   }
   else
   {
   }
}
# Erfolgsmeldung oder (wenn min. 1 VM läuft) Hinweis zum weiteren Verfahren.
$VMstate = Get-VM | select State
 if ( ($VMstate.State -ne 'Off') )
   {
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "red" "`nIf you want to setback these VMs, please make sure to stop them first and run this script again.`nAlternative you can uncomment Line 14 to stop all running VMs while running this script again.`n"
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "red" 'Or you can run the command . $KILLandREVERT (including the dot and space in front).'
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "red" "WARNING! This will STOP all VMs and reset them to the last checkpoint!"
   }
   else
   {
   Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" "None. Everything was set back. Welcome to the past :)"
   }
# REQUEST: Anstelle der Variable einfach eine Y/N Abfrage starten.
# Setzt eine Variable als Befehl: Alle running VMs stoppen und zurück setzen. Läuft NUR mit Punkt und Leerzeichen vor der Variable: [. $variable]
$KILLandREVERT = {`
    For ( $RVMCount = 0; $RVMCount -lt $VMList.Count; $RVMCount++)
    {$RVM = $VMList[$RVMCount].Name
    if ( !($RVMdown = $VMList[$RVMCount].State -eq 'Off') )
      { Stop-VM -Name $RVM -ComputerName $VMHost -Confirm:$false
        Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" $RVM 'STOPPED and reverted to last snapshot...'
        sleep $SleepTime
        Get-VM -Name $RVM | Foreach-Object { $_ | Get-VMSnapshot | Sort CreationTime | Select -Last 1 | Restore-VMSnapshot -Confirm:$false }
 # NOT WORKING PROPERLY: Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" "`nAll stopped and reverted to last snapshot.`n"
       }
    else {}
    }
}
