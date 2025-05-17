# My linux setup (ubuntu-based)

## Setup a fresh ubuntu install
If you are on an old ubuntu version, consider upgrading to the current version (24.04+ LTS)

```shell
sudo apt update

sudo apt upgrade

sudo apt dist-upgrade

sudo apt install update-manager-core

sudo reboot
```

Once the updates are done and reboot is complete, start the upgrade (this will be a time consuming step)

```shell
sudo do-release-upgrade
```

As the `do-release-upgrade` command executes, you will be prompted a couple of times to confirm if you are going ahead with the installation/ upgrade.
Once you confirm, there is no turning back and hence it is recommended that you create a good backup of your system.


## Installing applications and configuring look and feel
This part draws a lot of inspiration from https://github.com/basecamp/omakub specifically on themes, customizations, application installation scripts and configurations.
This repo is a minimized set-up and may draw your interest, if you'd like a minimal linux setup.


