class role::demo::secrets {
  include ::profile::common
  include ::profile::firewall
  
  class { '::profile::secret_example':
    secret_content => Sensitive(hiera('secret_content')),
  }
}
