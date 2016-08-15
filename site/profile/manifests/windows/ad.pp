class profile::windows::ad {

  reboot { 'dsc_reboot' :
    message => 'DSC has requested a reboot',
    apply => 'immediately',
  }

  dsc_windowsfeature { 'rsat-adds':
    ensure => present,
    dsc_name => 'rsat-adds',
  }

  dsc_windowsfeature { 'ad-domain-services':
    ensure => present,
    dsc_name => 'ad-domain-services',
  } ->

  dsc_xaddomain { 'spencer.test':
    ensure => present,
    dsc_domainname => 'spencer.test',
    dsc_domainadministratorcredential =>  { user => 'Administrator', password => 'Puppet123' },
    dsc_safemodeadministratorpassword => { user => 'Administrator', password => 'Puppet123' },
    notify => Reboot['dsc_reboot'],
  }

  dsc_xaddomaincontroller { 'test':
    dsc_domainname => 'spencer.test',
    dsc_domainadministratorcredential =>  { user => 'Administrator', password => 'Puppet123' },
    dsc_safemodeadministratorpassword => { user => 'Administrator', password => 'Puppet123' },
    notify => Reboot['dsc_reboot'],
  }

}
