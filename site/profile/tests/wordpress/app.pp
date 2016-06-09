class { '::profile::wordpress::app':
  db_host     => ['localhost'],
  db_name     => 'wordpress',
  db_user     => 'wordpress',
  db_password => 'wordpress',
}
