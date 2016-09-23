class profile::windows::ad_dc_internal(
  $applications_ou_name = hiera('profile::windows::ad_dc_internal::applications_ou_name'),
) {

  if $facts['msad_is_fsmo_pdc_role_owner'] == 'True' {
    $x500_domain_name = "DC=${regsubst($facts['msad_domain_name'],'\.',',DC=')}"

    # Setup AD Sites and Subnets
    windows_ad::site { 'Portland':
      description => 'Portland AD Site',
    } ->
    windows_ad::subnet { '192.168.0.0/24':
      location  => 'US/OR/Portland',
      site_name => 'Portland',
    }

    windows_ad::site { 'SanDiego':
      description => 'SanDiego AD Site',
    } ->
    windows_ad::subnet { '192.168.100.0/24':
      location  => 'US/CA/San Diego',
      site_name =>  'SanDiego',
    }

    # Setup AD Site Links
    windows_ad::sitelink { 'Portland-SanDiego':
      sites => 'Portland,SanDiego',
      cost => 50,
      require => [Windows_ad::Site['SanDiego'],Windows_ad::Site['Portland']],
    }

    # Delete default topology
    windows_ad::site { 'Default-First-Site-Name':
      ensure => 'absent',
    }
    windows_ad::sitelink { 'DEFAULTIPSITELINK':
      ensure => 'absent',
    }

    # Setup DNS for forwarding to other domains
    windows_ad::dns::conditional_forwarder { 'dmz.local':
      dns_servers => '192.168.50.50',
    }

    # Setup domain trusts
    windows_ad::trust::external { 'dmz.local':
      direction => 'inbound',
      require => Windows_ad::Dns::Conditional_forwarder['dmz.local'],
    }

    # Create Application OU structure
    dsc_xadorganizationalunit { 'ad_dc_applications_ou':
      ensure => present,
      dsc_name => $applications_ou_name,
      dsc_path => $x500_domain_name,
      dsc_description => 'Location for application support objects',
    }    
  }   
}
