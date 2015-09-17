fiel {'C:\elk\elasticsearch-1.7.2\config\elasticsearch.yml':
	ensure => 'file',
      mode   => '0700',
      owner  => 'Administrators',
      group  => 'Administrators',
      source => 'C:\temp\elasticsearch.yml'
}
exec { 'elasticsearch install':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service start"',
}
exec { 'elasticsearch install':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service install"',
}

windows::unzip { 'C:\temp\elasticsearch-1.7.2.zip':
  destination => 'C:\elk',
  creates     => 'C:\elk\elasticsearch-1.7.2',
  require => Download_file ["Download elasticsearch"],
 timeout => 1800
}

exec { 'elk':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe mkdir C:\elk',
}

download_file { "Download elasticsearch" :
      url                   => 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.zip',
     destination_directory => 'c:\temp',
    
}
exec { 'counsyl-windows':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install counsyl-windows"',
}



#windows::environment { 'JAVA_HOME':
#  value => 'C:\Program Files\Java\jdk1.8.0_60',
#}

#download_file { "Download jdk8":
#	url => 'http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-windows-x64.exe',
#	destination_directory => 'C:\temp'
#	
#	
#}
#exec { 'C:\elasticsearch-1.7.2\bin\':
#		command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elasticsearch-1.7.2\bin\service install"',
#	before => Download_file ["jdk8"],''
#}







