class profile::network::base::snmp {

  cisco_snmp_server { 'default':
    aaa_user_cache_timeout => 200,
    global_enforce_priv    => true,
  }

  cisco_snmp_group { 'network-admin':
    ensure => present,
  }

  cisco_snmp_community { 'setcom':
    ensure => present,
    group  => 'network-admin',
    acl    => 'testcomacl',
  }

  cisco_snmp_user { 'v3test':
    ensure => present,
    groups => ['network-admin'],
  } 
}
