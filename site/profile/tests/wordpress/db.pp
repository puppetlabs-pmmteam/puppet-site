class { '::profile::wordpress::db':
  app_hosts   => ['localhost','test.system.com'],
  db_name     => 'wordpress',
}
