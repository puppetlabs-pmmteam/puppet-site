class profile::windows::registry
(
  String $ntpserver = "time.windows.com",
)

{

#Puppet module for managing base Windows registry settings

# Disable UAC
  registry_value { 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA':
    ensure => 'present',
    data   => ['0'],
    type   => 'dword',
  }

# Configure NTP Server
  registry_value { 'HKLM\SYSTEM\Currentcontrolset\Services\W32time\Parameters\NtpServer':
    ensure => 'present',
    data   => ["$ntpserver,0x9"],
    type   => 'string',
  }

# Disable Windows Firewall

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall':
    ensure => 'present',
    data   => ['0'],
    type   => 'dword',
  }

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall':
    ensure => 'present',
    data   => ['0'],
    type   => 'dword',
  }

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    ensure => 'present',
    data   => ['0'],
    type   => 'dword',
  }


B
A
A
A
A
A
A
A
A
A
A
A
}
