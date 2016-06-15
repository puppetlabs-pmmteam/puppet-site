class profile::apache {
  class { 'apache':
    default_vhost => false,
  }

  class { 'apache::mod::php': }
}
