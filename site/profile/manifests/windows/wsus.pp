class profile::windows::wsus {

  file { 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate':
    ensure => directory,
  }

  file { 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate\Get-PendingUpdate.ps1':
    ensure => present,
    source => 'puppet:///modules/profile/Get-PendingUpdate.ps1',
    require => File['C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate'],
  }

  class { 'wsus_client':
    server_url             => 'http://wsus-server:8530',
    auto_update_option     => "Scheduled",
    scheduled_install_day  => "Tuesday",
    scheduled_install_hour => 2,
  }

}
