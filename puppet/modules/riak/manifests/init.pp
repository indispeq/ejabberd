class riak (

) inherits riak::params {
  class {'::riak::install': }->
  class {'::riak::config': }->
  class {'::riak::service': }
}
