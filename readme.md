# WP-Homestead

This is a fork of Laravel's very stable and beautifully performant Vagrant [_Homestead_](https://laravel.com/docs/homestead) with a couple of scripts added for Wordpress things.

## About Homestead

Because Homestead is so awesome already, this project doesn't mean to improve upon it. From Homesteads official `readme.md`:

Homestead runs on any Windows, Mac, or Linux system, and includes the Nginx web server, PHP 7.2, MySQL, Postgres, Redis, Memcached, Node, and all of the other goodies you need to develop amazing Laravel applications.

To learn how homestead works & for all homestead related issues, you should check out the [official docs](https://laravel.com/docs/homestead).

## About WP-Homestead

### Differences from homestead:

json default scripts removed for simplicity
tests removed

## Requirements

Virtualbox, vagrant and the following vagrant plugins

    vagrant plugin install vagrant-triggers vagrant-hostsupdater

Also wouldn't hurt to add the box in advance (optional):

    vagrant box add laravel/homestead

## Quick start

- Download or clone this repo
- Run `composer update` for deps
- Run `bash init.sh` to initialize some defaults
- Set up `homestead.yml` with your project details
- Run `vagrant up --provision`

## Notes

Make sure you edit /etc/nginx/nginx.conf and set "sendfile" to off if using NFS or you will run into weird caching issues.

sftp & aws & db passwords cannot contain bangs or special chars

## ToDo

- finish wp set permissions
- so homestead's composer update will break provisioning if no internet connection
- If table prefix is not normal - this will all get super fucked up (which might be fine as I'd rather the normal prefix but better security)
- Can add bash alias for homestead