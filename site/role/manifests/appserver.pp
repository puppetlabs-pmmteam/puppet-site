class role::appserver {
  include profile::common
  include profile::apache
  include profile::mysql::client
  include profile::git

  Class['profile::common'] -> Class['profile::apache']
}
