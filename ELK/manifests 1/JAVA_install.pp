
exec { 'cyberious-windows_java':

	command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Program` Files\Puppet` Labs\Puppet\bin\puppet module install cyberious-windows_java"',

}

include 'windows_java'



#class java_install {
#windows::environment { 'JAVA_HOME':
#	value => 'C:\Program Files\Java\jdk1.8.0_45',
#}

#include 'windows_java'
#}
