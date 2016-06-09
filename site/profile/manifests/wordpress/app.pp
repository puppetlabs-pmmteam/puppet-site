class profile::wordpress::app(
  $install_dir = '/opt/wordpress',
  $db_host = query_nodes('Class[profile::wordpress::db]', fqdn),
  $db_name,
  $db_user,
  $db_password,
) {
  $db_host_real = $db_host[0]

  include ::mysql::client

  class { 'apache':
    default_vhost => false,
  }

  class { '::apache::mod::php': }

  apache::vhost { $::fqdn:
    docroot => $install_dir,
    port    => 80,
  }

  apache::listen { '80': }

  class { '::mysql::bindings::php':
    notify => Class['::apache'],
  }

  class { '::wordpress':
    create_db      => false,
    create_db_user => false,
    db_user        => $db_user,
    db_password    => $db_password,
    db_host        => $db_host_real,
  }

  firewall { '00 Allow inbound http requests':
    proto  => 'tcp',
    action => 'accept',
    port   => '80',
  }

  @@mysql_user { "${db_user}@${::fqdn}":
    ensure        => present,
    password_hash => mysql_password($db_password),
  }

  @@mysql_grant { "${db_user}@${::fqdn}/${db_name}.*":
    privileges => ['SELECT','GRANT'],
    table      => "${db_name}.*",
    user       => "${db_user}@${::fqdn}",
  }
}
