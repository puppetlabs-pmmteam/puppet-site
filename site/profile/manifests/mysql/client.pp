class profile::mysql::client {
  class { 'mysql::client': }
  class { 'mysql::bindings::php': }
}
