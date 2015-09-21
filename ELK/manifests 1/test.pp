#include nssm

include nssm
include down
class nssm {
exec { 'nssm_kibana_start':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm start kibana"',
	require => Exec ['kibana_service_install'],
	timeout => 1800
}
	#	require => Exec ['kibana_service_install'],
exec { 'kibana_service_install':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm install kibana C:\elk\kibana-4.1.2-windows\bin\kibana.bat"',
	require => Exec ['copy_nssm'],
	timeout => 1800
}

exec { 'copy_nssm':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\kibana-4.1.2-windows\bin"',
	require => Class ['down'],
	timeout => 1800
}
}


class down {
windows::unzip { 'C:\temp\nssm-2.24.zip':
	destination => 'C:\elk',
	creates     => 'C:\elk\nssm-2.24',
	require => Download_file ["Download_nssm"],
 timeout => 1800
}

download_file { "Download_nssm" :
			url                   => 'http://nssm.cc/release/nssm-2.24.zip',
		 destination_directory => 'c:\temp',
}
}
