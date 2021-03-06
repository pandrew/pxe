## Options to set on the command line
# reference:
# https://www.debian.org/releases/wheezy/example-preseed.txt
d-i debian-installer/locale string en_US.utf8
d-i console-setup/ask_detect boolean false
d-i console-setup/layout string USA

# Network configuration
d-i netcfg/choose_interface select auto
#d-i netcfg/get_hostname string {{.Hostname}}
d-i netcfg/get_hostname string srv1
#d-i netcfg/get_domain string {{.Domainname}}
d-i netcfg/get_domain string home.lan
d-i netcfg/wireless_wep string

d-i netcfg/choose_interface select auto


d-i time/zone string UTC
d-i clock-setup/utc-auto boolean true
d-i clock-setup/utc boolean true

d-i kbd-chooser/method select American English


# If you want the preconfiguration file to work on systems both with and
# without a dhcp server, uncomment these lines and the static network
# configuration below.
#d-i netcfg/dhcp_failed note
#d-i netcfg/dhcp_options select Configure network manually

# Static network configuration.
#
# IPv4 example
d-i netcfg/get_ipaddress string 192.168.88.42
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 192.168.88.1
d-i netcfg/get_nameservers string 192.168.88.1
d-i netcfg/confirm_static boolean true
#
# IPv6 example
#d-i netcfg/get_ipaddress string fc00::2
#d-i netcfg/get_netmask string ffff:ffff:ffff:ffff::
#d-i netcfg/get_gateway string fc00::1
#d-i netcfg/get_nameservers string fc00::1
#d-i netcfg/confirm_static boolean true

d-i base-installer/kernel/override-image string linux-server

# Choices: Dialog, Readline, Gnome, Kde, Editor, Noninteractive
d-i debconf debconf/frontend select Noninteractive

d-i pkgsel/install-language-support boolean false
tasksel tasksel/first multiselect standard, ubuntu-server

#{{if .InstallDisk }}
#d-i partman-auto/disk string {{ .InstallDisk }}
#{{else}}
#d-i partman-auto/disk string /dev/sda
#{{end}}

d-i partman-auto/disk string /dev/sda
#d-i partman-auto/method string regular
d-i partman-auto/method string lvm
#d-i partman-auto/purge_lvm_from_device boolean true

d-i partman-lvm/confirm boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-auto/choose_recipe select atomic

d-i partman/confirm_write_new_label boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true

#http://ubuntu-virginia.ubuntuforums.org/showthread.php?p=9626883
#Message: "write the changes to disk and configure lvm preseed"
#http://serverfault.com/questions/189328/ubuntu-kickstart-installation-using-lvm-waits-for-input
#preseed partman-lvm/confirm_nooverwrite boolean true

# Write the changes to disks and configure LVM?
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/guided_size string max

## Default user, we can get away with a recipe to change this
d-i passwd/user-fullname string vagrant
d-i passwd/username string vagrant
d-i passwd/user-password password vagrant
d-i passwd/user-password-again password vagrant
d-i user-setup/encrypt-home boolean false
d-i user-setup/allow-password-weak boolean true

## minimum is puppet and ssh and ntp
# Individual additional packages to install
d-i pkgsel/include string openssh-server ntp curl

# Whether to upgrade packages after debootstrap.
# Allowed values: none, safe-upgrade, full-upgrade
d-i pkgsel/upgrade select full-upgrade

#{{if .InstallDisk }}
#d-i grub-installer/bootdev string {{ .InstallDisk }}
#{{else}}
#d-i grub-installer/bootdev string /dev/sda
#{{end}}

d-i grub-installer/bootdev string /dev/sda
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i finish-install/reboot_in_progress note

#For the update
d-i pkgsel/update-policy select none

# debconf-get-selections --install
#Use mirror
d-i apt-setup/use_mirror boolean true
d-i mirror/codename string trusty
d-i mirror/country string manual
d-i mirror/http/hostname string ftp.sunet.se
d-i mirror/http/directory string /pub/Linux/distributions/ubuntu/ubuntu
d-i mirror/http/proxy string
d-i mirror/protocol select http



# Once the installation is done we'll set the system up for some firstboot
# magic.
d-i preseed/late_command string chroot /target sh -c "/usr/bin/curl -o /tmp/postinstall http://boot.home.lan:8080/p/pxe/postinstall/postinstall && /bin/bash -x /tmp/postinstall"
