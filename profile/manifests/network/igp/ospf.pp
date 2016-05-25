class profile::network::igp::ospf (
  $ensure = present,
) {
  cisco_ospf { 'Sample':
    ensure => $ensure,
  }

  $md_password = '046E1803362E595C260E0B240619050A2D'
  cisco_interface_ospf { 'Ethernet1/1 Sample':
    ensure                         => $ensure,
    area                           => 200,
    cost                           => '200',
    hello_interval                 => 'default',
    dead_interval                  => '200',
    message_digest                 => true,
    message_digest_key_id          => 30,
    message_digest_algorithm_type  => md5,
    message_digest_encryption_type => cisco_type_7,
    message_digest_password        => $md_password,
    passive_interface              => true,
  }

  cisco_ospf_vrf { 'dark_blue default':
    ensure                   => $ensure,
    auto_cost                => '44000',
    default_metric           => '5',
    log_adjacency            => 'detail',
    timer_throttle_lsa_hold  => '5500',
    timer_throttle_lsa_max   => '5600',
    timer_throttle_lsa_start => '5',
    timer_throttle_spf_hold  => '1500',
    timer_throttle_spf_max   => '5500',
    timer_throttle_spf_start => '250',
  }

  cisco_ospf_vrf { 'dark_blue vrf1':
    ensure                   => $ensure,
    auto_cost                => '46000',
    default_metric           => '10',
    log_adjacency            => 'log',
    timer_throttle_lsa_hold  => '5600',
    timer_throttle_lsa_max   => '5800',
    timer_throttle_lsa_start => '8',
    timer_throttle_spf_hold  => '1700',
    timer_throttle_spf_max   => '5700',
    timer_throttle_spf_start => '277',
  }

  cisco_ospf_vrf { 'app_network':
    ensure                   => $ensure,
    auto_cost                => '47000',
    default_metric           => '10',
    log_adjacency            => 'log',
    timer_throttle_lsa_hold  => '5600',
    timer_throttle_lsa_max   => '5800',
    timer_throttle_lsa_start => '10',
    timer_throttle_spf_hold  => '1700',
    timer_throttle_spf_max   => '5700',
    timer_throttle_spf_start => '260',
  }
}
