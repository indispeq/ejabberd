#!/bin/bash

apt-get update && apt-get install -y ruby-dev build-essential git
puppet module install computology-packagecloud --target-dir /vagrant/puppet/modules
puppet module install maestrodev-wget --target-dir /vagrant/puppet/modules
