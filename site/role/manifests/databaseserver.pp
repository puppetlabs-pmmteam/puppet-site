class role::databaseserver {
  include profile::common
  include profile::git
  include profile::mysql::server
}
