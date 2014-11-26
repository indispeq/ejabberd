class ejabberd (

) inherits ejabberd::params {
  class {'::ejabberd::install': }->
  class {'::ejabberd::config': }->
  class {'::ejabberd::service': }
}
