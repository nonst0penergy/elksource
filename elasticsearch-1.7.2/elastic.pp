exec { 'elasticsearch start':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service start"',
	require => Exec ["elasticsearch install"],
}
file {'C:\elk\elasticsearch-1.7.2\config\elasticsearch.yml':
	ensure => 'file',
      mode   => '0700',
      owner  => 'Administrator',
      group  => 'Administrators',
      source => 'C:\temp\elasticsearch.yml',
       require => Exec ["elasticsearch install"],
}

exec { 'elasticsearch-head plugin':
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\plugin -install mobz/elasticsearch-head"',
	require => Exec ["elasticsearch install"],	
}
exec { 'elasticsearch install':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service install"',
	 require => Download_file ["Download elasticsearch"],
 	timeout => 1800
}

windows::unzip { 'C:\temp\elasticsearch-1.7.2.zip':
  destination => 'C:\elk',
  creates     => 'C:\elk\elasticsearch-1.7.2',
  require => Download_file ["Download elasticsearch"],
 timeout => 1800
}

windows::environment { 'JAVA_HOME':
	value => 'C:\Program Files\Java\jdk1.8.0_45',
}

include 'windows_java'
exec { 'elk':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe mkdir C:\elk',
}

download_file { "Download elasticsearch" :
      url                   => 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.zip',
     destination_directory => 'c:\temp',
    
}
exec { 'opentable-download_file':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install opentable-download_file"',
	timeout => 1800
}
exec { 'counsyl-windows':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install counsyl-windows"',

}
	

exec { 'cyberious-windows_java':
	
	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install cyberious-windows_java"',
	
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
