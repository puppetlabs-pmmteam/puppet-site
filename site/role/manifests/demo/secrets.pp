class role::demo::secrets {
  include ::profile::common
  include ::profile::firewall
  
  
  class { '::profile::secret_example':
    db_password => Sensitive(hiera('secret_content')),
  }
}
