class profile::iis::cloudshop (
  $root_iis_path  = hiera('profile::iis::baseline::root_iis_path','C:/inetpub'),

  $zip_file_source = hiera('profile::iis::cloudshop::zip_file_source','http://int-resources.ops.puppetlabs.net/PupConf2016/windows_ad_demo/'),
  $zip_file        = hiera('profile::iis::cloudshop::zip_file','CloudShop.zip'),
  $zip_file_local  = hiera('profile::iis::cloudshop::zip_file_local',"C:\\CloudShop-Web.zip"),
  $dbserver        = hiera('profile::iis::cloudshop::dbserver'),
  $dbinstance      = hiera('profile::iis::cloudshop::dbinstance','MSSQLSERVER'),
  $dbname          = hiera('profile::iis::cloudshop::dbname','CloudShop'),
  $dbuser          = hiera('profile::iis::cloudshop::dbuser'),
  $dbpassword      = hiera('profile::iis::cloudshop::dbpassword'),
) {

  $website_path = "${root_iis_path}/cloudshop"
  $website_path_win = regsubst($website_path, '/', '\\','G')
  
  if ($dbinstance == 'MSSQLSERVER') {
    $dbdatasource = $dbserver
  } else {
    $dbdatasource = "${dbserver}\${dbinstance}"
  }

  file { $website_path:
    ensure => 'directory',
    require => File[$root_iis_path],
  }

  # Stage the CloudShop Website
  exec { 'DownloadCloudShopWeb':
    command => "iwr -uri '${zip_file_source}/${zip_file}' -OutFile '${zip_file_local}'",
    provider => powershell,
    creates => $zip_file_local,
  }
  unzip { "CloudShop Web Data ${zip_file}":
    source    => $zip_file_local,
    creates   => "${website_path}\\Global.asax",
    require   => [ File[$website_path], Exec['DownloadCloudShopWeb'] ],
  }  

  # BEGIN Web.config file
  # Strictly speaking this should be in a cloudshop module as a template file
  $web_config_content = @("WEBCONFIG")
<?xml version="1.0"?>
<!--
  For more information on how to configure your ASP.NET application, please visit
  http://go.microsoft.com/fwlink/?LinkId=169433
  -->
<configuration>
  <configSections>
    <!-- For more information on Entity Framework configuration, visit http://go.microsoft.com/fwlink/?LinkID=237468 -->
    <section name="entityFramework" type="System.Data.Entity.Internal.ConfigFile.EntityFrameworkSection, EntityFramework, Version=4.4.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" requirePermission="false"/>
  </configSections>
  <connectionStrings>
  <add name="AdventureWorksEntities" connectionString="metadata=res://*/Models.AdventureWorks.csdl|res://*/Models.AdventureWorks.ssdl|res://*/Models.AdventureWorks.msl;provider=System.Data.SqlClient;provider connection string=&quot;Data Source=${dbdatasource};Initial Catalog=${dbname};;Integrated Security=False;Uid=${dbuser};Password=${dbpassword};multipleactiveresultsets=True;App=EntityFramework&quot;" providerName="System.Data.EntityClient"/>
  <add name="DefaultConnection" connectionString="Data Source=${dbdatasource};initial catalog=${dbname};User Id=${dbuser};Password=${dbpassword};MultipleActiveResultSets=True" providerName="System.Data.SqlClient"/>
  </connectionStrings>
  <appSettings>
    <add key="aspnet:UseTaskFriendlySynchronizationContext" value="true"/>
    <add key="webpages:Version" value="2.0.0.0"/>
    <add key="webpages:Enabled" value="false"/>
    <add key="PreserveLoginUrl" value="true"/>
    <add key="ClientValidationEnabled" value="true"/>
    <add key="UnobtrusiveJavaScriptEnabled" value="true"/>
  </appSettings>
  <system.web>
    <compilation targetFramework="4.0"/>
    <authentication mode="Forms">
      <forms loginUrl="~/Account/Login" timeout="2880"/>
    </authentication>
    <pages>
      <namespaces>
        <add namespace="System.Web.Helpers"/>
        <add namespace="System.Web.Mvc"/>
        <add namespace="System.Web.Mvc.Ajax"/>
        <add namespace="System.Web.Mvc.Html"/>
        <add namespace="System.Web.Optimization"/>
        <add namespace="System.Web.Routing"/>
        <add namespace="System.Web.WebPages"/>
      </namespaces>
    </pages>
    <sessionState mode="InProc" customProvider="DefaultSessionProvider">
      <providers>
        <add name="DefaultSessionProvider" type="System.Web.Providers.DefaultSessionStateProvider, System.Web.Providers, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" connectionStringName="DefaultConnection"/>
      </providers>
    </sessionState>
  </system.web>
  <system.webServer>
    <validation validateIntegratedModeConfiguration="false"/>
    <modules runAllManagedModulesForAllRequests="true"/>
  </system.webServer>
  <runtime>
    <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
      <dependentAssembly>
        <assemblyIdentity name="System.Web.Helpers" publicKeyToken="31bf3856ad364e35"/>
        <bindingRedirect oldVersion="1.0.0.0-2.0.0.0" newVersion="2.0.0.0"/>
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="System.Web.Mvc" publicKeyToken="31bf3856ad364e35"/>
        <bindingRedirect oldVersion="1.0.0.0-4.0.0.0" newVersion="4.0.0.0"/>
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="System.Web.WebPages" publicKeyToken="31bf3856ad364e35"/>
        <bindingRedirect oldVersion="1.0.0.0-2.0.0.0" newVersion="2.0.0.0"/>
      </dependentAssembly>
    </assemblyBinding>
  </runtime>
  <entityFramework>
    <defaultConnectionFactory type="System.Data.Entity.Infrastructure.SqlConnectionFactory, EntityFramework"/>
  </entityFramework>
</configuration>
| WEBCONFIG
  # END Web.config file
  file {"${website_path}/web.config":
    ensure  => present,
    content => $web_config_content,
    require => Unzip["CloudShop Web Data ${zip_file}"],
  }

  dsc_xwebapppool { 'CloudShopAppPool':
    dsc_name                  => 'CloudShopAppPool',
    dsc_ensure                => "Present",
    dsc_state                 => "Started",
    dsc_identitytype          => 'ApplicationPoolIdentity',
    dsc_autostart             => true,
    dsc_managedpipelinemode   => 'Integrated',
    dsc_managedruntimeloader  => 'webengine4.dll',
    dsc_managedruntimeversion => 'v4.0',
  }

  dsc_xwebsite{ 'CloudShopWebSite':
    dsc_ensure       => 'Present',
    dsc_state        => 'Started',
    dsc_name         => 'CloudShop',
    dsc_physicalpath => $website_path_win,
    dsc_applicationpool => 'CloudShopAppPool',
    dsc_preloadenabled => true,
    dsc_bindinginfo  => [{
      'Protocol' => 'HTTP',
      'Port'     => 80
    }],
    require => [ File["${website_path}/web.config"], Dsc_xwebapppool['CloudShopAppPool'], Dsc_xwebsite['DefaultSite'] ],
  }

  # Setup the CloudShop Web Admins
  group { "CloudShopWebAdmins":
    name    => 'Administrators',
    members => 'INTERNAL\CloudShopWebAdmins',
  }
}