class riak::install inherits riak {

  include packagecloud

  packagecloud::repo { "basho/riak":
   type => 'deb',  # or "deb" or "gem"
  }->

  package { 'riak':
    ensure => installed,
  }


}
