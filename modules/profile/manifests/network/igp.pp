class profile::network::igp (
  $ensure = present,
) {
  class { 'profile::network::igp::ospf':
    ensure => $ensure,
  }
}
