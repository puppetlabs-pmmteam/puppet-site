class profile::baseline {

  class { 'chocolatey':
    notify => Reboot['afterchocolatey'],
  }

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

  exec { 'rename-admin':
    command   => '$(Get-WMIObject Win32_UserAccount -Filter "Name=\'Administrator\'").Rename("PuppetAdmin")',
    unless    => 'if (Get-WmiObject Win32_UserAccount -Filter "Name=\'Administrator\'") { exit 1 }',
    provider  => powershell,
  }

}
