class profile::mssql::cloudshop(
  $dbinstance      = hiera('profile::mssql::cloudshop::dbinstance','MSSQLSERVER'),
  $dbname          = hiera('profile::mssql::cloudshop::dbname','CloudShop'),
  $zip_file_source = hiera('profile::mssql::cloudshop::zip_file_source','http://int-resources.ops.puppetlabs.net/PupConf2016/windows_ad_demo/'),
  $zip_file        = hiera('profile::mssql::cloudshop::zip_file','AdventureWorks2012.zip'),
  $zip_file_local  = hiera('profile::mssql::cloudshop::zip_file_local',"C:\\CloudShop.zip"),
  $data_path       = hiera('profile::mssql::cloudshop::data_path',"C:\\Program Files\\Microsoft SQL Server\\MSSQL11.${$dbinstance}\\MSSQL\\DATA"),
  $mdf_file        = hiera('profile::mssql::cloudshop::mdf_file','AdventureWorks2012_Data.mdf'),
  $ldf_file        = hiera('profile::mssql::cloudshop::ldf_file','AdventureWorks2012_log.ldf'),
) {
  # Download and stage the CloudShop Database
  file { $data_path:
    ensure => 'directory',
  }
  exec { 'DownloadCloudShopDB':
    command => "iwr -uri '${zip_file_source}/${zip_file}' -OutFile '${zip_file_local}'",
    provider => powershell,
    creates => $zip_file_local,
  }
  unzip { "SQL Data ${zip_file}":
    source    => $zip_file_local,
    creates   => "${data_path}\\${mdf_file}",
    require   => [ File[$data_path], Exec['DownloadCloudShopDB'] ],
  }

  # Setup permissions on the extracted files
  acl { "${data_path}\\${mdf_file}":
    permissions => [
      { identity => "NT SERVICE\\${dbinstance}", rights => ['full'] },
    ],
    require     => Unzip["SQL Data ${zip_file}"],
  }
  acl { "${data_path}\\${ldf_file}":
    permissions => [
      { identity => "NT SERVICE\\${dbinstance}", rights => ['full'] },
    ],
    require     => Unzip["SQL Data ${zip_file}"],
  }

  # Attach staged CloudShop Database if it doesn't already exist
  sqlserver_tsql{ 'Create CloudShopDB': 
    instance => $dbinstance, 
    command  => "CREATE DATABASE [${dbname}] ON (FILENAME='${data_path}\\${mdf_file}'),(FILENAME='${data_path}\\${ldf_file}') FOR ATTACH",
    onlyif   => "DECLARE @currentDB as varchar(255); SET @currentDB = (SELECT [name] from sys.databases where [name] = '${dbname}'); IF (@currentDB IS NULL) THROW 50000, 'CloudShop is missing', 10;",
    require  => [ Acl["${data_path}\\${mdf_file}"], Acl["${data_path}\\${ldf_file}"] ],
  }  

  # Create login for the Web Servers
  sqlserver::login{ 'cloudshop_login':
    instance  => $dbinstance,
    login_type => 'SQL_LOGIN',
    password   => 'puppetCloud123',
  }

  sqlserver::user{ "cloudshop_login_User":
    instance => $dbinstance,
    login    => 'cloudshop_login',
    database => $dbname,
    require  => [ Sqlserver::Login['cloudshop_login'], Sqlserver_tsql['Create CloudShopDB'] ],
  }  

  # Create SQL Admin login
  sqlserver::login{ 'INTERNAL\CloudShopSQLAdmins':
    instance  => $dbinstance,
    login_type => 'WINDOWS_LOGIN',
  }

  sqlserver::user{ "CloudShopSQLAdmins_User":
    instance => $dbinstance,
    login    => 'INTERNAL\CloudShopSQLAdmins',
    database => $dbname,
    require  => [ Sqlserver::Login['INTERNAL\CloudShopSQLAdmins'], Sqlserver_tsql['Create CloudShopDB'] ],
  }  

  # SQL db_owners
  sqlserver::role { "${dbname}_db_owner":
    database  => $dbname,
    instance  => $dbinstance,
    type      => 'DATABASE',
    role      => 'db_owner',
    members   => ['cloudshop_login_User','CloudShopSQLAdmins_User'],
    require  => [ Sqlserver::User["cloudshop_login_User"], Sqlserver::User["CloudShopSQLAdmins_User"] ],
  }  
  
}
