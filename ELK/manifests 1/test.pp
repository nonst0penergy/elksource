#include nssm

include nssm
include down_nssm
class nssm {
exec { 'nssm_kibana_start':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm start logstash"',
	require => Exec ['logstash_service_install'],
	timeout => 1800
}
	#	require => Exec ['kibana_service_install'],
exec { 'logstash_service_install':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm install logstash C:\elk\logstash-1.5.4\bin\run.bat"',
	require => Exec ['copy_nssm_logstash'],
	timeout => 1800
}

exec { 'copy_nssm_logstash':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\logstash-1.5.4\bin"',
	require => Class ['down_nssm'],
	timeout => 1800
}

file { 'C:\elk\logstash-1.5.4\bin\run.bat':
    replace => "no", # this is the important property
    ensure  => "present",
    content => "logstash.bat agent -f logstash.conf",
    mode    => 0700,
}

}
class down_nssm {
windows::unzip { 'C:\temp\logstash-1.5.4.zip':
	destination => 'C:\elk',
	creates     => 'C:\elk\logstash-1.5.4',
	require => Download_file ["Download_nssm"],
 timeout => 1800
}

download_file { "Download_logstash" :
			url                   => 'https://download.elastic.co/logstash/logstash/logstash-1.5.4.zip',
		 destination_directory => 'c:\temp',
		 }
}
