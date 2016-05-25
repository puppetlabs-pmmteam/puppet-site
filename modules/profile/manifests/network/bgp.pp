class profile::network::bgp(
  $neighbor,
  $clusterid,
  $routerid = $::ipaddress,
  $network = undef,
) {

  if $network {
    $network_real = $network
  } else {
    $cidr_mask = cidr_mask($::netmask)
    $network_real = "${::network}/${cidr_mask}"
  }

  # --------------------------------------------------------------------------#
  # Configure Global BGP                                                      #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp':
  command => "
    router bgp 55
      shutdown
      router-id ${routerid}
      cluster-id ${clusterid}
      timers bgp 33 190
      timers bestpath-limit 44 always
      graceful-restart-helper
      graceful-restart restart-time 55
      graceful-restart stalepath-time 55
      confederation identifier 50
      confederation peers 327686 327685 200608 5000 6000 32 43
      bestpath as-path multipath-relax
      bestpath cost-community ignore
      bestpath compare-routerid
      bestpath med confed
      bestpath med non-deterministic
      bestpath always-compare-med
      reconnect-interval 22
      suppress-fib-pending
      neighbor-down fib-accelerate
      log-neighbor-changes",
  }

  # --------------------------------------------------------------------------#
  # Configure Address Family IPv4 Unicast                                     #
  #  Requires: cisco_bgp (Global BGP)                                         #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_af':
  command   => "
    router bgp 55
      address-family ipv4 unicast
        timers bestpath-defer 302 maximum 3001
        dampening 30 4 30 200
        network ${network_real} route-map twomap
        redistribute ospf 30 route-map ospf_map
        redistribute isis 3 route-map isis_map
        redistribute eigrp 1 route-map eigrp_map
        aggregate-address 10.25.25.0/24
        maximum-paths 8
        maximum-paths ibgp 6
        nexthop route-map nhrp_map
        no client-to-client reflection
        default-information originate
        dampen-igp-metric 60
        additional-paths send
        additional-paths receive
        additional-paths selection route-map foo_bar
        additional-paths install backup",
    require => Cisco_command_config['cisco_bgp'],
  }

  # --------------------------------------------------------------------------#
  # Configure Non-Default VRF Address Family IPv4 Unicast                     #
  #  Requires: cisco_bgp (Global BGP)                                         #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_af_ipv4vrf':
  command   => "
    router bgp 55
      vrf ipv4vrf
        address-family ipv4 unicast
          timers bestpath-defer 302 maximum 3001
          dampening 30 4 30 200
          network ${network_real} route-map twomap
          redistribute ospf 30 route-map ospf_map
          redistribute isis 3 route-map isis_map
          redistribute eigrp 1 route-map eigrp_map
          aggregate-address 10.25.25.0/24
          maximum-paths 8
          maximum-paths ibgp 6
          nexthop route-map nhrp_map
          no client-to-client reflection
          default-information originate
          dampen-igp-metric 60
          additional-paths send
          additional-paths receive
          additional-paths selection route-map foo_bar
          additional-paths install backup",
    require => Cisco_command_config['cisco_bgp'],
  }

  # --------------------------------------------------------------------------#
  # Configure IPv4 Neighbor                                                   #
  #  Requires: cisco_bgp (Global BGP)                                         #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_neighbor':
  command   => "
    router bgp 55
      neighbor ${neighbor}
        bfd
        inherit peer peer_template_one
        remote-as 24
        description 'one dot one'
        password 0 bgppassword 
        update-source Ethernet1/1
        remove-private-as all",
    require => Cisco_command_config['cisco_bgp'],
  }

  # --------------------------------------------------------------------------#
  # Configure IPv4 Neighbor Address Family IPv4 Unicast                       #
  #  Requires: cisco_bgp_neighbor (IPv4 Neighbor)                             #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_v4_neighbor_afv4':
  command   => "
    router bgp 55
      neighbor ${neighbor}
        address-family ipv4 unicast
          allowas-in
          no disable-peer-as-check
          no route-reflector-client
          weight 40
          maximum-prefix 3 90 restart 4
          next-hop-self",
    require => Cisco_command_config['cisco_bgp_neighbor'],
  }

  # --------------------------------------------------------------------------#
  # Configure Non-Default VRF IPv4 Neighbor Address Family IPv4 Unicast       #
  #  Requires: cisco_bgp_neighbor (IPv4 Neighbor)                             #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_v4_neighbor_afv4_nondefault':
  command   => "
    router bgp 55
      vrf nondefault
        neighbor ${neighbor}
          address-family ipv4 unicast
            allowas-in
            no disable-peer-as-check
            no route-reflector-client
            weight 40
            maximum-prefix 3 90 restart 4
            next-hop-self",
    require => Cisco_command_config['cisco_bgp_neighbor'],
  }

  # --------------------------------------------------------------------------#
  # Configure IPv4 Neighbor Address Family IPv6 Unicast                       #
  #  Requires: cisco_bgp_neighbor (IPv4 Neighbor)                             #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_v4_neighbor_afv6':
  command   => "
    router bgp 55
      neighbor ${neighbor}
        address-family ipv6 unicast
          allowas-in
          no disable-peer-as-check
          no route-reflector-client
          weight 40
          maximum-prefix 3 90 restart 4",
    require => Cisco_command_config['cisco_bgp_neighbor'],
  }

  # --------------------------------------------------------------------------#
  # Configure Non-Default VRF IPv4 Neighbor Address Family IPv6 Unicast       #
  #  Requires: cisco_bgp_neighbor (IPv4 Neighbor)                             #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'cisco_bgp_v4_neighbor_afv6_nondefault':
  command   => "
    router bgp 55
      vrf nondefault
        neighbor ${neighbor}
          address-family ipv6 unicast
            allowas-in
            no disable-peer-as-check
            no route-reflector-client
            weight 40
            maximum-prefix 3 90 restart 4",
    require => Cisco_command_config['cisco_bgp_neighbor'],
  }

  # --------------------------------------------------------------------------#
  # Enable BGP Feature                                                        #
  #  Before: cisco_bgp (Global BGP)                                           #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'bgp_enable':
    command => "
      feature bgp",
    before  => Cisco_command_config['cisco_bgp'],
  }

  # --------------------------------------------------------------------------#
  # Enable BFD Feature                                                        #
  #  Before: cisco_bgp_neighbor (IPv4 Neighbor)                               #
  # --------------------------------------------------------------------------#
  cisco_command_config { 'bfd_enable':
    command => "
      feature bfd",
    before  => Cisco_command_config['cisco_bgp_neighbor'],
  }
}
