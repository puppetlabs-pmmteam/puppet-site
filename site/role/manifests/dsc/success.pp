class role::dsc::success {

  include profile::windows::baseline

  # creation of user
  $dsc_user_name = 'Casey'
  dsc_user { $dsc_user_name:
    dsc_ensure                   => present,
    dsc_username                 => $dsc_user_name,
    dsc_description              => 'user account for Casey with DSC',
    # be careful with dsc_passwordchangerequired set to true, once user is created, this cannot be used
    dsc_password                 => { 'user' => $dsc_user_name, 'password' => 'SecurePassword123!'},

    # DSC specific policies
    dsc_passwordchangerequired   => 'false',
    dsc_passwordneverexpires     => 'false',
    dsc_passwordchangenotallowed => 'false',
    dsc_disabled                 => 'false',
    dsc_fullname                 => 'Casey DSC',
  }

  # removal of user
  dsc_user { 'pat':
    dsc_ensure                   => absent,
    dsc_username                 => 'pat',
  }

  # creation of file
  $test_file_contents = 'bar'

  dsc_file { 'tmp_file':
    dsc_ensure => 'present',
    dsc_type            => 'File',
    dsc_destinationpath => 'c:/windows/temp/foo.txt',
    dsc_contents        => $test_file_contents,

    # DSC specific properties
    dsc_force           => true,
    dsc_attributes      => ['Archive'],
  }

  # disabling of Windows Update
  dsc_service { 'Windows Update':
    dsc_ensure         => 'present',
    dsc_name           => 'wuauserv',
    dsc_state          => 'Stopped',
    dsc_startuptype    => 'Manual',
    dsc_builtinaccount => 'LocalSystem',
    # can set these, but not necessary
    dsc_displayname    => 'Windows Update',
    dsc_description    => 'Enables the detection, download, and installation of updates for Windows and other programs. If this service is disabled, users of this computer will not be able to use Windows Update or its automatic updating feature, and programs will not be able to use the Windows Update Agent (WUA) API.',
  }

  # creation of registry values
  dsc_registry { 'registry_test_string':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\\SOFTWARE\\PuppetDSCDemo',
    dsc_valuename => 'TestStringValue',
    dsc_valuedata => 'Dogs',
    dsc_valuetype => 'String',
  }

  # Turn RDP on and enable the firewall exclusion to get in
  dsc_xremotedesktopadmin { 'RemoteDesktopSettings':
     dsc_ensure => 'Present',
     dsc_userauthentication => 'NonSecure',
  } ->
  dsc_xFirewall { 'AllowRDP':
    dsc_name => 'DSC - Remote Desktop Admin Connections',
    dsc_displaygroup => "Remote Desktop",
    dsc_ensure => 'Present',
    dsc_enabled => 'true',
    dsc_action => 'Allow',
    dsc_profile => 'Domain',
  }

  # Install the FTP feature and configure its port
  dsc_windowsfeature { 'FTP':
    dsc_name => 'Web-Ftp-Server',
    dsc_ensure => 'present',
    dsc_includeallsubfeature => 'true',
  }
  ->
  dsc_xFirewall { 'Inbound FTP':
    dsc_name => 'Inbound FTP',
    dsc_ensure => 'present',
    dsc_displayname => 'Inbound FTP Port 21',
    dsc_displaygroup => 'Inbound FTP Port 21 (Puppet DSC Managed)',
    dsc_protocol => 'tcp',
    dsc_remoteport => '21',
    dsc_localport => '21',
    dsc_action => 'Allow',
    dsc_enabled => 'true',
    dsc_direction => 'Inbound',
  }

  # set UTC time zone
  #  Already set in windows::baseline
  # dsc_xtimezone {'timezone':
  #   dsc_issingleinstance => 'Yes',
  #  dsc_timezone => 'UTC',
  # }

  # IIS static content serving
  dsc_file {'c:\\inetpub':
    dsc_ensure => 'present',
    dsc_type => 'directory',
    dsc_destinationpath => 'c:\\inetpub',
  }
  ->
  dsc_windowsfeature {'iis':
    dsc_ensure => 'present',
    dsc_name   => 'web-server',
    dsc_includeallsubfeature => true,
  }
  ->
  dsc_windowsfeature {'iis-tools':
    dsc_ensure => 'present',
    dsc_name   => 'web-mgmt-tools',
    dsc_includeallsubfeature => true,
  }
  ->
  dsc_file {'c:\\inetpub\\testsite':
    dsc_ensure => 'present',
    dsc_type => 'directory',
    dsc_destinationpath => 'c:\\inetpub\\testsite',
  }
  ->
  dsc_file { 'html_hello':
    dsc_ensure => 'present',
    dsc_type            => 'File',
    dsc_destinationpath => 'c:\\inetpub\\testsite\\index.html',
    dsc_contents        => '<html><body>Hello from Puppet + DSC!</body></html>',
  }
  ->
  dsc_xwebsite{'NewWebsite':
    dsc_ensure       => 'Present',
    dsc_state        => 'Started',
    dsc_name         => 'TestSite',
    dsc_physicalpath => 'C:\\inetpub\\testsite',
    dsc_bindinginfo  => {
      'Protocol' => 'HTTP',
      'Port'     => 8089
    },
    # requires v1.2.0 of puppet DSC module
    # dsc_authenticationinfo => {
    #   'Anonymous' => true,
    # }
  }

}
