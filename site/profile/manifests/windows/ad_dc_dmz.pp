class profile::windows::ad_dc_dmz() {

  if $facts['msad_is_fsmo_pdc_role_owner'] == 'True' {
    # Setup AD Sites and Subnets
    windows_ad::site { 'Portland':
      description => 'Portland AD Site',
    } ->
    windows_ad::subnet { '192.168.50.0/24':
      location  => 'US/OR/Portland',
      site_name => 'Portland',
    }

    # Delete default topology
    windows_ad::site { 'Default-First-Site-Name':
      ensure => 'absent',
    }
    windows_ad::sitelink { 'DEFAULTIPSITELINK':
      ensure => 'absent',
    }

    # Setup DNS for forwarding to other domains
    windows_ad::dns::conditional_forwarder { 'internal.local':
      dns_servers => '192.168.0.11',
    }

    # Setup domain trusts
    windows_ad::trust::external { 'internal.local':
      direction => 'outbound',
      require => Windows_ad::Dns::Conditional_forwarder['internal.local'],
    }    
  }   
}
