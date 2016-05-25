class profile::pe_master {
  class { 'sudo':
    secure_path => '/opt/puppet/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  sudo::rule { "r10k_rule":
    ensure => present,
    who    => 'peadmin',
    runas  => 'root',
    commands => '/opt/puppet/bin/r10k deploy environment -p *',
    nopass   => true,
    comment  => 'Allow peadmin to deploy environments',
  }

  sudo::rule { "pe_puppetserver_restart_rule":
    ensure => present,
    who    => 'peadmin',
    runas  => 'root',
    commands => '/sbin/service pe-puppetserver restart',
    nopass   => true,
    comment  => 'Allow peadmin to restart the puppetserver service',
  }

  sudo::rule { "vagrant":
    ensure   => present,
    who      => 'vagrant',
    runas    => 'ALL',
    commands => 'ALL',
    nopass   => true,
  }
}
