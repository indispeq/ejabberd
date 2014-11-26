class riak::service inherits riak {

  service { 'riak':
    ensure  => running,
    enable  => true,
    require => Package['riak'],
  }


}
