#
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at
# https://oss.oracle.com/licenses/upl.
#
# Since: July, 2018
# Author: gerald.venzl@oracle.com
# Description: Creates an Oracle database Vagrant virtual machine.
# Optional plugins:
#     vagrant-env (use .env files for configuration)
#     vagrant-proxyconf (if you don't have direct access to the Internet)
#         see https://github.com/tmatilai/vagrant-proxyconf for configuration
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Box metadata location and box name
BOX_URL = "https://oracle.github.io/vagrant-projects/boxes"
BOX_NAME = "ubuntu/jammy64"

# UI object for printing information
ui = Vagrant::UI::Prefixed.new(Vagrant::UI::Colored.new, "vagrant")

# Define constants
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Use vagrant-env plugin if available
  if Vagrant.has_plugin?("vagrant-env")
    config.env.load(".env.local", ".env") # enable the plugin
  end

  # VM name
  VM_NAME = default_s('VM_NAME', 'tfestudo-vagrant')

  # Memory for the VM (in MB, 2300 MB is ~2.25 GB)
  VM_MEMORY = default_i('VM_MEMORY', 2048)

  # VM time zone
  # If not specified, will be set to match host time zone (if possible)
  VM_SYSTEM_TIMEZONE = default_s('VM_SYSTEM_TIMEZONE', host_tz)

  # Save database installer RPM file for reuse when VM is rebuilt
  VM_KEEP_DB_INSTALLER = default_b('VM_KEEP_DB_INSTALLER', false)

  # Database character set
  VM_ORACLE_CHARACTERSET = default_s('VM_ORACLE_CHARACTERSET', 'AL32UTF8')

  # Listener port
  VM_LISTENER_PORT = default_i('VM_LISTENER_PORT', 1521)

  # Oracle Database password for SYS, SYSTEM and PDBADMIN accounts
  # If left blank, the password will be generated automatically
  VM_ORACLE_PWD = default_s('VM_ORACLE_PWD', '')
end

# Convenience methods
def default_s(key, default)
  ENV[key] && ! ENV[key].empty? ? ENV[key] : default
end

def default_i(key, default)
  default_s(key, default).to_i
end

def default_b(key, default)
  default_s(key, default).to_s.downcase == "true"
end

def host_tz
  # get host time zone for setting VM time zone
  # if host time zone isn't an integer hour offset from GMT, fall back to UTC
  offset_sec = Time.now.gmt_offset
  if (offset_sec % (60 * 60)) == 0
    offset_hr = ((offset_sec / 60) / 60)
    timezone_suffix = offset_hr >= 0 ? "-#{offset_hr.to_s}" : "+#{(-offset_hr).to_s}"
    'Etc/GMT' + timezone_suffix
  else
    'UTC'
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = BOX_NAME
  #config.vm.box_url = "#{BOX_URL}/#{BOX_NAME}.json"
  config.vm.define VM_NAME
  config.vm.box_check_update = false

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |v|
    v.memory = VM_MEMORY
    v.name = VM_NAME
    v.cpus = 2
  end
  config.vm.provider :libvirt do |v|
    v.memory = VM_MEMORY
  end

  # add proxy configuration from host env - optional
  if Vagrant.has_plugin?("vagrant-proxyconf")
    ui.info "Getting Proxy Configuration from Host..."
    has_proxy = false
    ["http_proxy", "HTTP_PROXY"].each do |proxy_var|
      if proxy = ENV[proxy_var]
        ui.info "HTTP proxy: " + proxy
        config.proxy.http = proxy
        has_proxy = true
        break
      end
    end

    ["https_proxy", "HTTPS_PROXY"].each do |proxy_var|
      if proxy = ENV[proxy_var]
        ui.info "HTTPS proxy: " + proxy
        config.proxy.https = proxy
        has_proxy = true
        break
      end
    end

    if has_proxy
      # Only consider no_proxy if we have proxies defined.
      no_proxy = ""
      ["no_proxy", "NO_PROXY"].each do |proxy_var|
        if ENV[proxy_var]
          no_proxy = ENV[proxy_var]
          ui.info "No proxy: " + no_proxy
          no_proxy += ","
          break
        end
      end
      config.proxy.no_proxy = no_proxy + "localhost,127.0.0.1"
    end
  else
    ["http_proxy", "HTTP_PROXY", "https_proxy", "HTTPS_PROXY"].each do |proxy_var|
      if ENV[proxy_var]
        ui.warn 'To enable proxies in your VM, install the vagrant-proxyconf plugin'
        break
      end
    end
  end

  # VM hostname
  # must be "localhost", or listener configuration will fail
  config.vm.hostname = "tfestudo"

  # Oracle port forwarding
  #config.vm.network "forwarded_port", guest: VM_LISTENER_PORT, host: VM_LISTENER_PORT
  config.vm.network "public_network", ip: "192.168.1.120", bridge: "wlp3s0"


  # Provision everything on the first run

  #config.vm.provision "shell", path: "mongo-bootstrap.sh"

  #config.vm.provision "shell", path: "scripts/install.sh", env:
  #  {
  #     "SYSTEM_TIMEZONE"     => VM_SYSTEM_TIMEZONE,
  #     "KEEP_DB_INSTALLER"   => VM_KEEP_DB_INSTALLER,
  #     "ORACLE_CHARACTERSET" => VM_ORACLE_CHARACTERSET,
  #     "LISTENER_PORT"       => VM_LISTENER_PORT,
  #     "ORACLE_PWD"          => VM_ORACLE_PWD
  #  }

end