class riak::config inherits riak {

  augeas { 'riak-conf':
    lens    => 'Simplevars.lns',
    incl    => '/etc/riak/riak.conf',
    changes => [
      "set storage_backend leveldb",
    ],
    notify  => Service['riak'],
    require => Package['riak'],
  }

}
