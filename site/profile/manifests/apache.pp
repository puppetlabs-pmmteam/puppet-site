class profile::apache(
  $default_vhost = false
) {
  class { 'apache':
    default_vhost => $default_vhost,
  }

  class { 'apache::mod::php': }
}
