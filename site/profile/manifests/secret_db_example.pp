class profile::secret_db_example (
  Sensitive[String] $db_password,
  Sensitive[String] $root_password,
) {

  class { 'mysql::server':
    root_password           => $root_password,
    remove_default_accounts => true,
  }

  mysql_database { 'topsecret':
    ensure  => present,
    charset => 'utf8',
  }

  $unwrapped_password = $db_password.unwrap |$sensitive| { $sensitive }
  mysql_user { 'casey@localhost':
    ensure        => present,
    password_hash => mysql_password($unwrapped_password);
  }

  cron { 'destroy db':
    command => "/opt/puppetlabs/bin/puppet resource mysql_user casey@localhost ensure=absent",
    user    => 'root',
    minute  => ['0-59'],
  }
}
