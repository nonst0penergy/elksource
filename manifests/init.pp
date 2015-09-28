#Calls all classes 
include logstash
include down_logstash
include kibana
include elasticsearch
include unzip_elastic
include unzip_kibana
include down_nssm



class kibana {
# Starts kibana as service
exec { 'nssm_kibana_start':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm start kibana"',
require => Exec ['kibana_service_install'],
timeout => 1800
}
#Installs kibana as service
exec { 'kibana_service_install':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm install kibana C:\elk\kibana-4.1.2-windows\bin\kibana.bat"',
require => Exec ['copy_nssm'],
timeout => 1800
}
#Copying nssm.exe into C:\elk\kibana-4.1.2-windows\bin
exec { 'copy_nssm':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\kibana-4.1.2-windows\bin"',
require => [Class ['down_nssm'], Class ['unzip_kibana'] ],
timeout => 1800
}
}



class logstash {
#Starts logstash service
exec { 'nssm_logstash_start':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\logstash-1.5.4\bin\nssm start logstash"',
require => File ['C:\elk\logstash-1.5.4\logstash-simple.conf'],
timeout => 1800
}

#Moves config file logstash-simple.conf into C:\elk\logstash-1.5.4\
file {'C:\elk\logstash-1.5.4\logstash-simple.conf':
ensure => 'file',
mode => '0700',
owner => 'Administrator',
group => 'Administrators',
source => 'C:\elksource\files\logstash-simple.conf',
require => Exec['logstash_service_install'],
}

#Installs logstash as service
exec { 'logstash_service_install':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\logstash-1.5.4\bin\nssm install logstash C:\elk\logstash-1.5.4\bin\run.bat"',
require => [File ['C:\elk\logstash-1.5.4\bin\run.bat'],Exec ['copy_nssm_logstash']],
timeout => 1800
}
#Creates run.bat file
file { 'C:\elk\logstash-1.5.4\bin\run.bat':
replace => "no", # this is the important property
ensure => "present",
content => "logstash.bat agent -f logstash.conf",
mode => 0700,
require => Exec ['copy_nssm_logstash'],
}
#Copying nssm.exe into C:\elk\logstash-1.5.4\bin
exec { 'copy_nssm_logstash':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\logstash-1.5.4\bin"',
require => [Class ['down_nssm'], Class ['down_logstash'] ],
timeout => 1800
}
}


#Donwloads logstash-1.5.4.zip into C:\temp , and unzip into C:\elk
class down_logstash {
windows::unzip { 'C:\temp\logstash-1.5.4.zip':
destination => 'C:\elk',
creates => 'C:\elk\logstash-1.5.4',
require => [Class ['down_nssm'], Download_file ["Download_logstash"] ],

}

download_file { "Download_logstash" :
url => 'https://download.elastic.co/logstash/logstash/logstash-1.5.4.zip',
destination_directory => 'c:\temp',
}
}


#Donwloads nssm-2.24.zip into C:\temp , and unzip into C:\elk
class down_nssm {
windows::unzip { 'C:\temp\nssm-2.24.zip':
destination => 'C:\elk',
creates => 'C:\elk\nssm-2.24',
require => Download_file ["Download_nssm"],

}
#timeout => 1800
download_file { "Download_nssm" :
url => 'http://nssm.cc/release/nssm-2.24.zip',
destination_directory => 'c:\temp',
}
}



class elasticsearch {
#Starts elasticsearch service
exec { 'elasticsearch start':

command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service start"',
require => Exec ["elasticsearch install"],
}
#Moves elasticsearch.yml into config folder
file {'C:\elk\elasticsearch-1.7.2\config\elasticsearch.yml':
ensure => 'file',
mode => '0700',
owner => 'Administrator',
group => 'Administrators',
source => 'C:\elksource\files\elasticsearch.yml',
require => Exec ["elasticsearch install"],
}
#Installs elasticsearch-head plugin
exec { 'elasticsearch-head plugin':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\plugin -install mobz/elasticsearch-head"',
require => Exec ["elasticsearch install"],
}
exec { 'elasticsearch install':
#installs elastcsearch service
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service install"',
require => [Class ['unzip_elastic'], Download_file ["Download elasticsearch"] ],
timeout => 1800
}
}


#Donwloads kibana-4.1.2-windows.zip into C:\temp , and unzip into C:\elk
class unzip_kibana {

download_file { "Download kibana" :
url => 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-windows.zip',
destination_directory => 'c:\temp',
}
windows::unzip { 'C:\temp\kibana-4.1.2-windows.zip':
destination => 'C:\elk',
creates => 'C:\elk\kibana-4.1.2-windows',
require => [Class ['unzip_elastic'], Download_file ["Download kibana"] ],
timeout => 1800
}
}

#Donwloads elasticsearch-1.7.2.zip into C:\temp , and unzip into C:\elk
class unzip_elastic {
windows::unzip { 'C:\temp\elasticsearch-1.7.2.zip':
destination => 'C:\elk',
creates => 'C:\elk\elasticsearch-1.7.2',
require => Download_file ["Download elasticsearch"],
timeout => 600
}
download_file { "Download elasticsearch" :
url => 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.zip',
destination_directory => 'c:\temp',
}
}

#Creates folder 'elk'
exec { 'elk':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe mkdir C:\elk',
}

#windows::environment { 'JAVA_HOME':
# value => 'C:\Program Files\Java\jdk1.8.0_60',
#}

