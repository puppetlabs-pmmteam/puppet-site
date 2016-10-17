class role::demo::web {
  include ::profile::common
  include ::profile::pe_env
  include ::profile::firewall
  
  class { '::profile::wordpress':
    db_password => Sensitive(hiera('profile::wordpress::db_password')),
  }
}
