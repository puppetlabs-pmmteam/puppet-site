class profile::apache::remove {
  class { 'apache':
    package_ensure => 'uninstalled',
    service_ensure => 'stopped',
  }
}
