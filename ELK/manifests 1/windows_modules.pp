#Puppet module for download_file
exec { 'opentable-download_file':

	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install opentable-download_file"',
	timeout => 1800
}

#Puppet module for unzip
exec { 'counsyl-windows':

	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install counsyl-windows"',

}

#Puppet module for JAVA install
exec { 'cyberious-windows_java':

	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install cyberious-windows_java"',

}
