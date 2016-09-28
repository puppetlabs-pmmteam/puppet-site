class role::rgbank::web {
  include profile::apache
  include profile::docker
  include profile::mysql::client
  include profile::rgbank::web
}
