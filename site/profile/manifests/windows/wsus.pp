class profile::windows::wsus 
(
  String $wsus_server = "wsus-server", 
)

# Puppet module for configuring a WSUS client on Windows Server 2012 R2
# Sets up a custom fact from $modules/puppetconf_wsus called windows_updates

{

  file { 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate':
    ensure => directory,
  }

  file { 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate\Get-PendingUpdate.ps1':
    ensure => present,
    source => 'puppet:///modules/puppetconf_wsus/Get-PendingUpdate.ps1',
    require => File['C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate'],
  }

  class { 'wsus_client':
    server_url             => "http://$wsus_server:8530",
    auto_update_option     => "Scheduled",
    scheduled_install_day  => "Tuesday",
    scheduled_install_hour => 2,
  }

}
