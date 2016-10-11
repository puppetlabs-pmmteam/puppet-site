class role::demo::secrets {
  include ::profile::common
  include ::profile::firewall
  include ::profile::corrective_change_example
  
  class { '::profile::secret_example':
    secret_content => Sensitive(hiera('secret_content')),
  }
}
