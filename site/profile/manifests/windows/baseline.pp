class profile::baseline {

  class { 'chocolatey': }

  package { 'powershell':
    ensure => latest,
    provider => 'chocolatey',
    install_options => ['-pre', '--ignore-package-exit-codes'],
    notify => Reboot['afterpowershell'],
  }

  reboot { 'afterpowershell':
    when => pending,
  }

  dsc_xtimezone { 'set timezone':
    dsc_timezone => 'Pacific Standard Time',
    dsc_issingleinstance => 'yes',
  }

}
