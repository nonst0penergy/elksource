include kibana
#include logstash
#include down_logstash
include elasticsearch
include unzip_elastic
include unzip_kibana
include down_nssm



class kibana {
exec { 'nssm_kibana_start':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm start kibana"',
require => Exec ['kibana_service_install'],
timeout => 1800
}
# require => Exec ['kibana_service_install'],
exec { 'kibana_service_install':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\kibana-4.1.2-windows\bin\nssm install kibana C:\elk\kibana-4.1.2-windows\bin\kibana.bat"',
require => Exec ['copy_nssm'],
timeout => 1800
}

exec { 'copy_nssm':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\kibana-4.1.2-windows\bin"',
require => [Class ['down_nssm'], Class ['unzip_kibana'] ],
timeout => 1800
}
}



class logstash {
exec { 'nssm_logstash_start':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\logstash-1.5.4\bin\nssm start logstash"',
require => Exec ['logstash_service_install'],
timeout => 1800
}
# require => Exec ['kibana_service_install'],
exec { 'logstash_service_install':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\logstash-1.5.4\bin\nssm install logstash C:\elk\logstash-1.5.4\bin\run.bat"',

require => [File ['C:\elk\logstash-1.5.4\bin\run.bat'],Exec ['copy_nssm_logstash']],
timeout => 1800
}

file { 'C:\elk\logstash-1.5.4\bin\run.bat':
replace => "no", # this is the important property
ensure => "present",
content => "logstash.bat agent -f logstash.conf",
mode => 0700,
require => Exec ['copy_nssm_logstash'],
}

exec { 'copy_nssm_logstash':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe copy -Path C:\elk\nssm-2.24\win64\nssm.exe -Destination "C:\elk\logstash-1.5.4\bin"',
require => [Class ['down_nssm'], Class ['down_logstash'] ],
timeout => 1800
}
}



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

#require => Download_file ["Download kibana"],

exec { 'elasticsearch start':

command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service start"',
require => Exec ["elasticsearch install"],
}
file {'C:\elk\elasticsearch-1.7.2\config\elasticsearch.yml':
ensure => 'file',
mode => '0700',
owner => 'Administrator',
group => 'Administrators',
source => 'C:\elksource\files\elasticsearch.yml',
require => Exec ["elasticsearch install"],
}

exec { 'elasticsearch-head plugin':
command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\plugin -install mobz/elasticsearch-head"',
require => Exec ["elasticsearch install"],
}
exec { 'elasticsearch install':

command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elk\elasticsearch-1.7.2\bin\service install"',
require => [Class ['unzip_elastic'], Download_file ["Download elasticsearch"] ],
timeout => 1800
}
}



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

exec { 'elk':

command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe mkdir C:\elk',
}

#require => Download_file ["Download elasticsearch"],


#Puppet module for download_file
#exec { 'opentable-download_file':

# command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install opentable-download_file"',
# timeout => 1800
#}

#Puppet module for unzip
#exec { 'counsyl-windows':

# command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install counsyl-windows"',

#}

#Puppet module for JAVA install
#exec { 'cyberious-windows_java':

# command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install cyberious-windows_java"',

#}



#windows::environment { 'JAVA_HOME':
# value => 'C:\Program Files\Java\jdk1.8.0_60',
#}

#download_file { "Download jdk8":
# url => 'http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-windows-x64.exe',
# destination_directory => 'C:\temp'
#
#
#}
#exec { 'C:\elasticsearch-1.7.2\bin\':
# command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\elasticsearch-1.7.2\bin\service install"',
# before => Download_file ["jdk8"],''
#}
