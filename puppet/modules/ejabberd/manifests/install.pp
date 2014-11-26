class ejabberd::install inherits ejabberd {
  include wget

  wget::fetch { 'download-ejabberd-binary':
    source      => 'http://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/14.07/ejabberd-14.07-linux-x86_64-installer.run',
    destination => '/tmp/ejabberd-14.07-linux-x86_64-installer.run',
    timeout     => 0,
    verbose     => false,
  }

  file { '/tmp/ejabberd-14.07-linux-x86_64-installer.run':
    mode    => '0770',
    require => Wget::Fetch['download-ejabberd-binary'],
  }

  exec { 'unattended-ejabberd-install':
    cwd     => '/tmp',
    command => '/tmp/ejabberd-14.07-linux-x86_64-installer.run --mode unattended --adminpw changeme',
    require => File['/tmp/ejabberd-14.07-linux-x86_64-installer.run'],
    creates => '/opt/ejabberd-14.07',
  }

  file { '/opt/ejabberd-14.07':
    ensure    => directory,
    owner     => 'ejabberd',
    recurse   => true,
    require   => Exec['unattended-ejabberd-install'],
  }

  exec { 'copy-init-script':
    command => '/bin/cp /opt/ejabberd-14.07/bin/ejabberd.init /etc/init.d/ejabberd',
    require => Exec['unattended-ejabberd-install'],
    creates => '/etc/init.d/ejabberd',
  }

  file { '/etc/init.d/ejabberd':
    mode => '0755',
    require => Exec['copy-init-script'],
  }

  user { 'ejabberd':
    ensure => present,
    system => true,
    managehome => true,
  }

  exec { 'ejabberdctl-installuser':
    command => "/bin/sed -i 's/^INSTALLUSER=root/INSTALLUSER=ejabberd/' /opt/ejabberd-14.07/bin/ejabberdctl",
    require => File['/opt/ejabberd-14.07'],
    onlyif  => "/bin/grep -c 'INSTALLUSER=root' /opt/ejabberd-14.07/bin/ejabberdctl",
  }


}
