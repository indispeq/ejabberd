include packagecloud

  packagecloud::repo { "basho/riak":
   type => 'deb',  # or "deb" or "gem"
  }->

  package { 'riak':
    ensure => installed,
  }

  service { 'riak':
    ensure  => running,
    enable  => true,
    require => Package['riak'],
  }

  augeas { 'riak-conf':
    lens    => 'Simplevars.lns',
    incl    => '/etc/riak/riak.conf',
    changes => [
      "set storage_backend leveldb",
    ],
    notify  => Service['riak'],
    require => Package['riak'],
  }
