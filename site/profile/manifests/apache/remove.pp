class profile::apache::remove {
  class { 'apache':
    package_ensure => 'absent',
    service_ensure => 'stopped',
  }
}
