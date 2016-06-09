class profile::network::base {
  require ciscopuppet::install
  include profile::network::base::snmp
  include profile::network::base::interfaces

  service { 'puppet':
    ensure => running,
    enable => true,
  }
}
