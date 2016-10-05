class profile::mssql::baseline(
  $iso_download_url  = hiera('profile::mssql::baseline::iso_download_url'),
  $iso_name          = hiera('profile::mssql::baseline::iso_name'),
  $sqlserver_version = hiera('profile::mssql::baseline::sqlserver_version'),

  $sa_password = hiera('profile::mssql::baseline::sa_password'),
  $db_admin_group = hiera('profile::mssql::baseline::db_admin_group'),

  $sqlmaxmem = hiera('profile::mssql::baseline::sqlmaxmem',2048),
) {

  $dbinstance = 'MSSQLSERVER'
  case $sqlserver_version {
    '2012':  {
      $version_var  = 'MSSQL11'
    }
    '2014':  {
      $version_var  = 'MSSQL12'
    }
  }

  # Download and mount the SQL Server installation media
  $local_iso_path = "C:/${iso_name}"
  pget { "mssql_baseline_download sql ${sqlserver_version} ISO":
    source  => $iso_download_url,
    target  => 'C:',
    timeout => 150000,
  }
  mount_iso { $local_iso_path:
    drive_letter => 'S',
    require      => Pget["mssql_baseline_download sql ${sqlserver_version} ISO"],
  } ->

  # Install an instance of SQL Server
  sqlserver_instance{ $dbinstance:
    source                  => 'S:/',
    features                => ['SQL'],
    security_mode           => 'SQL',
    sa_pwd                  => $sa_password,
    sql_sysadmin_accounts   => ['Administrator'],
    install_switches        => {
      'TCPENABLED'          => 1,
      'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
      'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
      'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
      'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
      'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
    },
  } ->

  # Install the Management Tools
  sqlserver_features { 'Generic Features':
    source   => 'S:/',
    features => ['Tools'],
    require  => Sqlserver_instance[$dbinstance],
  }

  # Setup DB Config for subsequent management resources
  sqlserver::config{ $dbinstance :
    admin_user       => 'sa',
    admin_pass       => $sa_password,
    admin_login_type => 'SQL_LOGIN',
  }  

  # Setup sysadmin
  sqlserver::login{ $db_admin_group :
    instance   => $dbinstance,
    login_type  => 'WINDOWS_LOGIN',
    svrroles    => { 'sysadmin' => 1 },
  }

  # Set SQL Max Memory to 2GB
  sqlserver_tsql{ 'Set Max Memory': 
    instance => $dbinstance, 
    command => "EXEC sp_configure'Show Advanced Options',1; RECONFIGURE; EXEC sp_configure'max server memory (MB)',$sqlmaxmem; RECONFIGURE;", 
    onlyif => "DECLARE @currentMem as int = 0;SET @currentMem = (SELECT CONVERT(int,value) as value FROM sys.configurations WHERE name = 'max server memory (MB)'); IF (@currentMem != $sqlmaxmem) THROW 50000, 'Memory needs to be set', 10"
  }

  # Enable the firewall rules
  dsc_xfirewall { 'SQL Browser Access':
    dsc_name        => 'SQL Browser Access',
    dsc_ensure      => 'present',
    dsc_enabled     => 'true',
    dsc_action      => 'Allow',
    dsc_profile     => ["Domain", "Private"],
    dsc_direction   => 'Inbound',
    dsc_description => "MS SQL Server Browser Inbound Access, enabled by Puppet in $module_name",
    dsc_program     => 'C:\Program Files (x86)\Microsoft SQL Server\90\Shared\sqlbrowser.exe',
  }
  dsc_xfirewall { 'SQL Server Service Access':
    dsc_name        => 'SQL Server Service Access',
    dsc_ensure      => 'present',
    dsc_enabled     => 'true',
    dsc_action      => 'Allow',
    dsc_profile     => ["Domain", "Private"],
    dsc_direction   => 'Inbound',
    dsc_description => "MS SQL Server Service Inbound Access, enabled by Puppet in $module_name",
    dsc_program     => "C:\\Program Files\\Microsoft SQL Server\\${version_var}.${dbinstance}\\MSSQL\\Binn\\sqlservr.exe",
  }
}
