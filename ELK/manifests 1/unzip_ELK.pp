

exec { 'copy_nssm':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\kibana-4.1.2-windows\bin"',
		timeout => 1800
}
