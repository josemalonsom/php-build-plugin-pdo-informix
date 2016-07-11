#PDO_INFORMIX plugin for php-build#

This is a plugin for [php-build](https://github.com/CHH/php-build) that
download and compiles the PECL
[PDO_INFORMIX](http://pecl.php.net/package/PDO_INFORMIX) extension.

[![Build Status](http://vps195060.ovh.net:8080/job/php-build-plugin-pdo-informix/badge/icon)](http://vps195060.ovh.net:8080/job/php-build-plugin-pdo-informix)

##Download##

You can download the code cloning the repository with git or downloading
it as a tarball.

- Cloning with git

```sh
    $ git clone https://github.com/josemalonsom/php-build-plugin-pdo-informix.git
```
- Downloading the source as a tarball

```sh
    $ wget --no-check-certificate https://github.com/josemalonsom/php-build-plugin-pdo-informix/archive/master.tar.gz -O php-build-plugin-pdo-informix.tar.gz
    $ tar -zxf php-build-plugin-pdo-informix.tar.gz
```

In both cases you will end with a directory, `php-build-plugin-pdo-informix`
in the first case and `php-build-plugin-pdo-informix-master` in the second,
which contains the plugin script `pdo_informix.sh`.

##Install##

To install the plugin you can copy or link the plugin `pdo_informix.sh`
to the plugins directory of php-build, in the default installation it is
/usr/local/share/php-build/plugins.d .

First, move to the source directory `cd php-build-plugin-pdo-informix`
or `cd php-build-plugin-pdo-informix-master`, then

```sh
    $ cp ./pdo_informix.sh /usr/local/share/php-build/plugins.d
```

or, if you prefer link the plugin

```sh
    $ ln -s `pwd`/pdo_informix.sh /usr/local/share/php-build/plugins.d/
```

if your php-plugin directory does not match the default installation you must
change the path accordingly.

> Note that, depending on your installation, you may need superuser permissions to execute the command.

##Commands defined by the plugin##

The plugin defines two commands:

**install_pdo_informix**

Installs a specific version of the extension:

```sh
    install_pdo_informix 1.3.1
```

**install_pdo_informix_master**

Installs a development version of the extension, it clones the git repository
of PDO_INFORMIX and compiles the master branch. Optionally you can use a specific
commit to compile as first param:

```sh
    install_pdo_informix_master a88390f
```

##How to use##

First of all read the [php-build](https://github.com/CHH/php-build) documentation
to understand how the plugin system works, then append the command what you want
to use to the definitions what you will build, for example, assuming you
have the default installation:

```sh
    $ sed -i '$a install_pdo_informix 1.3.1' /usr/local/share/php-build/plugins.d/definitions/5.5.18
```
this will add the line "install_pdo_informix 1.3.1" to the end of the definition file.

> Be careful, executing the previous command more than once will end with the command appended multiple times.

> Note that, depending on your installation, you may need superuser permissions to execute the command.

##Prerequisites##

For build the extension you need to have installed the Informix Client SDK
and the INFORMIXDIR variable must be exported with the path to the
directory where it is installed (generally /opt/informix).

See http://php.net/pdo-informix .

#Credits#

The plugin is a modified copy of the plugin [xhprof.sh](https://github.com/CHH/php-build/blob/master/share/php-build/plugins.d/xhprof.sh), so all the credit is for the [php-build](https://github.com/CHH/php-build) guys.
