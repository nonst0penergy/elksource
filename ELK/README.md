Pre-requirements

Download and instal Java jdk. You can use following link http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html and 
set JAVA_HOME environment variable
or you can install Java jdk using puppet in 2 steps:

1. puppet apply Path:\windows_modules.pp
2. puppet apply Path:\jdk_install.pp

After Java install you need to reboot your PC

ELK install

To install ELK run:

1. If you didnt use this manifest with Java install run:

puppet apply Path:\manifests\jdk_install.pp

2. Install full elk:

puppet apply init.pp




