package { '.NET Framework4.5':
	ensure => "present",
	source => "D:\installs\dotNetFx45_Full_setup.exe",
	install_options => ['/VERYSILENT'],
	before => Package ["atom"],
}

package { 'atom':
	ensure => "installed",
	source => "D:\installs\AtomSetup.exe",
	install_options => ['INSTALLDIR=C:\Program Files\Atom','/VERYSILENT'],
	
}


#install_options => ['INSTALLDIR=C:\Program Files\Atom'],	