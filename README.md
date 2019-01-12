# VMResettoLCP
Powershell script to reset Hyper-V VM to last checkpoint (incl. check if VM is running and option to stop them).


## What it does
This script give you shiny bright colors and does a simple task witch a bit to much and unelegant code (but whatever works, eh?!)

## How to use

Simply execute this .ps1 script and follow further instructions if needed.

## Additional info

All your running VMs will not be reseted an listed separately at the end instead.

You have two options:

#### Option 1

You change the script from begin with and uncomment this line:

```powershell
#  Stop-VM -Name $VM -ComputerName $VMHost
```
That the code looks like this:

```powershell
   Stop-VM -Name $VM -ComputerName $VMHost
```

#### Option 2
You can stop and reset them to with the displayed variable:

```powershell
    . $KILLandREVERT
```

Please note the dot and space in front of the variable!
The script will show you this option by default at the end if you where running it with 1 or more VMs still running. This is to prevent you from resetting any VM which could be vital to your enviromant.
