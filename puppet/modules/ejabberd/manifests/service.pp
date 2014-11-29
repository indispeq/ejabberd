class ejabberd::service inherits ejabberd {

  service { 'ejabberd':
    ensure  => running,
    enable  => true,
    require => File['/opt/ejabberd'],
  }

}
