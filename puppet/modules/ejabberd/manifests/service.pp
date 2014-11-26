class ejabberd::service inherits ejabberd {

  service { 'ejabberd':
    ensure => running,
    enable => true,
  }

}
