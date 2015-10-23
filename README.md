# nd-hyperv-cookbook

![](http://www.joshluedeman.com/wp-content/uploads/2014/06/Hyper-V-logo.png)

This cookbook works (as role cookbook)
 * Installs chefdk
 * Adds knife.rb and client key so that hyper-v nodes can create vms
 * Raises hyper-v role 
 * Joins to AD domain
 * Adds determined user to local admins.

## Supported Platforms
Windows Server 2012R2

## Atributes

- ``default['nd-hyperv']['environment_key']`` - Set environment wich will be used (dev, prod, etc.).
- ``default['nd-hyperv']['databag_keys']`` - Name of databag wich contains chefs keys. 
- ``default['nd-hyperv']['file_keys']`` - Name of subfolder wich contains chefs keys. 
- ``default['nd-hyperv']['validation']['encrypted_data_bag'] `` - Set true if encrypted databags are used
- ``default['nd-hyperv']['client']['encrypted_data_bag'] `` - Set true if  encrypted databags are used

###Important 
Names of keys consists of 2 parts. For example: 
- dev-validator.pem 
- dev-client.pem

Where 
- ``dev`` is environment variable avalible in atributes/default.rb ``default['nd-hyperv']['environment_key']``
- ``-validator`` and ``-client`` are **unchangeble parts** of name and should be the same for all keys.

###Databags keys usage
When node bootstraps, pair of keys  ``client.pem`` and ``validator.pem`` are creating with some conditions.

First of all cookbook calls databag and checks  ``default['nd-hyperv']['validation']['encrypted_data_bag'] `` variable. If it is `true` chef will use object ``EncryptedDataBagItem`` which loads and decrypt keys. If unencrypted databag items are used, variable should be `false`.

If there are no avalible databags, chef uses keys wich are stored in Files/subfolder_name, seted in ``default['nd-hyperv']['file_keys']`` . 

## Usage

Bootstrap chef-client and install as service. Set environment wit "-E"
```
knife bootstrap windows winrm ip-address -x Administrator -P 'password' -N 'node_name'  -E environment_name --install-as-service
```
Set the proper role to your node on Chef server
```
knife node run_list set 'node_name' 'role[role_name]'
```
Run chef client on node. 
```
knife winrm 'node_name' chef-client -m -x Administrator -P 'password'
```



## Deprecated??

You will still need to add the hyperv node to the group with knifeacl

```
# UNTESTED
knife group create bootstrap-clients
knife acl add group bootstrap-clients clients create,read,update
knife acl bulk add group bootstrap-clients '.\*' clients create,read,update --yes
```

After node has been bootstrapped
    #UNTESTED
    knife group add client lab-hvci06 bootstrap-clients

[http://spuder.github.io/chef/chef-12-admin-clients/](http://spuder.github.io/chef/chef-12-admin-clients/)

## License and Authors
Author:: Andrii Demianenko (ademian@softserveinc.com)    
Author:: Spencer Owen (sowen@netdocuments.com)
























<h3>Pre-requirements</h3>

1. You need to have git already installed. If not you can download it [here] (https://git-scm.com/download/win)

2. Install puppet. You can download it [here] (https://downloads.puppetlabs.com/windows/?_ga=1.247525890.405451615.1442388246)

3. Downloand all soruces into disk C:\ using git bash by executing the command:

 ```
 git clone https://github.com/nonst0penergy/elksource.git
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
