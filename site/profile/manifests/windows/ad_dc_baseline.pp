class profile::windows::ad_dc_baseline() {

  if $facts['msad_is_fsmo_pdc_role_owner'] == 'True' {
    # Derive the x500 path from the DNS path
    $x500_domain_name = "DC=${regsubst($facts['msad_domain_name'],'\.',',DC=')}"

    # These resources are only applied on the PDC so that only one DC is managing this from a Puppet
    # perspective.  Otherwise we could end up with a replication issue

    # Create skeleton OU structure
    dsc_xadorganizationalunit { 'ad_dc_user_accounts_ou':
      ensure => present,
      dsc_name => 'User Accounts',
      dsc_path => $x500_domain_name,
      dsc_description => 'Location for user account objects',
    }
    
    dsc_xadorganizationalunit { 'ad_dc_server_accounts_ou':
      ensure => present,
      dsc_name => 'Servers',
      dsc_path => $x500_domain_name,
      dsc_description => 'Location for server computer objects',
    }
    
    dsc_xadorganizationalunit { 'ad_dc_workstation_accounts_ou':
      ensure => present,
      dsc_name => 'Workstations',
      dsc_path => $x500_domain_name,
      dsc_description => 'Location for workstation computer objects',
    }

    dsc_xaddomaindefaultpasswordpolicy { 'ad_dc_password_policy':
      # Super Low Security Password Policy
      ensure => present,
      dsc_domainname => $facts['msad_domain_name'],
      dsc_lockoutthreshold => 0, # 0 = disabled
      dsc_maxpasswordage => 0, # 0 = never expire
      dsc_passwordhistorycount => 0, # 0 = don't keep track
    }
  }
   
}
