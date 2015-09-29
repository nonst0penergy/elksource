<h3>Pre-requirements</h3>

1. You need to have git already installed. If not you can download it [here] (https://git-scm.com/download/win)

2. Install puppet. You can download it [here] (https://downloads.puppetlabs.com/windows/?_ga=1.247525890.405451615.1442388246)

3. Downloand all soruces into disk C:\ using git bash by executing the command:

 ```
 git clone https://github.com/nonst0penergy/puppet/tree/master/ELK
 ```

4. Download and install Java jdk,( you can use following [link] (http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)) and
set JAVA_HOME environment variable
or you can install Java jdk using puppet in 2 steps:
   ```
    puppet apply C:\elksource\manifests\windows_modules.pp
    puppet apply C:\elksource\manifests\jdk_install.pp
   ```

5. After Java install you need to reboot your system.

<h3>ELK install</h3>

1. If you didnt use this jdk_install.pp with Java installation, then run command below with Puppet Command Promt:
```
  puppet apply Path:\manifests\jdk_install.pp
```
2. Install full elk:
```
  puppet apply init.pp
```
3. Services managment
```
C:\elk\elasticsearch-1.7.2\bin\service start\stop\remove\install

C:\elk\logstash-1.5.4\bin\nssm start\stop\remove logstash

C:\elk\kibana-4.1.2-windows\bin\nssm start\stop\remove kibana
```
Puppet tests

1. You need to have ruby installed on your system. If not you can download it here http://rubyinstaller.org/downloads/
2. To check out manifest result, run following command:
```
C:\elksource> rake spec
```
