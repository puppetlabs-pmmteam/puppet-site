class profile::windows::cloudshop_app_groups(
  $applications_ou_name = hiera('profile::windows::ad_dc_internal::applications_ou_name'),
) {

  if $facts['msad_is_fsmo_pdc_role_owner'] == 'True' {
    $x500_domain_name = "DC=${regsubst($facts['msad_domain_name'],'\.',',DC=')}"
    $x500_applications_ou = "OU=${applications_ou_name},${x500_domain_name}"

    $application_name = 'CloudShop'
    $x500_this_app_ou_name = "OU=${application_name},${x500_applications_ou}"

    # Create application OU structure
    dsc_xadorganizationalunit { 'ad_dc_applications_cloudshop_ou':
      ensure          => 'present',
      dsc_name        => $application_name,
      dsc_path        => $x500_applications_ou,
      dsc_description => 'Location for CloudShop application support objects',
      require         => Dsc_xadorganizationalunit['ad_dc_applications_ou'],
    }
    
    # Create the application groups
    dsc_xadgroup { 'CloudShopWebAdmins':
      dsc_ensure => 'present',
      dsc_groupname => 'CloudShopWebAdmins',
      dsc_category => 'Security',
      dsc_groupscope => 'Global',
      dsc_path => $x500_this_app_ou_name,
      require => Dsc_xadorganizationalunit['ad_dc_applications_cloudshop_ou'],
    }
    dsc_xadgroup { 'CloudShopSQLAdmins':
      dsc_ensure => 'present',
      dsc_groupname => 'CloudShopSQLAdmins',
      dsc_category => 'Security',
      dsc_groupscope => 'Global',
      dsc_path => $x500_this_app_ou_name,
      require => Dsc_xadorganizationalunit['ad_dc_applications_cloudshop_ou'],
    }
  }   
}
