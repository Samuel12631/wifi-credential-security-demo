# wifi-credential-security-demo
Educational demonstration of USB-based WiFi credential attack vectors and defensive measures.

For educational purposes only

This code is not for stealing passwords using usb, only for simulating vulnerability.

Demo version

The code works on the display procedure using cmd command >netsh wlan show profiles< and on the basis of displayed profiles. After displaying profiles, it saves them and proceeds further (.bat file) and displays passwords using the command >netsh wlan show profile XXXXX key=clear<. This is the .bat file that is run in autohidden mode using .vbs file. .vbs file needs to be set in autorun software to the root startup file that will be run automatically after inserting USB key into PC. Output will be automatically saved in hidden txt file. You must have show hidden files checked.

For this project you will need USB key and install USB AUTORUN software from my repository.

Procedure>:

>Connect USB to PC
>Install AUTORUN software
>Put WfFiFix.bat and run.vbs files on USB
>Run autorun, select external USB drive and select run.vbs file to run
>Test on your own PC
