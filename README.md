Ansible Role :signal_strength: :cyclone: :incoming_envelope: Fluentd
=========
[![Galaxy Role](https://img.shields.io/ansible/role/45215.svg)](https://galaxy.ansible.com/0x0I/fluentd)
[![Downloads](https://img.shields.io/ansible/role/d/45215.svg)](https://galaxy.ansible.com/0x0I/fluentd)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-fluentd.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-fluentd)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
      - [Install](#install)
      - [Config](#config)
      - [Launch](#launch)
      - [Uninstall](#uninstall)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Ansible role that installs and configures Fluentd, a unified and scalable logging and data collection service.

##### Supported Platforms:
```
* Debian
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

...*description of provisioning requirements*...

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_
* _uninstall_

#### Install

...*description of installation related vars*...

#### Config

...*description of configuration related vars*...

#### Launch

...*description of service launch related vars*...

#### Uninstall

...*description of uninstallation related vars*...

Dependencies
------------

...*list dependencies*...

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.fluentd
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
