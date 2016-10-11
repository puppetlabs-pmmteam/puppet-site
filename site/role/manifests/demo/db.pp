class role::demo::db {
  include ::profile::common
  include ::profile::pe_env
  include ::profile::firewall

  class { '::profile::secret_db_example':
    db_password   => Sensitive(hiera('secret_db_password')),
  }
}
