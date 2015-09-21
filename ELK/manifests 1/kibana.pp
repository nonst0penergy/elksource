exec { 'kibana start':

	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\kibana"',
  require => Windows::unzip ['C:\temp\kibana-4.1.2-windows.zip'],
  timeout => 1800
}
#	 require => Download_file ["Download kibana"],
windows::unzip { 'C:\temp\kibana-4.1.2-windows.zip':
  destination => 'C:\elk',
  creates     => 'C:\elk\kibana-4.1.2-windows',
  require => Download_file ["Download kibana"],
 timeout => 1800
}

download_file { "Download kibana" :
      url                   => 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-windows.zip',
     destination_directory => 'c:\temp',

}
