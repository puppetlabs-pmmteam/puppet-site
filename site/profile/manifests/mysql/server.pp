class profile::mysql::server {
  include profile::mysql::client

  class { 'mysql::server':
    override_options   => {
      'mysqld' => {
        'bind-address' => '0.0.0.0',
      }
    },
  }
}
