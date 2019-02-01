<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [VMResettoLCP](#vmresettolcp)
  - [What it does](#what-it-does)
  - [How to use](#how-to-use)
  - [Additional info](#additional-info)
      - [Option 1](#option-1)
      - [What `. $KILLandREVERT` does in particular](#what--killandrevert-does-in-particular)
      - [Option 2](#option-2)
  - [Known issues and future releases](#known-issues-and-future-releases)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# VMResettoLCP
> Powershell script to reset Hyper-V VM to last checkpoint (incl. check if VM is running and the option to stop them).

<!-- Index would be nice -->

## What it does
This script **reset all Hyper-VM machines to their last checkpoint** (**VM Reset to** **L**ast **C**heck**p**oint), checks if a VM is running bevore doing it and gives shiny bright colored output about what it does at the moment. If done, Resetto gives you a report about succsessful reseted VMs and VMs which where not reseted because their where running. You than have the option to *stop* and *reset* them, too, with a simple variable.

## How to use
Simply execute this .ps1 script and follow further instructions if needed.

## Additional info
All your *running* VMs **will not be reseted** and listed separately at the end instead.

Then you have two options:

#### Option 1
You can follow instructions as displayed in the end to stop and reset the rest of the VMs with the variable:

```powershell
    . $KILLandREVERT
```
**Please note the *dot* and *space* in front of the variable!**

The script will show you this option by default at the end if you where running it with 1 or more VMs still running. This is to prevent you from resetting any VM which could be vital to your environment.

#### What `. $KILLandREVERT` does in particular
Basicly the same thing as bevore but it stops every running VM with `Stop-VM -Name $RVM -ComputerName $VMHost` and supresses any warnings with `-Confirm:$false`.

```powershell
$KILLandREVERT = {`
    For ( $RVMCount = 0; $RVMCount -lt $VMList.Count; $RVMCount++)
    {$RVM = $VMList[$RVMCount].Name
    if ( !($RVMdown = $VMList[$RVMCount].State -eq 'Off') )
      { Stop-VM -Name $RVM -ComputerName $VMHost -Confirm:$false
        Write-Host $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "green" $RVM 'STOPPED and reverted to last snapshot...'
        sleep $SleepTime
        Get-VM -Name $RVM | Foreach-Object { $_ | Get-VMSnapshot | Sort CreationTime | Select -Last 1 | Restore-VMSnapshot -Confirm:$false }
       }
    else {}
    }
}
```

#### Option 2

If you are sure you want to kill and revert all running VMs begin with (**not recommendet**), than you can simply change the script and uncomment this line:
```powershell
#  Stop-VM -Name $VM -ComputerName $VMHost -Confirm:$false
```

That the code looks like this:
```powershell
   Stop-VM -Name $VM -ComputerName $VMHost -Confirm:$false
```

## Known issues and future releases

The code is pretty messy and unelegant. Mostly because I didn't used arrays and just "Foreach if-else"-ed everything. I think I'll learn about arrays and change it when I am done with my MCSA. If you want to array this thing, than feel free to send me a pull request.

In the end this script does a simple task with a bit to much code, but *you know, when all is said and done, it makes good toast.*
