class profile::windows::exchange {

  reboot { 'dsc_reboot':
    message => 'DSC has requested a reboot',
    when => pending,
  }

  file { 'C:\temp':
    ensure => directory,
  }

  file { 'C:\temp\Exchange-x64.exe':
    ensure => file,
    source => 'puppet:///modules/profile/Exchange-x64.exe',
  }

  file { 'C:\temp\UcmaRuntimeSetup.exe':
    ensure => file,
    source => 'puppet:///modules/profile/UcmaRuntimeSetup.exe',
  }

  exec { 'Exchange':
    command => 'C:\temp\Exchange-x64.exe /extract:C:\exchange /u',
    creates => 'C:\exchange',
    provider => 'powershell',
  }

  service { 'lmhosts':
    ensure => running,
    enable => true,
  }

  service { 'dnscache':
    ensure => running,
    enable => true,
  }

  service { 'browser':
    ensure => running,
    enable => true,
  }

  service { 'iphlpsvc':
    ensure => running,
    enable => true,
  }

#  service { 'smsvchost':
#    ensure => running,
#    enable => true,
#  }

  package { 'Microsoft Unified Communications Managed API 4.0, Runtime':
    ensure => installed,
    source => 'C:\temp\UcmaRuntimeSetup.exe',
    install_options => ['/passive', '/norestart'],
    require => File['C:\temp\UcmaRuntimeSetup.exe'],
  }

  dsc_windowsfeature { 'rpc-over-http-proxy':
    dsc_ensure => 'present',
    dsc_name => 'rpc-over-http-proxy',
  }

  dsc_windowsfeature { 'rsat-adds':
    dsc_ensure => 'present',
    dsc_name => 'rsat-adds',
  }

  dsc_windowsfeature { 'net-wcf-services45':
    dsc_ensure => 'present',
    dsc_name => 'net-wcf-services45',
    dsc_includeallsubfeature => 'true',
  }

  dsc_windowsfeature { 'web-performance':
    dsc_ensure => 'present',
    dsc_name => 'web-performance',
    dsc_includeallsubfeature => 'true',
  }

  dsc_windowsfeature { 'web-security':
    dsc_ensure => 'present',
    dsc_name => 'web-security',
    dsc_includeallsubfeature => 'true',
  }

  dsc_windowsfeature { 'web-http-tracing':
    dsc_ensure => 'present',
    dsc_name => 'web-http-tracing',
    dsc_includeallsubfeature => 'true',
  }

  dsc_windowsfeature { 'web-mgmt-tools':
    dsc_ensure => 'present',
    dsc_name => 'web-mgmt-tools',
    dsc_includeallsubfeature => 'true',
  }

  dsc_windowsfeature { 'desktop-experience':
    dsc_ensure => 'present',
    dsc_name => 'desktop-experience',
  }

  dsc_windowsfeature { 'web-mgmt-compat':
    dsc_ensure => 'present',
    dsc_name => 'web-mgmt-compat',
    dsc_includeallsubfeature => 'true',
  }

  dsc_xdnsserveraddress { 'add domain':
    ensure => present,
    dsc_addressfamily => 'IPv4',
    dsc_address => '10.32.167.71',
    dsc_interfacealias => 'Ethernet',
  }

  dsc_xdnsconnectionsuffix { 'add suffix':
    ensure => present,
    dsc_interfacealias => 'Ethernet',
    dsc_usesuffixwhenregistering => 'True',
    dsc_registerthisconnectionsaddress => 'True',
    dsc_connectionspecificsuffix => 'spencer.test',
  }

  dsc_xcomputer { 'config':
    dsc_name => 'exchangeserver',
    dsc_domainname => 'spencer.test',
    dsc_credential => { user => 'spencer.test\Administrator', password => 'Puppet123' },
  }

  dsc_xexchinstall { 'install exchange':
    ensure => present,
    dsc_path => 'C:\exchange\setup.exe',
    dsc_credential => { user => 'spencer.test\Administrator', password => 'Puppet123' },
    dsc_arguments => "/mode:Install /role:Mailbox,ClientAccess /OrganizationName:puppet /Iacceptexchangeserverlicenseterms",
    require => Exec['Exchange'],
  }

}
