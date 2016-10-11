class profile::secret_db_example (
  Sensitive[String] $db_password,
) {

  class { 'mysql::server':
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
