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

Requires the `unzip/gtar` utility to be installed on the target host. See ansible `unarchive` module [notes](https://docs.ansible.com/ansible/latest/modules/unarchive_module.html#notes) for details.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_

#### Install

`fluentd`can be installed using OS package management systems (e.g `apt`, `yum`) or as a stand-alone Ruby gem obtained from the official Ruby community gem hosting site.

_The following variables can be customized to control various aspects of this installation process, ranging from software version and source location of binaries to the installation type (and ultimately, installation directory where they are stored):_

`install_type: <package | gem>` (**default**: gem)
- **package**: maintained by the Treasure Data organization for Debian and Redhat distributions, package installation of `fluentd` pulls the specified package from the respective package `td-agent` management repository. See `fluentd`'s official [installation guide](https://docs.fluentd.org/installation) for more details.
  - Note that the installation directory is determined by the package management system and currently defaults to `/opt/td-agent` for both distros.
- **gem**: installs fluentd gem from the offical Ruby gems community hosting site, [rubygems.org](https://rubygems.org).

`gem_version: <string>` (**default**: `1.7.4`)
- version of `fluentd` gem to install. Reference [here](https://rubygems.org/gems/fluentd) for a list of available versions. *ONLY* relevant when `install_type` is set to **gem**

`package_url: <path-or-url-to-package>` (**default**: see `defaults/main.yml`)
- address of a **Debian or RPM** package containing `td-agent` source and binaries.

Note that the installation layout is determined by the package management systems. Consult Fluentd's official documentation for both [RPM](https://docs.fluentd.org/installation/install-by-rpm) and [Debian](https://docs.fluentd.org/installation/install-by-deb) installation details. *ONLY* relevant when `install_type` is set to **package**

`plugins: <list-of-strings>` (**default**: `[]`)
- list of `fluentd` plugins to install. See `fluentd`'s [community](https://www.fluentd.org/plugins) site for the set of available plugins.

#### Config

Configuration of `fluentd` is expressed within a single configuration file, *fluentd.conf or td-agent.conf (depending on install type)*. By default, the file is located in a designated config directory determined by the installation type though it's location can be customized by setting the environment variable `FLUENT_CONF` within the services execution environment to the desired location.

The configuration file allows the user to control the input and output behavior of Fluentd by (1) selecting input and output plugins and (2) specifying the plugin parameters. It is required for Fluentd to operate properly.

See `fluentd`'s official [configuration guide](https://docs.fluentd.org/configuration) for more details.

_The following variable can be customized to manage the content of this configuration file and others to included by the **@include** directive:_

`config: <list-of-plugin-settings-hashes>` **default**: {}

- `{fluent|td-agent}.conf` consists of specifications of fluentd plugins, which manage various aspects or directives of the log and data ingestion process. These directives are as follows:
   - **source**: determine the input sources.
   - **match**: determine the output destinations.
   - **filter**: determine the event processing pipelines.
   - **system**: set system wide configuration.
   - **label**: group the output and filter for internal routing
   - **@include**: include other files

Utilizing this role, each directive to be rendered in the default configuration file or any included by the **@include** directive is fully expressible via two forms, either a hash of directive attributes or a single `content` key with a value representing an actual directive definition. See below for examples.

#### Example
```yaml
config:
  - directives:
    - comment: Directive specified by attributes -- Listen on localhost:2411 for source data injections
      plugin: source
      attributes:
        "@type": http
        "@id": example
        port: 2411
    - comment: Directive specified by content field -- Add hostname where data was emitted from
      plugin: filter
      content: |
        <filter example>
          @type record_transformer
          <record>
            hostname "#{Socket.gethostname}"
          </record>
        </filter>
    - plugin: match
      match: "test.*"
      attributes:
        "@type": stdout
```
`[config: {list-entry} :] name: <string>` (**default**: *fluentd | td-agent*)
- [optional] As previously mentioned, the **@include** directive allows configuration files to be loaded from locations across the host file-system. This parameter represents the name of the configuration file to render a set of directives (to follow) in as well as the name of the file that would be a part of such an **@include**.

`[config: {list-entry} :] path: <string>` (**default**: */etc/fluentd | /etc/td-agent*)
- [optional] In the same sense, this parameter represents the path to the configuration file on the local host.

`[config: {list-entry} :] directives: <list-of-hashes>` (**default**: *none*)
- list of directive hashes to render in the configuration file specified by the above parameters.

`[config: {list-entry} : directives: {list-entry}:] comment: <string>` (**default**: *none*)
- comment associated with plugin directive

`[config: {list-entry} : directives: {list-entry}:] plugin: <string>` (**default**: *none*)
- type of plugin directive

`[config: {list-entry} : directives: {list-entry}:] attributes: <hash>` (**default**: *none*)
- directive specific attributes to include in definition. See `fluentd`'s official [built-in](https://docs.fluentd.org/input) or [community](https://www.fluentd.org/plugins) sites for the set of available attributes for each plugin.

`[config: {list-entry} : directives: {list-entry}:] content: <string>` (**default**: *none*)
- [optional] actual representation of the directive definition. Value can contain YAML formatting as appropriate.

#### Launch

Running the `fluentd` data collector is accomplished utilizing the [systemd](https://www.freedesktop.org/wiki/Software/systemd/) service management tool for both *package* and *gem* installations. Launched as background processes or daemons subject to the configuration and execution potential provided by the underlying management framework, launch of `fluentd` can be set to adhere to system administrative policies right for your environment and organization.

_The following variables can be customized to manage the service's **systemd** service unit definition and execution profile/policy:_

`extra_run_args: <elasticsearch-cli-options>` (**default**: `[]`)
- list of `fluentd` commandline arguments to pass to the binary at runtime for customizing launch. Supporting full expression of `fluentd`'s cli, this variable enables the launch to be customized according to the user's specification.

`custom_unit_properties: <hash-of-systemd-service-settings>` (**default**: `[]`)
- hash of settings used to customize the [Service] unit configuration and execution environment of the Fluentd **systemd** service.

```yaml
custom_unit_properties:
  Environment: "FLUENT_CONF={{ /path/to/custom/config.conf }}"
  LimitNOFILE: infinity
```

Reference the [systemd.service](http://man7.org/linux/man-pages/man5/systemd.service.5.html) *man* page for a configuration overview and reference.

Dependencies
------------

- 0x0i.systemd

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.fluentd
```

...:
```
- hosts: all
  roles:
    - role: 0xOI.fluentd
      vars:
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
