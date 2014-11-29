class ejabberd::install inherits ejabberd {
  include wget

#  wget::fetch { 'download-ejabberd-binary':
#    source      => 'http://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/14.07/ejabberd-14.07-linux-x86_64-installer.run',
#    destination => '/tmp/ejabberd-14.07-linux-x86_64-installer.run',
#    timeout     => 0,
#    verbose     => false,
#  }

  wget::fetch { 'download-ejabberd-source':
    source      => 'http://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/14.07/ejabberd-14.07.tgz',
    destination => '/root/ejabberd-14.07.tgz',
    timeout     => 0,
    verbose     => false,
  }

#  file { '/tmp/ejabberd-14.07-linux-x86_64-installer.run':
#    mode    => '0770',
#    require => Wget::Fetch['download-ejabberd-binary'],
#  }
#  exec { 'unattended-ejabberd-install':
#    cwd     => '/tmp',
#    command => '/tmp/ejabberd-14.07-linux-x86_64-installer.run --mode unattended --adminpw changeme',
#    require => File['/tmp/ejabberd-14.07-linux-x86_64-installer.run'],
#    creates => '/opt/ejabberd-14.07',
#  }

  $ejabberd_packages = [ 'build-essential', 'autoconf', 'libyaml-dev', 'zlib1g-dev', 'libpam0g-dev', 'libexpat1-dev', 'erlang-dev', 'erlang-eunit', 'erlang-parsetools', 'imagemagick', 'libssl-dev', 'erlang-nox']

  package { $ejabberd_packages :
    ensure => installed,
  }

  exec { 'ejabberd-source-install':
    cwd     => '/root',
    command => "/usr/bin/sudo su - root -c 'cd /root && /bin/tar xvzf ejabberd-14.07.tgz && cd ejabberd-14.07 && ./configure --enable-user=ejabberd --enable-zlib --prefix=/opt/ejabberd && /usr/bin/make && /usr/bin/make install'",
    require => [ Wget::Fetch['download-ejabberd-source'], User['ejabberd'], Package[$ejabberd_packages] ],
      creates => '/opt/ejabberd',
  }

  file { '/opt/ejabberd':
    owner     => 'ejabberd',
    recurse   => true,
    require   => Exec['ejabberd-source-install'],
  }

#  exec { 'copy-init-script':
#    command => '/bin/cp /opt/ejabberd-14.07/bin/ejabberd.init /etc/init.d/ejabberd',
#    require => Exec['unattended-ejabberd-install'],
#    creates => '/etc/init.d/ejabberd',
#  }

  exec { 'copy-init-script':
    command => '/bin/cp /root/ejabberd-14.07/ejabberd.init /etc/init.d/ejabberd',
    require => Exec['ejabberd-source-install'],
    creates => '/etc/init.d/ejabberd',
  }

  file { '/etc/init.d/ejabberd':
    mode => '0755',
    require => Exec['copy-init-script'],
  }

  user { 'ejabberd':
    ensure     => present,
    system     => true,
    home       => '/opt/ejabberd',
  }

#  exec { 'ejabberdctl-installuser':
#    command => "/bin/sed -i 's/^INSTALLUSER=root/INSTALLUSER=ejabberd/' /opt/ejabberd-14.07/bin/ejabberdctl",
#    require => File['/opt/ejabberd-14.07'],
#    onlyif  => "/bin/grep -c 'INSTALLUSER=root' /opt/ejabberd-14.07/bin/ejabberdctl",
#  }


}
